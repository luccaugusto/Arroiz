#!/bin/bash
#Copies git files to home
HOME="/home/lucca"

cp -r $HOME/Repos/RICE/.config/* $HOME
cp -r $HOME/Repos/RICE/.scripts $HOME
cp -r $HOME/Repos/RICE/.urxvt $HOME
cp -r $HOME/Repos/RICE/.vim $HOME
cp $HOME/Repos/RICE/.vimrc $HOME
cp $HOME/Repos/RICE/.Xresources $HOME
cp $HOME/Repos/RICE/.Xauthority $HOME
cp $HOME/Repos/RICE/.bash_aliases $HOME
cp $HOME/Repos/RICE/.bash_profile $HOME
cp $HOME/Repos/RICE/.bashrc $HOME