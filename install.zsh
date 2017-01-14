#!/usr/bin/env zsh

set -eu

export MYDOTFILES=$HOME/dotfiles

reinstall=
relink=
update=
relinkprezto=
relinkfzf=

ZSHRC="$HOME/.zshrc"
FZFDIR="$HOME/.fzf"
ZPREZTODIR="${ZDOTDIR:-$HOME}/.zprezto"
VIMRC="$HOME/.vimrc"
GVIMRC="$HOME/.gvimrc"
TMUXCONF="$HOME/.tmux.conf"
TMUXLOCAL="$MYDOTFILES/tmux-local"
FLAKE8="$HOME/.config/flake8"
TRASH="$HOME/.trash"

help() {
	cat << EOF
	usage: $0 [OPTIONS]
	--help				Show this message
	--reinstall			Refetch zsh-plugins from repository and reinstall.
	--relink			Delete symbolic link and link again.
	--update			Update plugins
EOF
}


for opt in "$@"; do
	case $opt in
		--help)
			help
			exit 0
			;;
		--reinstall)
			reinstall=1
			relink=1
			;;
		--relink) relink=1 ;;
		--update) update=1 ;;
		*)
			echo "unknown option: $opt"
			help
			exit 1
			;;
	esac
done

if [ ! -z "$update" ]; then
	pushd ${ZPREZTODIR}
	git pull && git submodule update --init --recursive
	popd
	pushd ${FZFDIR}
	git pull
	popd

	relink=1
fi

if [ ! -z "$relink" ]; then

	if [ -e "$ZSHRC" ]; then
		if [ -e "~/.zshrc.bak" ]; then
			echo "Remove exist backup of zshrc"
			rm ~/.zshrc.bak
		fi
		cp $ZSHRC ~/.zshrc.bak
		echo "Make backup of zshrc"
	fi

	setopt EXTENDED_GLOB
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
		if [ -e "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
			echo "Remove .${rcfile:t}"
			rm "${ZDOTDIR:-$HOME}/.${rcfile:t}"
		fi
	done
	relinkprezto=1
	relinkfzf=1

	\rm -f $VIMRC $GVIMRC $TMUXCONF $TMUXLOCAL $FLAKE8
fi

if [ ! -z "$reinstall" ]; then
	echo "Remove fzf and zprezto directory"
	\rm -rf $FZFDIR $ZPREZTODIR 
fi

git config --global core.editor vim
git config --global alias.graph "log --graph --all --pretty=format:'%C(auto)%h%d%n  %s %C(magenta)(%cr)%n    %C(green)Committer:%cN <%cE>%n    %C(blue)Author   :%aN <%aE>%Creset' --abbrev-commit --date=relative"

# install fzf
if [ ! -e ${FZFDIR} ]; then
	echo "Download and install fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	relinkfzf=1
fi

# download zprezto
if [ ! -e ${ZPREZTODIR} ]; then
	echo "Download zprezto"
	git clone --recursive https://github.com/zsh-users/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
#	git -C ${ZDOTDIR:-$HOME}/.zprezto submodule foreach git pull origin master
	relinkprezto=1
fi

# relink prezto files
if [ ! -z "$relinkprezto" ]; then
	echo "Install prezto"
	setopt EXTENDED_GLOB
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
		if [ ! -e "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]; then
			echo "Link .${rcfile:t}"
			ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
		fi
	done

	rm ${ZDOTDIR:-$HOME}/.zpreztorc
	ln -s ${MYDOTFILES}/zsh/zpreztorc ${ZDOTDIR:-$HOME}/.zpreztorc

	if [ -e "$HOME/.zshrc.bak" ]; then
		echo "Restore backup of zshrc"
		cat ~/.zshrc.bak > ~/.zshrc
		rm ~/.zshrc.bak
	else
		touch ~/.zshrc
		echo "Add a line for source dotfiles to zshrc"
		echo "source $MYDOTFILES/zsh/zshrc" >> ~/.zshrc
	fi
fi

if [ ! -z "$relinkfzf" ]; then
	~/.fzf/install --completion --key-bindings --update-rc
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
