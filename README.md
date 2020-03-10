### example install steps where this repo is checked out to $DOTFILES
brew install stow
cd $DOTFILES
stow --no --verbose --target=$HOME zsh
