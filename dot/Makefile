PWD=$(shell pwd)

all:
	@echo Do nothing. Type make install

install: \
	git \
	zsh \
	z \
	tmux \
	vim

clean: \
	git-clean \
	zsh-clean \
	z-clean \
	tmux-clean \
	vim-clean

git: FORCE
	ln -s $(PWD)/gitconfig ~/.gitconfig
git-clean: FORCE
	rm ~/.gitconfig || true

zsh: FORCE
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh;
	git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh-completions;
	touch ~/.zshrc.local;
	ln -s $(PWD)/zshrc ~/.zshrc;
zsh-clean: FORCE
	rm -rf ~/.oh-my-zsh || true
	rm -rf ~/.zsh-completions || true
	rm ~/.zshrc || true

z: FORCE
	mkdir ~/.z.data/;
	git clone https://github.com/rupa/z.git ~/.z.sh;
z-clean: FORCE
	rm -rf ~/.z.data || true
	rm -rf ~/.z.sh || true

tmux: FORCE
	touch ~/.tmux.conf.local;
	ln -s $(PWD)/tmux.conf ~/.tmux.conf;
tmux-clean: FORCE
	rm ~/.tmux.conf || true

vim: FORCE
	mkdir -p  ~/.vim/bundle;
	touch ~/.vimrc.local;
	ln -s $(PWD)/vimrc ~/.vimrc;

	git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim;
	vim -N -u NONE -i NONE -V1 -e -s --cmd "source ~/.vimrc" --cmd NeoBundleInstall! --cmd qall!
vim-clean: FORCE
	rm -rf ~/.vim/bundle || true
	rm ~/.vimrc || true

.PHONY: FORCE