### example install steps where this repo is checked out to $DOTFILES
```
brew install stow
cd $DOTFILES
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
stow --no-folding --verbose --target=$HOME zsh git codex kiro-agents
```

Canonical checkout path:

```
~/repos/github.com/bmenaman/dotfiles
```

See `repo-migration.md` when updating a machine that still points at `~/repos/bmenaman/dotfiles`.

### agent rules
`agents-init` is on `$PATH` via `$DOTFILES/agents/bin` (set in `.zshrc`).

Run `agents-init` from the root of any repo to create:
1. `AGENTS.md` - symlink to `$DOTFILES/agents/AGENTS.md`
2. `agents/` directory with symlinks to all rule files from `$DOTFILES/agents/*.md`

The symlinked `AGENTS.md` is ignored globally via `~/.config/git/ignore`.
To track it in a specific repo instead, add `!AGENTS.md` to that repo's `.gitignore`.

Codex loads the global agent rules from `~/.codex/AGENTS.md`; stow the `codex` package to link that file from this repo. Kiro loads the same rules from `~/.kiro/steering/AGENTS.md`; stow `kiro-agents` for that link without taking over Kiro settings.
