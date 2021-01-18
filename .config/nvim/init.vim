" basics
syntax on                       " syntax highlighting
set ai si                       " auto and smart indent
set number                      " line numbers
set mouse=a                     " enable mouse
set showcmd                     " show last command in bottom right
set expandtab                   " tab inserts spaces
set linebreak                   " wrap without breaking words
set showmatch                   " show matching brace
set ts=4 sw=4                   " tab and indent size
set cursorline                  " enable cursor line
set ignorecase                  " case insensitive search
set relativenumber              " relative line numbers
set inccommand=nosplit          " substitution live preview
set incsearch hlsearch          " incremental and highlight search
set splitbelow splitright       " logical split directions
let mapleader=" "               " use space as leader

" map kj to escape
inoremap kj <esc>

" use system clipboard
set clipboard^=unnamedplus,unnamed

" change with black hole register
nnoremap c "_c
nnoremap C "_C

" make Y move like D and C
noremap Y y$

" move to beginning/end of line
noremap B ^
noremap E $

" paste in insert mode
inoremap <C-V> <C-R>*

" split navigation
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" split opening
nnoremap <leader>h :new<CR>
nnoremap <leader>v :vnew<CR>

" tab opening
nnoremap <leader>t :tabnew<CR>

" write and quit
nnoremap <leader>w :w!<CR>
nnoremap <leader>q :q!<CR>

" center
nnoremap <leader><space> zz

" spell check
map <leader>ss :setlocal spell!<cr>

" center on insert
autocmd insertenter * norm zz

" no highlight
nnoremap <leader>/ :set hls!<cr>

" auto delete all trailing whitespace on save
autocmd bufwritepre * %s/\s\+$//e

" undo
set undofile
set undodir=~/.vim/_undo/

" auto install vim-plug
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd vimenter * PlugInstall
endif

" vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'joshdick/onedark.vim'
Plug 'justinmk/vim-sneak'
Plug 'kevinhwang91/rnvimr'
Plug 'machakann/vim-highlightedyank'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'psliwka/vim-smoothie'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-airline/vim-airline'
call plug#end()

" airline
let g:airline#extensions#tabline#enabled=1

" nerdtree
nmap <leader>n :NERDTreeFocus<CR>
nmap <C-t> :NERDTreeToggle<CR>
autocmd vimenter * NERDTree | wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd bufwinenter * silent NERDTreeMirror
let NERDTreeShowLineNumbers=1

" vim-smoothie enable gg and G
let g:smoothie_experimental_mappings=1

" ranger file explorer
let g:rnvimr_ex_enable=1
nmap <leader>r : RnvimrToggle<CR>

" color scheme after loading plugin
colorscheme onedark
hi cursorlinenr ctermfg=white

" auto source vimrc on save
autocmd! bufwritepost $MYVIMRC source $MYVIMRC | redraw
