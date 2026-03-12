### example install steps where this repo is checked out to $DOTFILES
```
brew install stow
cd $DOTFILES
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
stow --no-folding --verbose --target=$HOME zsh
stow --no-folding --verbose --target=$HOME kiro
```

### agent rules
`agents-init` is on `$PATH` via `$DOTFILES/agents/bin` (set in `.zshrc`).

Run `agents-init` from the root of any repo to create:
1. `AGENTS.md` - symlink to `$DOTFILES/agents/AGENTS.md`
2. `agents/` directory with symlinks to all rule files from `$DOTFILES/agents/*.md`

The symlinked `AGENTS.md` is ignored globally via `~/.config/git/ignore`.
To track it in a specific repo instead, add `!AGENTS.md` to that repo's `.gitignore`.
