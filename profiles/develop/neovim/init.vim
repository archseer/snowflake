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
colors colibri

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

" let g:ncm2#complete_delay = 10
" let g:ncm2#popup_delay = 80
" let g:ncm2#total_popup_limit = 20

let g:completion_docked_hover = 1
" let g:completion_enable_snippet = "snippets.nvim"

inoremap <silent> <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Press enter key to trigger snippet expansion
" The parameters are the same as `:help feedkeys()`
let g:AutoPairsMapCR=0
inoremap <silent> <Plug>(MyCR) <CR><C-R>=AutoPairsReturn()<CR>
" inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<Plug>(MyCR)", 'im')


" <c-k> will either expand the current snippet at the word or try to jump to
" the next position for the snippet.
" inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>

" <c-j> will jump backwards to the previous field.
" If you jump before the first field, it will cancel the snippet.
" inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>

" -- Language servers -------------------------------------------------------
hi link LspDiagnosticsWarning WarningMsg
hi link LspDiagnosticsInformation Todo
hi link LspDiagnosticsError ErrorMsg

hi LspDiagnosticsUnderlineWarning gui=underline
hi LspDiagnosticsUnderlineInformation gui=underline
hi LspDiagnosticsUnderlineError gui=underline

hi link LspDiagnosticsVirtualTextError LspDiagnosticsError
hi link LspDiagnosticsVirtualTextWarning LspDiagnosticsWarning
hi link LspDiagnosticsVirtualTextInformation LspDiagnosticsInformation
hi link LspDiagnosticsVirtualTextHint LspDiagnosticsHint

" -- Fixes whitespace highlighted in popups
highlight mkdLineBreak guifg=none guibg=none

sign define LspDiagnosticsSignError text=● texthl=LspDiagnosticsError linehl= numhl=
sign define LspDiagnosticsSignWarning text=● texthl=LspDiagnosticsWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text=● texthl=LspDiagnosticsInformation linehl= numhl=
sign define LspDiagnosticsSignHint text=● texthl=LspDiagnosticsHint linehl= numhl=

set signcolumn=yes
packadd nvim-lspconfig
packadd completion-nvim
" packadd snippets.nvim
lua << EOF

local nvim_lsp = require('lspconfig')
local completion = require('completion')
-- local snippets = require('snippets')

-- snippets.set_ux(require'snippets.inserters.vim_input')

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      spacing = 1,
      prefix = '',
    },

    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    update_in_insert = false,
  }
)

local on_attach = function(_, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  completion.on_attach()
end

-- vim.lsp.set_log_level(0)

nvim_lsp.rust_analyzer.setup {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        enable = true
      }
    },
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true
          }
        }
      }
    }
  }
}
EOF

