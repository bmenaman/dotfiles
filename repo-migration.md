# Dotfiles Repo Migration

The canonical dotfiles checkout moved from:

```text
~/repos/bmenaman/dotfiles
```

to:

```text
~/repos/github.com/bmenaman/dotfiles
```

On each machine, update the checkout and restow the packages:

```bash
mkdir -p ~/repos/github.com/bmenaman

if [ -d ~/repos/bmenaman/dotfiles ] && [ ! -e ~/repos/github.com/bmenaman/dotfiles ]; then
  mv ~/repos/bmenaman/dotfiles ~/repos/github.com/bmenaman/dotfiles
elif [ ! -d ~/repos/github.com/bmenaman/dotfiles ]; then
  jj git clone git@github.com:bmenaman/dotfiles.git ~/repos/github.com/bmenaman/dotfiles
fi

cd ~/repos/github.com/bmenaman/dotfiles
stow --no-folding --verbose --target="$HOME" zsh git codex kiro-agents
```

Then start a new shell and verify:

```bash
echo "$DOTFILES"
readlink ~/.zshrc
readlink ~/.codex/AGENTS.md
readlink ~/.kiro/steering/AGENTS.md
```

Expected `DOTFILES`:

```text
$HOME/repos/github.com/bmenaman/dotfiles
```

If old symlinks are broken, remove only those symlinks and restow:

```bash
unlink ~/.zshrc
unlink ~/.config/git/config
unlink ~/.config/git/ignore
stow --no-folding --verbose --target="$HOME" zsh git codex kiro-agents
```

Do not remove real files or directories when cleaning up stale links.
