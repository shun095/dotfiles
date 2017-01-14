#!/usr/bin/env zsh

set -eu

export MYDOTFILES=$HOME/dotfiles


ZSHRC="$HOME/.zshrc"
FZFDIR="$HOME/.fzf"
ZPREZTODIR="${ZDOTDIR:-$HOME}/.zprezto"
VIMRC="$HOME/.vimrc"
GVIMRC="$HOME/.gvimrc"
TMUXCONF="$HOME/.tmux.conf"
TMUXLOCAL="$MYDOTFILES/tmux-local"
FLAKE8="$HOME/.config/flake8"
TRASH="$HOME/.trash"

if [ ${1:-default} = "--reinstall" ]; then
	if [ -e "~/.zshrc.bak" ]; then
		rm ~/.zshrc.bak
	fi

	if [ -e "$ZSHRC" ]; then
		cp $ZSHRC ~/.zshrc.bak
	fi

	setopt EXTENDED_GLOB
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
		if [ -e "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
			rm "${ZDOTDIR:-$HOME}/.${rcfile:t}"
		fi
	done

	\rm -rf $FZFDIR $ZPREZTODIR $VIMRC $GVIMRC $TMUXCONF $TMUXLOCAL $FLAKE8
fi

if [ ! -e ${ZSHRC} ]; then
	touch ~/.zshrc
	echo "source $MYDOTFILES/zsh/zshrc" >> ~/.zshrc
fi

git config --global core.editor vim
git config --global alias.graph "log --graph --all --pretty=format:'%C(auto)%h%d%n  %s %C(magenta)(%cr)%n    %C(green)Committer:%cN <%cE>%n    %C(blue)Author   :%aN <%aE>%Creset' --abbrev-commit --date=relative"

if [ ! -e ${FZFDIR} ]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --completion --key-bindings --update-rc
fi

if [ ! -e ${ZPREZTODIR} ]; then
	git clone --recursive https://github.com/zsh-users/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
#	git -C ${ZDOTDIR:-$HOME}/.zprezto submodule foreach git pull origin master

	setopt EXTENDED_GLOB

	mv ~/.zshrc ~/.zshrc.tmp

	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
		ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	done

	cat ~/.zshrc.tmp >> ${ZDOTDIR:-$HOME}/.zshrc
	rm ~/.zshrc.tmp

	rm ${ZDOTDIR:-$HOME}/.zpreztorc
	ln -s ${MYDOTFILES}/zsh/zpreztorc ${ZDOTDIR:-$HOME}/.zpreztorc
fi

if [ ! -e ${VIMRC} ]; then
	touch $MYDOTFILES/vim/vimrc.vim
	ln -s $MYDOTFILES/vim/vimrc.vim ${VIMRC}
	echo "vimrc linked"
fi

if [ ! -e ${GVIMRC} ]; then
	touch $MYDOTFILES/vim/gvimrc.vim
	ln -s $MYDOTFILES/vim/gvimrc.vim ${GVIMRC}
	echo "gvimrc linked"
fi

if [ ! -e ${TMUXCONF} ]; then
	touch $MYDOTFILES/tmux/tmux.conf
	ln -s $MYDOTFILES/tmux/tmux.conf ${TMUXCONF}
	echo "tmuxconf linked"
fi

if [ ! -e ${TMUXLOCAL} ]; then
	touch $MYDOTFILES/tmux-local
	echo "tmuxlocal is made"
fi

if [ ! -e ${FLAKE8} ]; then
	ln -s $MYDOTFILES/flake8 ${FLAKE8}
	echo "flake8 config file linked"
fi

if [ ! -e ${TRASH} ]; then
	mkdir ${TRASH}
fi
