" ======================== Editor behavior ====================
" Use utf-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8

" Show line numbers.
set nu
set relativenumber

" Disable vi mode
set nocompatible

" Add mouse support 
set mouse+=a

" set backup
silent !mkdir -p $HOME/.config/nvim/tmp/backup
silent !mkdir -p $HOME/.config/nvim/tmp/undo
set backupdir=$HOME/.config/nvim/tmp/backup,.
set directory=$HOME/.config/nvim/tmp/backup,.
if has('persistent_undo')
	set undofile
	set undodir=$HOME/.config/nvim/tmp/undo,.
endif

" columns to highlight
set colorcolumn=100

" when to use virtual editing: "block", "insert", "all"
set virtualedit=block

" This makes vim use the indent of the previous line for a newly created line
set autoindent

" change to directory of file in buffer
set autochdir

" empty to tell Vim it needs to draw the background color
let &t_ut=""

" enable reading .vimrc/.exrc/.gvimrc in the current directory
set exrc

" safer working with script files in the current direcotry
set secure

" hight the screen line of the cursor
set cursorline

" long lines wrap
set wrap 

" command-line completion shows a list of matches 
set wildmenu 

" highlight all matches for the last used search pattern 
set hlsearch

" delete last used search pattern when vim started
exec "nohlsearch"

" show match for partly typed search command
set incsearch

" ignore case when using a search pattern 
set ignorecase

" override 'ignorecase' when pattern has upper case characters
set smartcase

" No expand <Tab> to spaces in Insert mode 
set noet

" number of spaces a <Tab> in the text stands for
set tabstop=4

" number of spaces to insert for a <Tab>
set softtabstop=4

" number of spaces used for each step of indent
set shiftwidth=4

" show <Tab> as ^I and end-of-line as $
set list

" list of strings used for list mode
set listchars=tab:>\|\,trail:▫

" number of screen lines to show around the cursor
set scrolloff=5

" time in msec for 'timeout'
set timeoutlen=0

" Don't allow timing out halfway into a mapping
set notimeout

" time in msec after which the swap file will be updated
set updatetime=100

" list of words that specifies what to save for :mkview
set viewoptions=cursor,folds,slash,unix

" line length above which to break a line 
set textwidth=0

" expression used to obtain the indent of a line
set indentexpr=

" folding type:indent
set foldmethod=indent

" folds with a level higher than this number will be closed
set foldlevel=99

" enable fold
set foldenable

" list of flags that tell how automatic formatiing works
set formatoptions-=c

" a new window is put right of the current one
set splitright

" a new window is put blow of the current one
set splitbelow

" display the current mode in the status line
set showmode

" show (partial) command keys in the status line
set showcmd

" list of flags to make messages shorter
set shortmess+=c

" just like incsearch
set inccommand=split

" whether to use a popup menu for Insert mode completion
set completeopt=longest,noinsert,menuone,noselect,preview

" don't redraw while executing macros
set lazyredraw

" use a visual bell instead of beeping
set visualbell

"
set laststatus=3
highlight Winseparator guibg=None

"
"set winbar=%f


" reopen file cursor in last location
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" =============================== Basic Mappings ====================
" using =/- show search result
noremap = nzz
noremap - Nzz

map s <nop>
map S :w<CR>
map Q :q<CR>
map R :source $MYVIMRC<CR>

noremap H 5h
noremap J 5j
noremap K 5k
noremap L 5l

" ============================== Windows management ===================
noremap sk :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
noremap sj :set splitbelow<CR>:split<CR>
noremap sh :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
noremap sl :set splitright<CR>:vsplit<CR>

map <M-j> <C-w>j
map <M-k> <C-w>k
map <M-l> <C-w>l
map <M-h> <C-w>h

map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize-5<CR>
map <right> :vertical resize+5<CR>

" ======================= Tab management ======================
noremap tu :tabe<CR>
noremap tU :tabe split<CR>
noremap th :-tabnext<CR>
noremap tl :+tabnext<CR>
noremap tmh :-tabmove<CR>
noremap tml :+tabmove<CR>

call plug#begin('$HOME/.config/nvim/plugged')

Plug 'theniceboy/eleline.vim', { 'branch': 'no-scrollbar' }

call plug#end()

" eleline
let g:eleline_powerline_fonts = 1
