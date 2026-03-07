# Tasks: Global AGENTS.md

## 1. Create the canonical AGENTS.md in dotfiles repo
- [ ] Create `agents/AGENTS.md` with global coding conventions, workflow preferences, and architectural guidance
- [ ] Review and curate content from existing project-specific AGENTS.md files (e.g. pycalc)

## 2. Create the install script
- [ ] Write `agents/bin/agents-init` shell script with two modes:
  - No `AGENTS.md` in cwd: symlink to `$DOTFILES/agents/AGENTS.md`
  - Existing `AGENTS.md` in cwd: prepend prose reference to global file (with idempotency check)
- [ ] Support `$DOTFILES_LOCAL/agents/AGENTS.md` override — use local copy if it exists
- [ ] Handle edge cases: symlink already exists, file is already a symlink to the global one, in that case provide an interactive choice to allow leaving it alone or replacing

## 3. Make the script available on PATH
- [ ] Stow `agents/bin/agents-init` to `~/bin/` (already on PATH)
- [ ] Ensure script is executable

## 4. Handle gitignore for symlinked repos
- [ ] Add `AGENTS.md` to global gitignore (`~/.config/git/ignore`) so symlinked copies don't show as untracked
- [ ] Document that repos with a committed AGENTS.md are unaffected (case 2 modifies the tracked file directly)

## 5. Test across tools
- [ ] Verify idempotency — re-running the script doesn't duplicate the reference line

## 6. Document
- [ ] Update dotfiles `README.md` with usage instructions for `agents-init`
