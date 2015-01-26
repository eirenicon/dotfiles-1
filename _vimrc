set nocompatible            " be iMproved
filetype off                " required!
filetype plugin indent on   " required!

" ------------------------------------------
" General options
" ------------------------------------------
" misc
let mapleader=","                   " change the leader key to comma
set clipboard=unnamedplus           " use OS clipboard as default yank buffer
set history=1000                    " remember a ton of commands
set backspace=indent,eol,start      " backspace over everything

" whitespace and indentation
set tabstop=4                       " a tab is four spaces.
set shiftwidth=4                    " N spaces while autoindenting
set softtabstop=4                   " N spaces while editing (deletes groups of N spaces)
set expandtab                       " insert spaces instead of tabs
set smartindent                     " seems to do a decent job with indenting
set list                            " show whitespace indicated by 'listchars'
set listchars=tab:»\ ,trail:·,extends:…

" UI
set t_Co=256                        " let terminal vim use 256 colors
syntax enable                       " syntax highlighting
set mouse=a                         " allow for better mouse interaction
set scrolloff=5                     " always show N lines veritcally
set sidescroll=10                   " always show N chars horizontally
set cursorline                      " highlight the line the cursor is on
set number                          " show line numbers
set relativenumber                  " number gutter shows line number as relative to current
set virtualedit=block               " virtual-block mode can expand beyond EOL
set ruler                           " show line num, column num, % of file, etc
set laststatus=2                    " always show status bar
set shortmess+=I                    " no message on empty vim startup
set splitbelow                      " show splits to right or below, as you would read
set splitright                      " ^
set wildmenu                        " improve auto complete menu
set wildmode=list:longest,full      " filename completion
set ttyfast                         " faster, smoother redraw

" line wrapping
set textwidth=0                     " don't split lines (in the actual file) when they're too long
set wrap                            " wrap lines in the vim buffer, but not in the actual file
set linebreak                       " ^^, and break on words
set showbreak=\ \ …                 " prepend these chars to lines broken by linebreak
set formatoptions+=rn1              " see :h fo-table
set colorcolumn=120                 " highlight the prefered EOL column

" buffers
set encoding=utf-8                  " sensible default encoding
set hidden                          " dont delete buffers, just hide them
set undofile                        " save undo tree when file is closed
set undodir=~/.vim/undo             " undo files should be kept out of the working dir
set undolevels=1000                 " many many levels of undo
set backup                          " use backup files
set backupdir=~/.vim/backup         " backup files should be kept out of the working dir
set directory=~/.vim/tmp            " swapfiles should be kept out of the working dir

" searching
set smartcase                       " ignore case in a search until there is some capitalization
set ignorecase                      " needed for smartcase
set gdefault                        " s///g is implied, explicitly adding g negates effect
set incsearch                       " jump to the first instance as you type the search term
set showmatch                       " always show matching ()'s
set hlsearch                        " Highlight all of the search terms
set tags=./.tags;$HOME              " search for a tag file named '.tags' upwards until $HOME

" ------------------------------------------
" Plugins
" ------------------------------------------

if filereadable(expand("~/.vimrc.plugins"))
    source ~/.vimrc.plugins
    set noshowmode                  " airline shows me my editor mode
    let g:hybrid_use_Xresources = 1
    colorscheme hybrid
else
    colorscheme slate
endif

if has("gui_running")
    set guioptions=a
    set guifont=EnvyCodeR\ 11
endif

" ------------------------------------------
" Mappings
" ------------------------------------------

" reload this file
nnoremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" for local replace
nnoremap <leader>r gdV][::s/<C-R>///c<left><left>

" for global replace
nnoremap <leader>R *N:%s/<C-R>///c<left><left>

" typing jj in insert mode gets you out.
inoremap jj <Esc>

" Y yanks to EOL (to match D and C)
nnoremap Y y$

" window navigation
"map <M-h> <C-w>h
"map <M-j> <C-w>j
"map <M-k> <C-w>k
"map <M-l> <C-w>l

" vim training wheels: don't allow arrow keys!
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" fix direction keys for line wrap, otherwise they jump over wrapped lines
nnoremap j gj
nnoremap k gk

" keep cursor in middle of screen when jumping/scrolling
nnoremap <C-j> 10jzz
nnoremap <C-k> 10kzz
nmap <C-D> <C-D>zz
nmap <C-U> <C-U>zz
nmap { {zz
nmap } }zz
nmap n nzz
nmap N Nzz
nnoremap <C-i> <C-i>zz
nnoremap <C-o> <C-o>zz

" clear search highlighting
nnoremap c/ :noh<CR>

" remap f1. I'll type :help when I want it
inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>
nnoremap Q <nop>

nnoremap <leader>n :call NumberToggle()<CR>

" git/hg blame (annotate)
vnoremap <Leader>Bg :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
vnoremap <Leader>Bh :<C-U>!hg blame -nuc <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" quickly switch to last buffer
nnoremap <leader>l :b#<CR>

" show highlight group(s) under cursor
nmap <F2> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" ------------------------------------------
" Functions and autocmds
" ------------------------------------------

" strip trailing whitespace prior to save
"autocmd BufWritePre * :call TrimTrailingWhitespace()

autocmd Filetype lua setlocal ts=2 sw=2 sts=2 expandtab
autocmd Filetype json setlocal ts=2 sw=2 sts=2 expandtab

" uncomment to debug errors on Vim exit
"autocmd VimLeave * :sleep 5

" toggle between relative and absolute line numbers
function! NumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc

function! ShrinkMultipleNewlines()
    %s/\n\{2,\}$/\r/
endfunction

function! TrimTrailingWhitespace()
    %s/\s\+$//e
endfunction

