""" Install vim-plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimfiler'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Shougo/vimshell.vim'
Plug 'junegunn/vim-easy-align'

call plug#end()

set runtimepath+=~/.vimrc.d
runtime! plugins/common.vim
runtime! plugins/neocomplete.vim

""" Key configurations
" reload config file
nmap ,R :source ~/.vimrc<CR>

