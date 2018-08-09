#!/bin/bash
#copies config folder and other files to git repository
CONFIG_DIR="/home/lucca/.config"
REPO="/home/lucca/Repos/RICE"
echo "Copying .config folders"
cp -r $CONFIG_DIR/ranger $REPO/.config
cp -r $CONFIG_DIR/i3 $REPO/.config
cp -r $CONFIG_DIR/qutebrowser $REPO/.config
cp -r $CONFIG_DIR/polybar $REPO/.config
cp -r $CONFIG_DIR/neofetch $REPO/.config
echo "Copying vim urxvt and bash files"
cp -r /home/lucca/.urxvt $REPO
cp -r /home/lucca/.vim $REPO
cp /home/lucca/.vimrc $REPO
cp /home/lucca/.bash_aliases $REPO
cp /home/lucca/.bash_profile $REPO
cp /home/lucca/.bashrc  $REPO
cp /home/lucca/.Xresources $REPO
cp /home/lucca/.Xauthority $REPO
