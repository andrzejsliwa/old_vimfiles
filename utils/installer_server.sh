#!/bin/sh

if [ -d $HOME/.vim-andrzej ]
then
    cd ~/.vim-andrzej ; git pull ; cd -
else
    cd ~ ; git clone https://github.com/andrzejsliwa/vimfiles.git ~/.vim-andrzej ; cd -
    grep "alias avim" ~/.bashrc >/dev/null  || echo 'alias avim="vim -u ~/.vim-andrzej/vimrc"' >> ~/.bashrc
    source ~/.bashrc
fi
