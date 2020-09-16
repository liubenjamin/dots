set number
set relativenumber
set ruler
set showcmd
set cursorline
set showmatch
set incsearch
set hlsearch
set splitbelow
set splitright
set inccommand=nosplit
syntax on
colorscheme onedark
highlight Comment cterm=italic gui=italic
highlight CursorLine cterm=underline ctermbg=None
highlight Normal ctermbg=None

" map kj to Escape
inoremap kj <Esc>

" use system clipboard
set clipboard^=unnamedplus,unnamed

" make Y move like D and C
noremap Y y$

" move to beginning/end of line
noremap B ^
noremap E $

" easier split navigation
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" automatically deletes all tralling whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" undo
set undofile
set undodir=~/.vim/_undo/

" source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" ranger file explorer
let g:rnvimr_ex_enable=1
nmap <space>r : RnvimrToggle<CR>

call plug#begin('~/.config/nvim/plugged') " vim-plug
Plug 'kevinhwang91/rnvimr'
Plug 'joshdick/onedark'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()
