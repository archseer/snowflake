" ---------------------------------------------------------------------------
" General
" ---------------------------------------------------------------------------
let mapleader=" "
let maplocalleader="\\"

" for some reason, using vim8 packages, these two won't be set to on
filetype plugin indent on
syntax on

" for some reason the clipboard never got initialized
" runtime autoload/provider/clipboard.vim
let g:loaded_netrwPlugin = 1 " unload netrw, we use dirvish

set nobackup noswapfile   " do not keep backups or swaps
set undofile

" -- Colors / Theme ---------------------------------------------------------
set background=dark
set termguicolors
colors desert

"  -- UI --------------------------------------------------------------------
set title
"set ch=2                   " command line height
set hidden                 " allow buffer switching without saving
set lazyredraw             " no redraws in macros
set number                 " line numbers
set numberwidth=5          " 3 digit line numbers don't get squashed
set wildmode=list:longest,full
" Ignore all automatic files and folders
set wildignore=*.o,*~,*/.git,*/tmp/*,*/node_modules/*,*/_build/*,*/deps/*,*/target/*
set fileignorecase
set shortmess+=aAI         " shorten messages
set report=0               " tell us about changes
set mousehide              " Hide the mouse pointer while typing
set nostartofline          " don't jump to the start of line when scrolling
set sidescroll=1
set scrolloff=5            " minimum lines to keep above and below cursor
set sidescrolloff=7
set splitbelow splitright  " splits that make more sense
set switchbuf=useopen      " When buffer already open, jump to that window
set diffopt+=iwhite        " Add ignorance of whitespace to diff
set diffopt+=vertical      " Allways diff vertically
set synmaxcol=200          " Boost performance of rendering long lines
" set guicursor=

set conceallevel=2

" -- Search -----------------------------------------------------------------
set ignorecase smartcase   " ignore case for searches without capital letters
if executable('rg')        " Use rg over grep
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif
" toggle search highlighting
nnoremap <silent> <leader>h :noh<cr>

" -- Visual Cues ------------------------------------------------------------
set showmatch matchtime=2  " show matching brackets/braces (2*1/10 sec)
set cpoptions+=$           " in the change mode, show an $ at the end
set inccommand=nosplit     " live substitution preview
if has('patch-7.4.338')
  let &showbreak = '↳ '
  set breakindent          " when wrapping, indent the lines
  set breakindentopt=sbr
endif
set fillchars=diff:⣿,vert:│,fold:·
" show whitespace with <leader>s
set listchars=tab:——,trail:·,eol:$,space:·
"set listchars+=extends:›,precedes:‹,nbsp:␣
nnoremap <silent> <leader>s :set nolist!<CR>

" -- Text Formatting --------------------------------------------------------
" Don't mess with 'tabstop', with 'expandtab' it isn't used.
" Instead set softtabstop=-1, then 'shiftwidth' is used.
set expandtab shiftwidth=2 softtabstop=-1
set shiftround             " Round indent shift to multiple of shiftwidth
set textwidth=80           " wrap at 80 chars by default
set colorcolumn=+1
set virtualedit=block      " allow virtual edit in visual block ..
set nojoinspaces           " Use one space, not two, after punctuation.
set linebreak
set nowrap                 " do not wrap lines
set formatoptions+=rno1l   " support for numbered/bullet lists, etc.
set tags="~/.vim/tags"
" ---------------------------------------------------------------------------
"  Completion / Snippets
" ---------------------------------------------------------------------------
set completeopt=noinsert,menuone,noselect
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

inoremap <silent> <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

set signcolumn=yes

" ---------------------------------------------------------------------------
"  Mappings
" ---------------------------------------------------------------------------
" Dump ex mode for formatting
nnoremap Q gqip
vnoremap Q gq

" Save the file (if it has been modified)
nnoremap <silent> <leader>w :up<CR>

" Make Y behave like other capitals
nnoremap Y y$

" Copy/paste system buffer
noremap <leader>y "+y
noremap <leader>p "+p

noremap <leader>v <C-w>v

" close current buffer with <leader>x
noremap <silent> <leader>x :bd<CR>
noremap <silent> <leader>c :q<CR>

" practical vim: use c-p, c-n with filtered command history
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" <tab> / <s-tab> | Circular windows navigation
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W
" Switch between the last two files
nnoremap <leader><leader> <c-^>

" ----------------------------------------------------------------------------
" Statusline
" ----------------------------------------------------------------------------
function! StatusHighlight(mode)
  if a:mode == 'n' || a:mode == 'c'
    return 'NOR'
  elseif a:mode == 'i'
    return 'INS'
  elseif a:mode == 'R'
    return 'REP'
  elseif a:mode == 't'
    return 'TER'
  elseif a:mode =~# '\v(v|V||s|S|)'
    return a:mode == 'v' ? 'VIS' : a:mode == 'V' ? 'V-L' : 'V-B'
  else
    return a:mode
  endif
endfunction

function! Status(winnr)
  let active = a:winnr == winnr() || winnr('$') == 1
  let status = ''
  if active != 0
    let status .= ' %{StatusHighlight(mode())} '
  endif
  let status .= ' %{fnamemodify(expand("%"), ":~:.")}%w%q%h%r%<%m '
  let status .= '%{&paste?"[paste]":""}'

  if &filetype != 'netrw' && &filetype != 'undotree'
    let status .= '%='
    if &fenc != 'utf-8'
      let status .=  ' %{&fileencoding} |'
    endif
    let status .=  ' %{&filetype}  %l:%c '
  endif
  return status
endfunction

function! StatusUpdate()
  for winnr in range(1, winnr('$'))
    call setwinvar(winnr, '&statusline', '%!Status(' . winnr . ')')
  endfor
endfunction

set noshowmode " we show it in the statusline
augroup status-update
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter,BufUnload * call StatusUpdate()
augroup END
" ----------------------------------------------------------------------------
" Functions
" ----------------------------------------------------------------------------
function! Preserve(cmd)
  let _s = @/ | let _pos = getpos('.') " Save search history and cursor position
  execute a:cmd
  let @/ = _s | call setpos('.', _pos) " Restore search and position
endfunction

nnoremap _$ :call Preserve("%s/\\s\\+$//e")<CR>

" HL | Find out syntax group
function! s:hl()
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction
command! HL call <SID>hl()

augroup vimrcEx
  autocmd!
  " Auto create directories for new files.
  au BufWritePre,FileWritePre * call mkdir(expand('<afile>:p:h'), 'p')

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

augroup align_windows
  au!
  au VimResized * wincmd =
augroup END

au TextYankPost * silent! lua require'highlight'.on_yank("IncSearch", 500, vim.v.event)
