let mapleader = ","

"-------------------------
" plugin
"-------------------------
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=~/.vim/neobundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))
" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc', {
    \'build' : {
    \   'windows' : 'make -f make_mingw32.mak',
    \   'cygwin'  : 'make -f make_cygwin.mak',
    \   'mac'     : 'make -f make_mac.mak',
    \   'unix'    : 'make -f make_unix.mak',
    \   },
    \}

"" Display
" ----------------------------------------
"
" powerlineline
NeoBundle 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'solarized'
      \ }
if !has('gui_running')
  set t_Co=256
endif
" solarizedcolor schema
NeoBundle 'altercation/vim-colors-solarized'

"" Unite
" ----------------------------------------
"
NeoBundleLazy 'tsukkee/unite-tag', {
      \ 'autoload' : {
      \   'commands' : [ 'Unite' ]
      \ }}
let s:bundle = neobundle#get('unite-tag')
function! s:bundle.hooks.on_source(bundle)
  autocmd BufEnter *
  \   if empty(&buftype)
  \|      nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
  \|  endif

  autocmd BufEnter *
  \   if empty(&buftype)
  \|      nnoremap <buffer> <C-t> :<C-u>Unite jump<CR>
  \|  endif
endfunction

NeoBundleLazy 'Shougo/unite.vim', {
      \ 'autoload' : {
      \   'commands' : [ 'Unite' ]
      \ }}
let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle)
  let g:unite_enable_start_insert=1 "start by insert mode

  " Ignore settings
  let ignore_sources = []
  if filereadable('./.gitignore')
    for file in readfile('./.gitignore')
      " コメント行と空行は追加しない
      if file !~ "^#\\|^\s\*$"
        call add(ignore_sources, file)
      endif
    endfor
  endif
  if isdirectory('./.git')
    call add(ignore_sources, '.git')
  endif
  let ignore_sources = ignore_sources + ['.png', '.jpg', '.jpeg', '.svg', '.ico', '.mp4', '.webm']
  let ignore_pattern = escape(join(ignore_sources, '|'), './|')
  call unite#custom#source('file_rec', 'ignore_pattern', ignore_pattern)
  call unite#custom#source('grep', 'ignore_pattern', ignore_pattern)

  " recent access file list
  noremap <C-U><C-U> :Unite file_rec<CR>
  " file list
  noremap <C-U><C-D> :Unite file<CR>
  " file buffer list
  noremap <C-U><C-B> :Unite buffer<CR>

  " use grep by ag
  if executable('pt')
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_grep_encoding = 'utf-8'
  endif

  " when only open unite, active key mappings
  augroup vimrc
    autocmd FileType unite call s:unite_my_settings()
  augroup END
  function! s:unite_my_settings()
    " Quite Unite by :q
    au FileType unite nnoremap <silent> <buffer> <C-j><C-j> :q<CR>
    au FileType unite inoremap <silent> <buffer> <C-j><C-j> <ESC>:q<CR>

    " split open
    nnoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
    inoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
    " vslipt open
    nnoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
    inoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
    " open as vimfiler
    nnoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
    inoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
  endfunction
endfunction


" vimfiler{{{
NeoBundle 'Shougo/vimfiler', {
      \   'depends' : [ 'Shougo/unite.vim' ]
      \ }
let s:bundle = neobundle#get('vimfiler')
function! s:bundle.hooks.on_source(bundle)
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_safe_mode_by_default = 0

  noremap <C-U><C-F> :VimFilerExplorer<CR>
endfunction

"" atometic open Vimfilerexplorer
let file_name = expand("%")
if has('vim_starting') && file_name == ""
  autocmd VimEnter * VimFilerExplorer ./
endif
"}}}


"" utility
" ----------------------------------------
"let mapleader = ","
NeoBundle 'Shougo/vimshell.vim'

" " vim-quickrun {{{
" NeoBundleLazy "thinca/vim-quickrun", {
"       \ "autoload": {
"       \   "mappings": [['nxo', '<Plug>(quickrun)']]
"       \ }}
" let s:bundle = neobundle#get('vim-quickrun')
" function! s:bundle.hooks.on_source(bundle)
"   let g:quickrun_config = {
"         \ "*": {"runner": "remote/vimproc"},
"         \ }
" endfunction
" "}}}

NeoBundle 'tpope/vim-dispatch'
NeoBundle 'vim-scripts/YankRing.vim'
NeoBundle 'vim-scripts/surround.vim'
NeoBundle 'junegunn/vim-easy-align'
let s:bundle = neobundle#get('vim-easy-align')
function! s:bundle.hooks.on_source(bundle)
  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <Enter> <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
  nmap <Leader>a <Plug>(EasyAlign)
endfunction

