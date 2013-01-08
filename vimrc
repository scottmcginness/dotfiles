" Start by setting up Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" List bundles
Bundle 'gmarik/vundle'

Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-ragtag'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-haml'

Bundle 'scottmcginness/vim-jquery'
Bundle 'scottmcginness/Conque-Shell'
Bundle 'scottmcginness/vim-foldtext'

Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/snipmate-snippets'

Bundle 'vim-scripts/nerdtree-ack'
Bundle 'vim-scripts/ShowMarks'
Bundle 'vim-scripts/JavaScript-Indent'
Bundle 'vim-scripts/django.vim'

Bundle 'Lokaltog/vim-powerline'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/python-syntax'

Bundle 'gregsexton/MatchTag'
Bundle 'gregsexton/gitv'

Bundle 'fholgado/minibufexpl.vim'
Bundle 'groenewege/vim-less'
Bundle 'jiangmiao/auto-pairs'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'sukima/xmledit'
Bundle 'vim-ruby/vim-ruby'
Bundle 'altercation/vim-colors-solarized'
Bundle 'mileszs/ack.vim'
Bundle 'msanders/snipmate.vim'
Bundle 'sjl/gundo.vim'
Bundle 'kchmck/vim-coffee-script'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'ervandew/supertab'
Bundle 'xolox/vim-session'
Bundle 'rbgrouleff/bclose.vim'

" Various reasonable options
syntax on
filetype plugin indent on
set showcmd          " Show commands as they are typed
set noshowmode       " Using powerline, so no need for showmode
set laststatus=2     " Always use a status line
set tabstop=4        " Tabs are 4 spaces wide
set softtabstop=4    " Tabs are 4 spaces when editing
set shiftwidth=4     " Number of spaces for an indent
set smarttab         " Backspaces will do a dedent
set expandtab        " Expand tabs into spaces
set autoindent       " Indent lines on opening them
set background=dark  " Always use a dark backgrounded colour scheme
set hidden           " Hide unsaved buffers
set number           " Show line numbers
set t_Co=256         " This terminal has 256 colours
set visualbell
set modeline
if has("gui_running")
    colorscheme desert
end

" Leader key
let mapleader = ","
let g:mapleader = ","

" Settings local to filetypes
autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType coffee setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Scrolling options
set scroll=12
set scrolloff=3

" Search settings, including very magic
nnoremap / /\v
cnoremap %s/ %s/\v
set incsearch
set hlsearch
hi Search term=NONE cterm=NONE ctermfg=NONE ctermbg=94 gui=NONE guifg=NONE guibg=#875f00
hi IncSearch term=NONE cterm=NONE ctermfg=NONE ctermbg=100 gui=NONE guifg=NONE guibg=#878700
nnoremap <leader>/ :nohlsearch<CR>:echo<CR>

" Split windows to the right because we read left-to-right
set splitright

" Use shell-like tab competion
set wildmode=longest,list,full
set wildmenu

" Options for folds and views
set foldcolumn=1
set foldmethod=syntax
set foldlevelstart=99
autocmd BufWinLeave * silent! mkview
autocmd BufWinEnter * silent! loadview

" Options for showing special chars
if has("multi_byte")
    set listchars=eol:↴,tab:⇥\ ,trail:˽,extends:⍈,precedes:⍇,conceal:🔒,nbsp:␠
else
    set listchars=eol:$,tab:->,trail:_,extends:>,precedes:<,conceal:*,nbsp:^
endif
noremap <leader>lc :set list!<CR>

" Toggle paste mode
nnoremap <silent> <F6> :set paste!<CR>
inoremap <silent> <F6> <ESC>:set paste!<CR>a

" Options for python.vim
let python_highlight_all = 1

" Close buffer without closing window
cnoremap <expr> bd (getcmdtype() == ':' ? 'Bclose' : 'bd')

" Options for NERDTree
nnoremap <F2> :NERDTreeToggle<CR>
autocmd FileType nerdtree cnoreabbrev <buffer> bd <nop>
let g:NERDTreeWinSize = 32

