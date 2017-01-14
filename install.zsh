#!/usr/bin/env zsh

set -eu

export MYDOTFILES=$HOME/dotfiles

FZFDIR="$HOME/.fzf"
ZPREZTORC="$HOME/.zpreztorc"
VIMRC="$HOME/.vimrc"
GVIMRC="$HOME/.gvimrc"
TMUXCONF="$HOME/.tmux.conf"
TMUXLOCAL="$MYDOTFILES/tmux-local"
TRASH="$HOME/.trash"

touch ~/.zshrc
echo "source $MYDOTFILES/zsh/zshrc" >> ~/.zshrc

if [ ! -e ${FZFDIR} ]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
fi

if [ ! -e ${ZPREZTORC} ]; then
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	git -C ${ZDOTDIR:-$HOME}/.zprezto submodule foreach git pull origin master

	setopt EXTENDED_GLOB

	mv ~/.zshrc ~/.zshrcbak

	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
		ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	done

	cat ~/.zshrcbak >> ${ZDOTDIR:-$HOME}/.zshrc
	rm ~/.zshrcbak

	rm ${ZDOTDIR:-$HOME}/.zpreztorc
	ln -s ${MYDOTFILES}/zsh/zpreztorc ${ZDOTDIR:-$HOME}/.zpreztorc
fi

if [ ! -e ${VIMRC} ]; then
	touch $MYDOTFILES/vim/vimrc.vim
	ln -s $MYDOTFILES/vim/vimrc.vim $HOME/.vimrc
	echo "vimrc linked"
fi

if [ ! -e ${GVIMRC} ]; then
	touch $MYDOTFILES/vim/gvimrc.vim
	ln -s $MYDOTFILES/vim/gvimrc.vim $HOME/.gvimrc
	echo "gvimrc linked"
fi

if [ ! -e ${TMUXCONF} ]; then
	touch $MYDOTFILES/tmux/tmux.conf
	ln -s $MYDOTFILES/tmux/tmux.conf $HOME/.tmux.conf
	echo "tmuxconf linked"
fi

if [ ! -e ${TMUXLOCAL} ]; then
	touch $MYDOTFILES/tmux-local
	echo "tmuxlocal is made"
fi

if [ ! -e ${TRASH} ]; then
	mkdir ${TRASH}
fi
