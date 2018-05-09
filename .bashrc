case $- in
  *i*) ;;
  *) return;;
esac

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

export DOTFILES_LOCAL=~/bin/dotfiles_local
export DOTFILES=~/dev/repos/dotfiles
source $DOTFILES/bash/bashrc