" Options for ragtag
let g:ragtag_global_maps = 1

" Options for vim-surround
let g:surround_{char2nr("b")} = "{% block \r %}\n{% endblock %}"
let g:surround_47 = "{% extends \"\r\" %}"

" Options for autopairs
let g:AutoPairsShortcutToggle = '<leader>ap'

" Options for syntastic
if has("multi_byte")
    let g:syntastic_error_symbol = '😽'
    let g:syntastic_warning_symbol = '😒'
    let g:syntastic_style_error_symbol = '✎'
    let g:syntastic_style_warning_symbol = '✎'
else
    let g:syntastic_error_symbol = 'E'
    let g:syntastic_warning_symbol = 'W'
    let g:syntastic_style_error_symbol = '!'
    let g:syntastic_style_warning_symbol = '?'
endif
let g:syntastic_enable_highlighting = 0
let g:syntastic_auto_loc_list = 1

" Options for vim-rails
let g:rails_ctags_arguments = '--languages=-javascript '.$HOME.'/.rvm/gems/'.system("rvm current | tr -d '\n'").'/gems'
autocmd User Rails Rnavcommand factory spec/factories -suffix=.rb -default=model()

" Reindent whole file shortcut
nnoremap <leader>= gg=G``

" Use subtle highlight for %
highlight MatchParen ctermbg=238 guibg=#444444

" Show highlight group under cursor
" From http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
nnoremap <F4> :echo ShowHighlightGroup()<CR>
function! ShowHighlightGroup()
    let [line, col] = [line('.'), col('.')]
    let hi = synID(line, col, 1)
    let trans = synID(line, col, 0)
    let lo = synIDtrans(synID(line, col, 1))
    let [hi, trans, lo] = map([hi, trans, lo], 'synIDattr(v:val, "name")')
    let template = "hi<%s> trans<%s> lo<%s>"
    return printf(template, hi, trans, lo)
endfunction

" Switch between number and relative number
nnoremap <F7> :call ToggleRelativeNumber()<CR>
function! ToggleRelativeNumber()
    if &relativenumber
        set number
    else
        set relativenumber
    endif
endfunction

" Quick toggle ShowMarks column
nmap <F8> <leader>mt

" Options for session.vim
set sessionoptions=blank,buffers,curdir,folds,globals,help,localoptions,options,resize,tabpages,winsize,winpos
let g:session_autoload = 'no'

" Undo options
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "Max number of changes that can be undone
set undoreload=10000 "Max number of line to save for undo on a buffer

" Don't bother with swaps and backups
set noswapfile
set nobackup

" Set ack to be the default grep
set grepprg="ack-grep -a"
let g:ackprg="ack-grep -H --nogroup --column"
nnoremap <leader>aw :Ack <cword><CR>
nnoremap <leader>a :Ack 

" Session shortcuts
nnoremap <leader>sw :SaveSession<CR>
nnoremap <leader>so :OpenSession<CR>
nnoremap <leader>sq :CloseSession<CR>
nnoremap <leader>sd :DeleteSession<CR>

" Folded lines highlighting
highlight Folded ctermbg=234 ctermfg=208
highlight FoldColumn ctermbg=234 ctermfg=208

" Line number highlighting
highlight LineNr ctermbg=234 ctermfg=210
highlight Special ctermfg=red

" Show space errors
let python_space_errors = 1
let ruby_space_errors = 1

" Space errors highlighting
highlight Error ctermbg=210 ctermfg=red

" Options for showmarks
let g:showmarks_enable = 0
let g:showmarks_textlower = "\t"
let g:showmarks_textupper = "\t"
let g:showmarks_textother = "\t"
highlight SignColumn ctermbg=234 ctermfg=206
highlight ShowMarksHLl ctermbg=234 ctermfg=206
highlight ShowMarksHLu ctermbg=234 ctermfg=206
highlight ShowMarksHLo ctermbg=234 ctermfg=206
highlight ShowMarksHLm ctermbg=234 ctermfg=206

" Options for Gundo
nnoremap <F5> :GundoToggle<CR>

