#!/bin/sh

if [ -d $HOME/.vim-andrzej ]
then
    cd ~/.vim-andrzej ; git pull ; cd -
else
    git clone https://github.com/andrzejsliwa/vimfiles.git ~/.vim-andrzej
    git clone https://github.com/gmarik/vundle.git ~/.vim-andrzej/bundle/vundle
    grep "alias avim" ~/.bashrc >/dev/null  || echo 'alias avim="vim -u ~/.vim-andrzej/vimrc"' >> ~/.bashrc
fi
