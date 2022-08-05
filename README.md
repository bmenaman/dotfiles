### example install steps where this repo is checked out to $DOTFILES
```
brew install stow
cd $DOTFILES
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
stow --no --verbose --target=$HOME zsh
```