" Options for modified ConqueTerm
let g:ConqueTerm_PromptRegex = ''
let g:ConqueTerm_CustomPrompt = 1
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_CWInsert = 1
nnoremap <silent> <leader>sh :ConqueTermVSplit bash --rcfile ~/.conquerc<CR><ESC>:f $<CR>:UMiniBufExplorer<CR>i
nnoremap <silent> <leader>shs :b$<CR>

" Options for powerline
let g:Powerline_symbols = 'fancy'
if has("win32")
    set guifont="Consolas for Powerline FixedD:h9"
endif

" Options for MiniBufExplorer
let g:miniBufExplorerMoreThanOne = 3  " Don't interfere with fugitive on :Gdiff
nnoremap <F3> :TMiniBufExplorer<CR><C-w><C-p>

" ~/.vimrc shortcuts
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>bi :BundleInstall<CR>

" Let’s not use escape in normal mode any more. Be very annoying instead
let s:escCounter = 0
function! AnnoyingEscape()
    silent bnext
    let s:escCounter += 1
    if has("multi_byte")
        let s:backCommand = "‘:bp<CR>’"
    else
        let s:backCommand = "`:bp<CR>'"
    endif
    let s:message = "Oops, <ESC>(#%s) in normal mode. Use %s to get back."
    echom printf(s:message, s:escCounter, s:backCommand)
endfunction
if has("termresponse")
    autocmd TermResponse * nnoremap <ESC> <ESC>:call AnnoyingEscape()<CR>
else
    nnoremap <ESC> <ESC>:call AnnoyingEscape()<CR>
endif

" Use TAB to get from normal into command mode
nnoremap <TAB> :

" Intuitive immediate newline when in insert mode
imap <C-j> <ESC>A<CR>
inoremap <C-k> <ESC>O

" Move past characters in insert mode
inoremap <C-l> <ESC>la

" Shortcuts for moving around windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-w>s :vsplit 

" Visually highlight folds
nnoremap vaf zaVzao
nnoremap vif zaVzaoj<ESC>'>kV'<

" Sane yank to end of line
nnoremap Y y$

" Join upwards (‘:!man <SOMETHING>’ isn’t so bad)
nnoremap K kJ

" Use F1 for help
nnoremap <F1> :h 

" Always start at top of gitcommit file
autocmd BufWinEnter .git/COMMIT_EDITMSG 0

" Shortcuts for fugitive
" (Note that <CR> is deliberately left off some of these)
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit --verbose<CR>
nnoremap <leader>gw :Gwrite<SPACE>
nnoremap <leader>gl :Glog<SPACE>
nnoremap <leader>gd :Gdiff<SPACE>
nnoremap <leader>gr :Gremove<SPACE>
nnoremap <leader>gb :Gblame<SPACE>
nnoremap <leader>gg :Git<SPACE>
nnoremap <leader>dit :diffthis<CR>

" Shortcuts for rails.vim
nnoremap <leader>rm :Rmodel<SPACE>
nnoremap <leader>rc :Rcontroller<SPACE>
nnoremap <leader>rv :Rview<SPACE>
nnoremap <leader>rs :Rspec<SPACE>
nnoremap <leader>rsm :Rspec models/
nnoremap <leader>rsc :Rspec controllers/
nnoremap <leader>rsv :Rspec views/
nnoremap <leader>rf :Rfactory<SPACE>
nnoremap <leader>rg :Rgenerate<SPACE>
nnoremap <leader># :AV<CR>
nnoremap <leader>r :Rake<SPACE>
nnoremap <leader>p :!bundle exec pry<CR>
nnoremap <leader>pc :Rscript console<CR>
vnoremap <leader>re :Rextract<SPACE>

" Non-mappings
" (stuff deliberately left out because there are better ways of doing things)
"
" Because scrolling around buffers is like holding ‘j’ or ‘k’
" nnoremap <SOMETHING> :bn
" nnoremap <SOMETHING> :bp
"
" Because repeating ‘f’, ‘F’, ‘t’ or ‘T’ is pretty darn useful
" nnoremap ; <SOMETHING>
