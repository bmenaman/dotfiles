# Problem: Portable Agent Rules Across Agentic Coding Tools

## Goals

1. Maintain a version-controlled set of personal agent rules (coding conventions, workflow preferences, architectural guidance) in a dotfiles repo.
2. Make it as simple as possible for those rules to apply automatically, ideally without per-repo setup, as a baseline default.
3. Allow individual repos to extend or override the baseline with project-specific rules.
4. Support the same rules across multiple agentic coding tools (Claude Code, Codex CLI, Gemini CLI, Cursor, Windsurf, Kiro, GitHub Copilot, etc.).

## Constraints

### C1: No standard "extend" or "source" mechanism

AGENTS.md is plain Markdown. There is no `source`, `import`, or `include` directive in the AGENTS.md spec itself. A repo-level AGENTS.md cannot programmatically inherit from or extend a global one. Some tools have proprietary import syntax (Claude Code's `@path` imports, Gemini CLI's `@file.md` imports), but these are tool-specific and not portable.

### C2: Tools differ in how they resolve AGENTS.md

The critical split is between tools that additively merge files found at multiple levels of the directory hierarchy and tools that only look in the project root (or their own config location). This means a single strategy cannot produce identical behaviour across all tools. See Appendix A for details.

### C3: Project-local AGENTS.md completely shadows home-level for non-merging tools

For tools that do not walk the directory tree, a repo-level AGENTS.md is the only one loaded. The home-level copy is invisible. Extension only works if the repo copy explicitly tells the agent to read the home copy — and even then, compliance depends on the agent honouring a prose instruction, not a deterministic file-loading mechanism.

### C4: Tools that do merge still apply "nearest wins" for conflicts

Even for tools that walk up and concatenate (Claude Code, Codex CLI, Gemini CLI), closer files take precedence. The global baseline is additive only when it doesn't conflict with the project-level file. There is no way to mark global rules as mandatory.

### C5: Each tool has its own native config format

Several tools have their own proprietary configuration that does not read AGENTS.md at all, or reads it alongside their own format. Symlinks or copies of AGENTS.md do not cover these tools. See Appendix B.

### C6: Stow constraints

This dotfiles repo uses GNU Stow. Each top-level directory is a stow package, and files inside mirror the target structure relative to `$HOME`. Stowing `~/AGENTS.md` requires the repo path `agents/AGENTS.md`. Supplementary files in the same stow package would land directly in `$HOME` (e.g. `~/bdd.md`), which is undesirable. Nesting them as `agents/agents/bdd.md` → `~/agents/bdd.md` is ugly but functional.  


---

## Appendix A: AGENTS.md Loading Behaviour by Tool

