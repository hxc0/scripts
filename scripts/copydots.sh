#!/bin/bash

cpwd=$PWD

repop="$HOME/Documents/repos/dotfiles"

cd $repop
git pull

cp --force $HOME/.vim/colors/doranged.vim $repop/.vim/colors/
cp --force -r $HOME/Pictures/wp/* $repop/Pictures/wp/
cp --force $HOME/.i3/config $repop/.i3/
cp --force $HOME/.gdbinit $repop
cp --force $HOME/.vimrc $repop
cp --force /usr/bin/lock.sh $repop
cp --force $HOME/.xbindkeysrc $repop
cp --force $HOME/.xinitrc $repop
cp --force $HOME/.zshrc $repop
cp --force -r $HOME/.config/htop/* $repop/.config/htop
cp --force -r $HOME/.config/neofetch/* $repop/.config/neofetch
cp --force -r $HOME/.config/polybar/* $repop/.config/polybar
cp --force -r $HOME/.config/ranger/* $repop/.config/ranger
cp --force -r $HOME/.config/xfce4/* $repop/.config/xfce4

git add .
git status
read -p "Please enter commit message: " msg
git commit -m "$msg"
git push
cd $PWD
