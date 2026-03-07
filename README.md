### example install steps where this repo is checked out to $DOTFILES
```
brew install stow
cd $DOTFILES
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
stow --no --verbose --target=$HOME zsh
```

### agent rules
`agents-init` is on `$PATH` via `$DOTFILES/agents/bin` (set in `.zshrc`). It will setup default Agent rules in a repo.

Run `agents-init` from the root of any repo to either:
1. No `AGENTS.md` present: symlinks to `$DOTFILES/agents/AGENTS.md`
2. `AGENTS.md` already exists: prepends a prose reference to the dotfiles copy

The symlinked `AGENTS.md` is ignored globally via `~/.config/git/ignore`.
To track it in a specific repo instead, add `!AGENTS.md` to that repo's `.gitignore`.
