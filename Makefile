PWD=$(shell pwd)

all:
	@echo Noop. Type make install or clean

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
	ln -s $(PWD)/git/.gitconfig ~/.gitconfig
git-clean: FORCE
	rm ~/.gitconfig || true

zsh: FORCE
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh;
	git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh-completions;
	touch ~/.zshrc.local;
	ln -s $(PWD)/zsh/.zshrc ~/.zshrc;
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
	ln -s $(PWD)/tmux/.tmux.conf ~/.tmux.conf;
tmux-clean: FORCE
	rm ~/.tmux.conf || true

vim: FORCE
	touch ~/.vimrc.local;
	ln -s $(PWD)/vim/.vimrc ~/.vimrc;
	ln -s $(PWD)/vim/.vimrc.d ~/.vimrc.d
vim-clean: FORCE
	rm -rf ~/.vim || true
	rm ~/.vimrc || true
	rm ~/.vimrc.d || true

.PHONY: FORCE
