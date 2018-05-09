#!/bin/bash

for f in lib env config aliases finally
do
  [ -e $DOTFILES/$f ] && source $DOTFILES/$f
  [ -e $DOTFILES_LOCAL/$f ] && source $DOTFILES_LOCAL/$f
done
