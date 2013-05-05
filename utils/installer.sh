#!/bin/sh

if [ -d $HOME/.vim ]
then
    cd ~/.vim ; git pull
else
    git clone https://github.com/andrzejsliwa/vimfiles.git ~/.vim; ln -s $HOME/.vim/vimrc $HOME/.vimrc
fi
ln -s $HOME/.vim/vimrc $HOME/.vimrc
ln -s $HOME/.vim/tmux.conf $HOME/.tmux.conf
