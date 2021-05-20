" UTF-8 Support
set encoding=utf-8

" enable syntax highlighting
syntax enable

" show line numbers
set number

" show a visual line under the cursor's current line
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

" set tabs to have 2 spaces
" set ts=2
set tabstop=2
set softtabstop=2

" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=2

" expand tabs into spaces
set expandtab
set smarttab

" indent when moving to the next line while writing code
set autoindent


" enable all Python syntax highlighting features
let python_highlight_all = 1

map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-t><left> :tabp<cr>
map <C-t><right> :tabn<cr>

nnoremap <F9> :%!python -m json.tool<cr>
nnoremap <F3> :NERDTreeToggle<cr>

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" https://vim.fandom.com/wiki/Insert_newline_without_entering_insert_mode
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

set mouse=a

" https://stackoverflow.com/questions/741814/move-entire-line-up-and-down-in-vim
noremap <C-S-UP> ddkkp
noremap <C-S-DOWN> ddp
noremap <S><DEL> dd

" https://realpython.com/vim-and-python-a-match-made-in-heaven/
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin("~/.vim/plugged")

" Make sure you use single quotes

" File Browsing
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-github-dashboard'

" Code Folding
Plug 'tmhedberg/SimpylFold'

" Syntax Checking/Highlighting
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'

" Python Indentation
Plug 'vim-scripts/indentpython.vim'

" Color Schemes
Plug 'jnurmine/Zenburn'
Plug 'altercation/vim-colors-solarized'
Plug 'flazz/vim-colorschemes'

" Super Searching
Plug 'kien/ctrlp.vim'

" Git Integration
Plug 'tpope/vim-fugitive'

" Powerline
Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}


" Python-mode
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

Plug 'majutsushi/tagbar'

Plug 'jiangmiao/auto-pairs'

" Commenting
Plug 'preservim/nerdcommenter'

Plug 'google/vim-jsonnet'

" jsonviewer
Plug 'brtastic/vim-jsonviewer'


" Initialize plugin system
call plug#end()

filetype plugin indent on

set background=dark
colorscheme zenburn

let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" System Clipboard
"set clipboard=unnamed


" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

let g:SimpylFold_docstring_preview=1

au BufNewFile,BufRead *.py set tabstop=2 softtabstop=2  shiftwidth=2 textwidth=79 expandtab autoindent fileformat=unix

" https://github.com/majutsushi/tagbar
nmap <F8> :TagbarToggle<CR>

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