### Claude Code
- Native file: `CLAUDE.md` (also reads `AGENTS.md` if present via symlink convention)
- Global location: `~/.claude/CLAUDE.md` (user-level instructions)
- Hierarchy: Walks up from cwd to filesystem root, loading `CLAUDE.md` and `CLAUDE.local.md` at each level. All found files are concatenated additively. Subdirectory files load on demand.
- Merging: Yes — additive. Closer files take precedence on conflict.
- Import mechanism: `@path/to/file` syntax in CLAUDE.md expands referenced files into context. Supports relative and absolute paths, max 5 hops deep.
- Also supports: `.claude/rules/*.md` with optional glob-based path scoping via YAML frontmatter.
- Source: [Anthropic docs](https://docs.anthropic.com/en/docs/claude-code/memory)

### OpenAI Codex CLI
- Native file: `AGENTS.md`
- Global location: `~/.codex/AGENTS.md` (loaded every session)
- Hierarchy: Walks from project root down to cwd, loading AGENTS.md at each directory level. Scope of each file is the directory tree rooted at its containing folder.
- Merging: Yes — concatenated root-downward. Closer files can override earlier guidance.
- Import mechanism: None documented.
- Source: [OpenAI Codex docs](https://github.com/openai/codex), [community reports](https://tech-bridge-log.com/blog/codex-cli-latest-gpt5)

### Gemini CLI
- Native file: `GEMINI.md`
- Global location: `~/.gemini/GEMINI.md`
- Hierarchy: Loads global file, then walks from cwd up to project root (identified by `.git`), then scans subdirectories below cwd. All found files concatenated.
- Merging: Yes — fully additive across all levels.
- Import mechanism: `@file.md` syntax for modular imports. Supports relative and absolute paths.
- Configurable filename: `settings.json` can set `context.fileName` to `["AGENTS.md", "GEMINI.md"]` etc.
- Source: [Gemini CLI docs](https://google-gemini.github.io/gemini-cli/docs/cli/gemini-md.html)

### Cursor
- Native file: `.cursor/rules/*.mdc` files (with frontmatter for scoping)
- AGENTS.md support: Yes — reads `AGENTS.md` at project root (always-on) and in subdirectories (scoped by glob).
- Global location: User-level rules exist in Cursor settings, but no `~/AGENTS.md` loading.
- Hierarchy: Project root and subdirectories within the workspace only. Does not walk above the project root.
- Merging: Within the project, yes. No merging with anything outside the workspace.
- Source: [Cursor docs](https://docs.cursor.com/context/rules-for-ai), [forum confirmation](https://forum.cursor.com/t/support-agents-md/133414)

### Windsurf
- Native file: `.windsurf/rules/` (with frontmatter for activation mode)
- AGENTS.md support: Yes — reads `AGENTS.md` / `agents.md` in project directories.
- Global location: None for AGENTS.md. Global rules via Windsurf's own memories/rules system.
- Hierarchy: Scans workspace and subdirectories. For git repos, also searches parent directories up to git root. Root-level file is always-on; subdirectory files scoped by `<directory>/**`.
- Merging: Within the project tree, yes. No home-directory loading.
- Source: [Windsurf docs](https://docs.windsurf.com/windsurf/cascade/agents-md)

### GitHub Copilot
- Native file: `.github/copilot-instructions.md`, plus `.github/agents/*.agent.md` for custom agents
- AGENTS.md support: Yes — reads `AGENTS.md` at repo root as equivalent to `copilot-instructions.md`.
- Global location: `~/.github/prompts/` for user-level instructions. Repo takes precedence over home.
- Hierarchy: Repo-level only. Does not walk parent directories.
- Merging: Repo-level overrides user-level for conflicts.
- Source: [GitHub docs](https://docs.github.com/en/copilot), [community reports](https://blog.cloud-eng.nl/2025/12/22/copilot-customization/)

### Kiro
- Native file: `.kiro/steering/*.md` (workspace-level), `~/.kiro/steering/*.md` (global user-level)
- AGENTS.md support: Yes — reads `AGENTS.md` from `~/.kiro/steering/` or workspace root.
- Hierarchy: Global steering + workspace steering. Steering files support `inclusion: auto` (always), `inclusion: fileMatch` (conditional), or `inclusion: manual` (user-invoked).
- Merging: Global and workspace steering are both loaded.
- Import mechanism: `#[[file:<relative_file_name>]]` syntax for referencing other files.
- Source: [Kiro changelog](https://kiro.dev/changelog/ide/0-5/), [Kiro docs](https://kiro.dev/docs/steering/)

## Appendix B: Summary of Global vs Project Loading

| Tool            | Reads AGENTS.md | Has global/home location       | Walks up tree | Additive merge |
|-----------------|------------------|--------------------------------|---------------|----------------|
| Claude Code     | Via symlink      | `~/.claude/CLAUDE.md`          | Yes           | Yes            |
| Codex CLI       | Yes              | `~/.codex/AGENTS.md`           | Yes           | Yes            |
| Gemini CLI      | Configurable     | `~/.gemini/GEMINI.md`          | Yes           | Yes            |
| Cursor          | Yes              | No (user settings only)        | No            | No             |
| Windsurf        | Yes              | No (own rules system)          | To git root   | Within project |
| GitHub Copilot  | Yes              | `~/.github/prompts/`           | No            | Repo overrides |
| Kiro            | Yes (steering)   | `~/.kiro/steering/`            | N/A           | Yes            |
