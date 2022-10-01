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
set iskeyword-=_                " split words at underscore
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
noremap Q ^
noremap E $

" paste in insert mode
inoremap <C-V> <C-R>*

" split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" split opening
nnoremap <leader>h :new<CR>
nnoremap <leader>v :vnew<CR>

" tab navigation
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <silent> <leader>n :tabnext<CR>
nnoremap <silent> <leader>p :tabprevious<CR>

" write and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" center
nnoremap <leader><space> zz
vnoremap <leader><space> zz
nnoremap n nzz
nnoremap N Nzz

" moving text
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '>-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" better matching pair
nnoremap , %

" matching pairs
set matchpairs+=<:>

" spell check and fix
map <leader>ss :setlocal spell!<cr>
imap <C-y>  <C-g>u<Esc>[s1z=`]a<C-g>u
nmap <C-y> [s1z=<c-o>

" toggle highlight
nnoremap <silent> <leader>/ :set hls!<cr>

" undo
set undofile
set undodir=~/.vim/_undo/

" auto delete all trailing whitespace on save
autocmd bufwritepre * %s/\s\+$//e

" auto source vimrc on save
autocmd! bufwritepost $MYVIMRC source $MYVIMRC | redraw

" restore cursor last position
 augroup last_cursor_position
    autocmd!
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"zvzz" | endif
  augroup END

" auto install vim-plug
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd vimenter * PlugInstall
endif

" vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'akinsho/bufferline.nvim'
Plug 'catppuccin/nvim'
Plug 'folke/todo-comments.nvim'
Plug 'gcmt/wildfire.vim'
Plug 'junegunn/seoul256.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lervag/vimtex'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-highlightedyank'
Plug 'monsonjeremy/onedark.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'phaazon/hop.nvim'
Plug 'psliwka/vim-smoothie'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'ryanoasis/vim-devicons'
Plug 'svermeulen/vim-subversive'
Plug 'theniceboy/nvim-deus'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'xiyaowong/nvim-transparent'
Plug 'Xuyuanp/scrollbar.nvim'
call plug#end()

" color scheme after loading plugin
set termguicolors
colorscheme catppuccin
highlight LineNr guifg=white

" transparency
nmap tt :TransparentToggle<CR>

" subversive substitution motion
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

" tcomment_vim toggle comment
nmap <silent> <leader>c :TComment<CR>
vmap <silent> <leader>c :TComment<CR>
nmap <silent> <C-c> :TComment<CR>

" hop
nmap <silent> ; :HopWord<CR>
nmap <silent> ' :HopChar1<CR>

" vim-smoothie enable gg and G
let g:smoothie_experimental_mappings=1
let g:smoothie_speed_linear_factor=90
let g:smoothie_speed_exponentiation_factor=0.5

" rainbow pairs
let g:rainbow_active = 1

" telescope
nnoremap <C-b> :lua require('telescope.builtin').buffers()<cr>
nnoremap <C-f> :lua require('telescope.builtin').find_files()<cr>
nnoremap <C-g> :lua require('telescope.builtin').live_grep()<cr>
nnoremap <C-s> :lua require('telescope.builtin').git_status()<cr>

" scrollbar
augroup ScrollbarInit
  autocmd!
  autocmd WinScrolled,VimResized,QuitPre * silent! lua require('scrollbar').show()
  autocmd WinEnter,FocusGained * silent! lua require('scrollbar').show()
  autocmd WinLeave,BufLeave,BufWinLeave,FocusLost * silent! lua require('scrollbar').clear()
augroup end

" vimtex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let maplocalleader = " "

augroup _vimtex
    autocmd!
    " compile after opening
    autocmd User VimtexEventInitPost VimtexCompile
    " focus vim after view
    autocmd User VimtexEventView call b:vimtex.viewer.xdo_focus_vim()
    " view and forward sync after compile
    autocmd User VimtexEventCompileSuccess VimtexView
augroup END

call vimtex#imaps#add_map({
            \ 'lhs' : '<cr>',
            \ 'rhs' : "\r\\item ",
            \ 'leader'  : '',
            \ 'wrapper' : 'vimtex#imaps#wrap_environment',
            \ 'context' : [
                \   'itemize',
                \   'enumerate',
                \ ],
                \})

" coc
set updatetime=300
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-rename)
nmap <silent> gc <Plug>(coc-references)
nnoremap <silent> gh :call CocActionAsync('doHover')<CR>

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <C-space> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

lua <<EOF
require('bufferline').setup({
    options = {
        mode = "tabs"
    }
})
require('gitsigns').setup()
require('hop').setup()
require('indent_blankline').setup({
    show_current_context = true,
})
require('lualine').setup({
    options = { section_separators = '', component_separators = '' }
})
require('nvim-autopairs').setup({
    disable_filetype = { "TelescopePrompt" , "vim" },
})
require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "cpp", "java", "latex", "python" },
    sync_install = false,
    highlight = {
        enable = true,
        disable = { "latex" },
        additional_vim_regex_highlighting = false,
        },
})
require('telescope').load_extension('fzf')
require('todo-comments').setup()
require('transparent').setup({
    enable = true
})
require('treesitter-context').setup()
EOF
