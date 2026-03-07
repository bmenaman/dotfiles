# Tasks: Global AGENTS.md

## 1. Create the canonical AGENTS.md in dotfiles repo
- [x] Create `agents/AGENTS.md` with global coding conventions, workflow preferences, and architectural guidance
- [x] Review and curate content from existing project-specific AGENTS.md files (e.g. pycalc)
- Verify: `cat $DOTFILES/agents/AGENTS.md` shows the expected content ✓

## 2. Create the install script
- [x] Write `agents/bin/agents-init` shell script with two modes:
  - No `AGENTS.md` in cwd: symlink to `$DOTFILES/agents/AGENTS.md`
  - Existing `AGENTS.md` in cwd: prepend prose reference to global file (with idempotency check)
- [x] Support `$DOTFILES_LOCAL/agents/AGENTS.md` override — use local copy if it exists
- [x] Handle edge cases: symlink already exists, file is already a symlink to the global one
- Verify (symlink mode): symlink created, points to dotfiles copy ✓
- Verify (prepend mode): `head -1 AGENTS.md` shows the prose reference ✓
- Verify (idempotent): re-run returns "nothing to do" ✓
- Verify (local override): supported via `$DOTFILES_LOCAL` check in script ✓

## 3. Make the script available on PATH
- [x] Stow `agents/bin/agents-init` to `~/bin/` using `--no-folding`
- [x] Script is executable
- Verify: `which agents-init` → `/Users/roger/bin/agents-init` ✓
- Verify: `agents-init --help` runs without "command not found" ✓

## 4. Handle gitignore for symlinked repos
- [x] Added `AGENTS.md` to `~/.config/git/ignore` (XDG default, no config needed)
- [x] Documented `!AGENTS.md` override in README
- Verify (ignored): `git status` in test repo shows nothing after symlink created ✓

## 5. Test across tools
- Verify: open a repo with symlinked AGENTS.md in each tool and confirm rules are applied

## 6. Document
- [x] Updated `README.md` with stow command and `agents-init` usage
- Verify: README instructions are accurate and complete ✓