function! SetupLSP()
  setlocal omnifunc=v:lua.vim.lsp.omnifunc
  " keywordprg
  nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
  " enter is go to definition
  nnoremap <silent> <CR>  <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> ]d    <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
  nnoremap <silent> [d    <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
  nnoremap <silent> <leader>do <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
  nnoremap <leader>dl <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
endfunction

augroup LSP
  au!
  au FileType rust call SetupLSP()
augroup END

" ---------------------------------------------------------------------------
"  Filetype/Plugin-specific config
" ---------------------------------------------------------------------------
" ruby private/protected indentation
let g:ruby_indent_access_modifier_style = 'outdent'
let ruby_operators = 1 " highlight operators

let g:rustfmt_autosave = 1

" vinarise
let g:vinarise_enable_auto_detect = 1
" Enable with -b option
augroup vinariseAuto
  autocmd!
  autocmd BufReadPre   *.bin let &binary =1
  autocmd BufReadPost  * if &binary | Vinarise | endif
augroup END

au filetype mail setl tw=72 fo=aw

augroup postcss
  autocmd!
  autocmd BufNewFile,BufRead *.css set filetype=postcss
augroup END

" vim-gitgutter
let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_removed = '▖'
let g:gitgutter_sign_removed_first_line = '▘'
let g:gitgutter_sign_modified = '▐'
let g:gitgutter_sign_modified_removed = '▞'

" vim-test
let test#filename_modifier = ":p"
nnoremap <silent> <leader>t :TestNearest<CR>
nnoremap <silent> <leader>T :TestFile<CR>
nnoremap <silent> <leader>a :TestSuite<CR>
nnoremap <silent> <leader>l :TestLast<CR>
nnoremap <silent> <leader>g :TestVisit<CR>

" Default peekaboo window
let g:peekaboo_window = 'vertical botright 60new'

let g:highlightedyank_highlight_duration = 500
" ---------------------------------------------------------------------------
"  Mappings
" ---------------------------------------------------------------------------
" Dump ex mode for formatting
nnoremap Q gqip
vnoremap Q gq

" Steal hauleth's file closing mappings
nnoremap ZS :wa<CR>
nnoremap ZA :qa<CR>
nnoremap ZX :cq<CR>

" Save the file (if it has been modified)
nnoremap <silent> <leader>w :up<CR>

" Make Y behave like other capitals
nnoremap Y y$

" Copy/paste system buffer
noremap <leader>y "+y
noremap <leader>p "+p

" Switch from horizontal split to vertical split and vice versa
nnoremap <leader>- <C-w>t<C-w>H
nnoremap <leader>\ <C-w>t<C-w>K

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

" Write with sudo
cmap w!! w !sudo tee > /dev/null %

" Shortcut for emmet
imap <c-e> <c-y>,

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nmap gaa ga_

xmap <Leader>ga <Plug>(LiveEasyAlign)

" Create mappings (with leader)
nmap <Leader>as <Plug>(AerojumpSpace)
nmap <Leader>ab <Plug>(AerojumpBolt)
nmap <Leader>aa <Plug>(AerojumpFromCursorBolt)
" Boring mode
nmap <Leader>ad <Plug>(AerojumpDefault)

" -- fzf ---------------------------------------------------------------------
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :ProjectFiles<CR>
nnoremap <Leader>e :History<CR>
imap <c-x><c-l> <plug>(fzf-complete-line)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Customize fzf statusline
autocmd! User FzfStatusLine setlocal statusline=%#StatusLine#\ >\ fzf

" Customize fzf colors to match your color scheme
let g:fzf_colors =
      \ { 'fg':    ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

" if exists('$TMUX')
"   let g:fzf_layout = { 'tmux': '-p90%,60%' }
" else
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" endif

" -- vim-sandwich ------------------------------------------------------------
xmap im <Plug>(textobj-sandwich-literal-query-i)
xmap am <Plug>(textobj-sandwich-literal-query-a)
omap im <Plug>(textobj-sandwich-literal-query-i)
omap am <Plug>(textobj-sandwich-literal-query-a)
" in middle (of) {'_'  '.' ',' '/' '-')
xmap i_ im_
xmap a_ im_
omap i_ im_
omap a_ am_
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

"hi StatusError ctermbg=17 ctermfg=209 guibg=#F22C86 guifg=#281733
hi StatusError ctermbg=17 ctermfg=209 guifg=#f47868 guibg=#281733
hi StatusWarning ctermbg=17 ctermfg=209 guifg=#ffcd1c guibg=#281733
hi StatusOk ctermbg=17 ctermfg=209 guifg=#ffffff guibg=#281733
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
    if active != 0 " only show diagnostic information in the active window
      let l:errors = luaeval("vim.lsp.diagnostic.get_count([[Error]])")
      let l:warnings = luaeval("vim.lsp.diagnostic.get_count([[Warning]])")

      if (l:errors + l:warnings) == 0
        let status .=  '%#StatusOk#⬥ ok%* '
      else
        if l:errors > 0
          let status .=  '%#StatusError#'
          let status .= printf('⨉ %d', errors)
          let status .= '%* '
        endif
        if l:warnings > 0
          let status .=  '%#StatusWarning#'
          let status .= printf('● %d', warnings)
          let status .= '%* '
        endif
      endif
    endif
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

  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile *.graphql,*.graphqls,*.gql setfiletype graphql
  autocmd BufRead,BufNewFile *.lalrpop setfiletype rust
augroup END

augroup align_windows
  au!
  au VimResized * wincmd =
augroup END

" -- Abbreviations ----------------------------------------------------------
iabbrev jsut    just
iabbrev teh     the
iabbrev recieve receive