"" complement
" ----------------------------------------
"
NeoBundleLazy 'Shougo/neocomplcache', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ } }
let s:bundle = neobundle#get('neocomplcache')
function! s:bundle.hooks.on_source(bundle)
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplcache
  let g:neocomplcache_enable_at_startup = 1
  " Use smartcase
  let g:neocomplcache_enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplcache_min_syntax_length = 3
  let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

  " Define dictionary.
  let g:neocomplcache_dictionary_filetype_lists = {
     \ 'default' : '',
     \ 'vimshell' : $HOME.'/.vimshell_hist',
     \ }

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplcache#smart_close_popup() . "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplcache#close_popup()
  inoremap <expr><C-e>  neocomplcache#cancel_popup()

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
  " Enable heavy omni completion.
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif
  let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
  let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
endfunction

" NeoBundleLazy 'mattn/emmet-vim', {
"     \ 'autoload': {'filetypes': ['html','ruby','php','css'] }}
" let s:bundle = neobundle#get('emmet-vim')
" function! s:bundle.hooks.on_source(bundle)
"   let g:user_emmet_settings = {
"     \  'php' : {
"     \    'extends' : 'html',
"     \    'filters' : 'c',
"     \  },
"     \  'xml' : {
"     \    'extends' : 'html',
"     \  },
"     \  'haml' : {
"     \    'extends' : 'html',
"     \  },
"     \}
" endfunction

"" git
" ----------------------------------------
NeoBundle 'tpope/vim-fugitive'
let s:bundle = neobundle#get('vim-fugitive')
function! s:bundle.hooks.on_source(bundle)
  "vim-fugitive map map
  nnoremap <silent> <Space>gb :Gblame<CR>
  nnoremap <silent> <Space>gd :Gdiff<CR>
  nnoremap <silent> <Space>gs :Gstatus<CR>
endfunction

"" sunippet
"
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
let s:bundle = neobundle#get('neosnippet')
function! s:bundle.hooks.on_source(bundle)
  " Plugin key-mappings.
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)

  " SuperTab like snippets behavior.
  imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
        \ "\<Plug>(neosnippet_expand_or_jump)"
        \: pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
        \ "\<Plug>(neosnippet_expand_or_jump)"
        \: "\<TAB>"
endfunction

"" syntax
" ----------------------------------------
"
" syntax highlight
NeoBundleLazy 'othree/html5.vim.git', {
    \ 'autoload': {'filetypes': ['html'] }}
" ini
NeoBundleLazy 'vim-scripts/ini-syntax-definition', {
    \ 'autoload': {'filetypes': ['dosini'] }}
" template engine
NeoBundleLazy 'tpope/vim-haml', {
    \ 'autoload': {'filetypes': ['haml', 'scss'] }}
NeoBundleLazy 'slim-template/vim-slim', {
    \ 'autoload': {'filetypes': ['slim'] }}
" css
NeoBundleLazy 'hail2u/vim-css3-syntax', {
    \ 'autoload': {'filetypes': ['css']}}
" less
NeoBundleLazy 'groenewege/vim-less', {
    \ 'autoload': { 'filetypes': 'less'}}
" scss
NeoBundleLazy 'cakebaker/scss-syntax.vim', {
    \ 'autoload': { 'filetypes': ['scss'] }}
"js,node
NeoBundleLazy 'pangloss/vim-javascript', {
    \ 'autoload': { 'filetypes': ['javascript']}}
NeoBundleLazy 'kchmck/vim-coffee-script', {
    \ 'autoload': { 'filetypes': ['coffee']}}
" python
NeoBundleLazy 'python.vim', {
    \ 'autoload': { 'filetypes': ['python']}}
"" objective-c
NeoBundleLazy 'msanders/cocoa.vim', {
    \ 'autoload': { 'filetypes': ['objc']}}


"" ruby, rails
" ----------------------------------------
" Ruby static code analyzer.
NeoBundleLazy 'ngmy/vim-rubocop', {
    \   'autoload' : { 'filetypes' : ['ruby'] }
    \ }
let s:bundle = neobundle#get('vim-rubocop')
function! s:bundle.hooks.on_source(bundle)
  let g:vimrubocop_keymap = 0
  nmap <Leader>r :RuboCop<CR>
endfunction

" NeoBundleLazy 'vim-ruby/vim-ruby', {
"     \   'autoload' : { 'filetypes' : ['ruby', 'haml', 'slim'] }
"     \ }
" NeoBundleLazy 'tpope/vim-rails', {
"     \   'autoload' : { 'filetypes' : ['ruby', 'haml', 'slim'] }
"     \ }
" NeoBundleLazy 'ujihisa/unite-rake', {
"     \   'autoload' : { 'filetypes' : ['ruby', 'haml', 'slim'] },
"     \   'depends' : [ 'Shougo/unite.vim' ]
"     \ }
" unite-rails {{{
NeoBundleLazy 'basyura/unite-rails', {
    \   'autoload' : { 'filetypes' : ['ruby', 'haml', 'slim'] },
    \   'depends' : ['Shougo/unite.vim']
    \ }
