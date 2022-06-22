#!/bin/bash
# if a folder exist by option -p, then I will run the stow command
mkdir -p ~/.config/nvim
stow --target "$HOME" --restow dotfiles

