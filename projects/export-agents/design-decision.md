# Global AGENTS.md Design Decision

## Decision

Keep a canonical `AGENTS.md` in the dotfiles repo. Provide a single script, installed to `$PATH`, that is run manually when entering a repo. The script does one of two things:

- If the repo has no `AGENTS.md`: symlink to the dotfiles copy.
- If the repo already has an `AGENTS.md`: prepend a prose instruction telling the agent to also read the global file at its absolute path. This relies on the LLM's file-reading capability rather than any tool-specific import mechanism.

## Benefits

- Single source of truth: one file in the dotfiles repo, version-controlled.
- Works across all tools uniformly via the project-level file — no dependency on tool-specific global config locations that may or may not exist.
- The prose contract is tool-agnostic — it's an instruction to an LLM, not a tool-specific directive.
- Symlinks mean updates to the global file propagate instantly with no rebuild or copy drift.
- Per-repo setup is a single manual command. Explicit and predictable — no magic hooks or background processes.
- The script is idempotent — safe to re-run.
- `$DOTFILES_LOCAL` override for org-specific rules fits naturally.

## Alternatives Considered

### Discussed in detail, ruled out

**Stow-only approach** — Stow `~/AGENTS.md` and supplementary files directly to home. Attractive because it reuses the existing dotfiles pattern. Ruled out because: tools that don't walk the directory tree (Cursor, Windsurf) would never see `~/AGENTS.md`; supplementary files would land loose in `$HOME`; and the stow package structure gets awkward when targeting multiple tool-specific config directories simultaneously.

**direnv-based cd hook** — Use direnv's shell hook to create a symlink to the global AGENTS.md on every `cd` into a project directory. Appealing because direnv is already installed and the hook fires automatically. Ruled out because: it only fires in the shell (IDE-launched workflows bypass it entirely); using direnv for filesystem side effects is an abuse of its design; and it could create surprising behaviour as complexity grows. It would violate the principle of least-surprise

**Git template directory** — Inject AGENTS.md into every new clone via `git init.templateDir`. Solves the zero-setup goal for new repos. Ruled out because: it's a snapshot at clone time, not a live link; existing clones don't benefit; and refreshing all clones when rules change requires a separate script anyway.

### Considered, ruled out quickly

**FUSE/bindfs filesystem overlay** — Transparently inject AGENTS.md into any directory lacking one. Operationally heavy, macOS FUSE support is fragile. Operating system dependent

**Git smudge/clean filter** — Inject global rules into AGENTS.md at checkout. Clever but fragile; mutates working tree content and confuses `git status`.

**Generate self-contained AGENTS.md per repo (build step)** — Concatenate global + project rules into a committed file. Creates copy drift and duplication.

**Git global hooks (post-checkout)** — Similar to direnv approach but via git. Only fires on checkout/merge, not on initial open; still requires a refresh mechanism. Potentially 