let s:bundle = neobundle#get('unite-rails')
function! s:bundle.hooks.on_source(bundle)
  noremap <C-H><C-H> :Unite file_rec:app<CR>
  noremap <C-H>s :Unite file_rec:spec<CR>
  " noremap <C-H>c :Unite file_rec:config<CR>
  noremap <C-H>c :Unite rails/config<CR>
  noremap <C-H>d :Unite rails/db<CR>
  noremap <C-H>l :Unite rails/lib<CR>
endfunction
" }}}

" rspec
NeoBundleLazy 'thoughtbot/vim-rspec', {
    \ 'depends'  : 'tpope/vim-dispatch',
    \   'autoload' : { 'filetypes' : ['ruby', 'haml', 'slim'] }
    \ }
let s:bundle = neobundle#get('vim-rspec')
let g:rspec_command = "Dispatch rspec {spec}"
function! s:bundle.hooks.on_source(bundle)
  " RSpec.vim mappings
  map <Leader>t :call RunCurrentSpecFile()<CR>
  map <Leader>s :call RunNearestSpec()<CR>
  map <Leader>l :call RunLastSpec()<CR>
  map <Leader>a :call RunAllSpecs()<CR>
endfunction


call neobundle#end()
" required!
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

"-------------------------
"search
"-------------------------
set hlsearch   "Highlight searche
set incsearch  "incrimental search
set ignorecase "Use case insensitive search, except when using capital letters
set smartcase  "undifferentiated
set wrapscan

"escape /,?
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'))

"-------------------------
" tag
"-------------------------
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " already show tab line

nnoremap [Tag] <Nop>
nmap t [Tag]

" create new tab
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" close tab
map <silent> [Tag]x :tabclose<CR>
" next tab
map <silent> [Tag]n :tabnext<CR>
" previous tab
map <silent> [Tag]p :tabprevious<CR>

"-------------------------
" edit
"-------------------------
set shiftround "<,>,indent width is shiftwidth
set infercase "undifferentiated compl
set hidden "alternative close. Use undo history
set switchbuf=useopen "open buffer alternative new one
set showmatch
set matchpairs& matchpairs+=<:> "add matchtipes <>

"backspace can delete any item
set backspace=indent,eol,start

" Yank
if has('unnamedplus')
  set clipboard& clipboard+=unnamedplus
else
  " set clipboard& clipboard+=unnamed,autoselect 2013-06-24 10:00 autoselect 削除
  set clipboard& clipboard+=unnamed
endif
" share Mac OS X ClipBoard
vmap <C-c> :w !pbcopy<cr><cr>

"backups
set nobackup
set noswapfile
set nowritebackup

" Run :FixWhitespace to remove end of line white space
function! s:FixWhitespace(line1,line2)
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/\s\+$//'
    call setpos('.', l:save_cursor)
endfunction
command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)

"-------------------------
" ctags
"-------------------------
set tags=./tags

"-------------------------
" display
"-------------------------
set showmode
set showcmd "Show partial commands in the last line of the screen
set title
set number "Display line numbers on the left
set ruler "Display the cursor position
set laststatus=2 "Always display the status line
set cmdheight=2 "cmd line hiehgt
set visualbell "Use visual bell instead of beeping when doing something wrong
set nowrap "nowrap sentence

" invisible charactor visual setting
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<
highlight JpSpace cterm=underline ctermfg=Blue guifg=Blue
match JpSpace /　/

" negative screen bell
set t_vb=
set novisualbell

" colorscheme
syntax enable
colorscheme solarized

" tab, indent
set smartindent
set ts=2 sw=2 sts=0
set expandtab
set backspace=indent,eol,start "Allow backspacing over autoindent, line breaks and start of insert action

" colorcolumn
set colorcolumn=120

"-------------------------
" keybind & mcro
"-------------------------
" escape
imap <C-j> <C-[>

" escape Highlight
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

"selection line by double v
vnoremap v $h

" bracket
imap { {}<LEFT>
imap [ []<LEFT>
imap ( ()<LEFT>

" trim space
nmap <C-t> :%s/ *$//g<CR><Esc><Esc>

set nostartofline "Stop certain movements from always going to the first character of a line.
set mouse=a "Set the command window height to 2 lines, to avoid many cases of having to press <Enter> to continue

"-------------------------
" complement
"-------------------------
set wildmenu "Better command-line completion

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
