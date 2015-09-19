"
"       \        /
"        \      /
"         \____/
"         /  __\     Welcome to Ben's Vimrc File
"        |  / ..\      <benjamin@direwolfdigital.com>
"        |  \_/\/
"      __|   ___\
"     /   \      \
"    / |   \      |
" (( \__\________/
"
"
set backup

if has("win32") || has("win64")
  set directory=$TMP
  set backupdir=$TMP
  set backupskip=$TMP
  "removes the scrollbars in gvim (hates them i does)
  set guioptions+=LlRrb
  set guioptions-=LlRrb
else
  set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
  set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
  set backupskip=/tmp/*,/private/tmp/*
  set guioptions+=LlRrb
  set guioptions-=LlRrb
end

call pathogen#infect()
call pathogen#helptags()

set writebackup
set autoread
set nowrap
set ffs=unix,dos
set go-=m go-=T go-=r
set tags=./tags,~/src/tags,e:/dwd/tags;
set runtimepath+=$HOME/vimfiles/UltiSnips-1.5
set directory+=,~/tmp,$TMP
set virtualedit=all
set wildignore+=*.o,*.obj,.git,target/*

let g:rct_completion_use_fri = 1
let g:Tex_ViewRule_pdf = "kpdf"

filetype plugin indent on
syntax on

"{{{Auto Commands
let mapleader = ","
au BufRead,BufNewFile *.scala set filetype=scala
au BufRead,BufNewFile *.iced set filetype=coffee
au BufRead,BufNewFile *.as set filetype=actionscript
au BufRead,BufNewFile *.tt set filetype=html

" remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
  au!
  autocmd BufReadPost *
        \ if expand("<afile>:p:h") !=? $TEMP |
        \   if line("'\"") > 1 && line("'\"") <= line("$") |
        \     let JumpCursorOnEdit_foo = line("'\"") |
        \     let b:doopenfold = 1 |
        \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
        \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
        \        let b:doopenfold = 2 |
        \     endif |
        \     exe JumpCursorOnEdit_foo |
        \   endif |
        \ endif
  " Need to postpone using "zv" until after reading the modelines.
  autocmd BufWinEnter *
        \ if exists("b:doopenfold") |
        \   exe "normal zv" |
        \   if(b:doopenfold > 1) |
        \       exe  "+".1 |
        \   endif |
        \   unlet b:doopenfold |
        \ endif
augroup END

"}}}

"{{{Misc Settings

"makes it so magical dots appear while typing, showing the total spaces
"also shows a pound sign when the column gets to logn
set list
set listchars=tab:\|-,trail:.,extends:>,precedes:<
autocmd filetype html,xml set listchars-=tab:>.

" Necesary  for lots of cool vim things
set nocompatible

" Sets history to be the boss
set history=1000

" This shows what you are typing as a command.  I love this!
set showcmd

" Folding Stuffs
set foldmethod=marker

" Needed for Syntax Highlighting and stuff
filetype on
filetype plugin on
syntax enable
set grepprg=grep\ -nH\ $*
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
" Who doesn't like autoindent?
set autoindent

" Spaces are better than a tab character
set expandtab
set smarttab

" Who wants an 8 character tab?  Not me!
set shiftwidth=2
set softtabstop=2

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
  set spl=en spell
  set nospell
endif

" Real men use gcc
"compiler gcc

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=a

" Got backspace?
set backspace=2

" Line Numbers PWN!
set number

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intellegence!
set smartcase

" This is totally awesome - remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <Esc>

nnoremap JJJJ <Nop>

" Incremental searching is sexy
set incsearch

" Highlight things that we find with the search
set hlsearch

" Since I use linux, I want this
let g:clipbrdDefaultReg = '+'

" When I close a tab, remove the buffer
set nohidden

" Set off the other paren
highlight MatchParen ctermbg=4

" fix the behavior of centering
vnoremap <silent> zz :<C-u>call setpos('.',[0,(line("'>")-line("'<"))/2+line("'<"),0,0])<Bar>normal! zzgv<CR>
vnoremap <silent> zt :<C-u>call setpos('.',[0,line("'<"),0,0])<Bar>normal! ztgv<CR>
vnoremap <silent> zb :<C-u>call setpos('.',[0,line("'>"),0,0])<Bar>normal! zbgv<CR>

" }}}

"{{{Look and Feel

" Favorite Color Scheme
if has("gui_running")
  "Terminus is AWESOME
  set guifont=Terminus
  set guioptions-=T
  colorscheme jellybeans
else
  colorscheme desert
endif

"Status line gnarliness - powerline
set laststatus=2
let g:Powerline_symbols = 'fancy'
" }}}

"{{{ Functions

"{{{ Open URL in browser

function! Browser ()
  let line = getline (".")
  let line = matchstr (line, "http[^   ]*")
  exec "!konqueror ".line
endfunction

"}}}

"{{{Theme Rotating
let themeindex=0
function! RotateColorTheme()
  let y = -1
  while y == -1
    let colorstring = "inkpot#ron#blue#elflord#evening#koehler#murphy#pablo#desert#torte#"
    let x = match( colorstring, "#", g:themeindex )
    let y = match( colorstring, "#", x + 1 )
    let g:themeindex = x + 1
    if y == -1
      let g:themeindex = 0
    else
      let themestring = strpart(colorstring, x + 1, y - x - 1)
      return ":colorscheme ".themestring
    endif
  endwhile
endfunction
" }}}

"{{{ Paste Toggle
let paste_mode = 0 " 0 = normal, 1 = paste

func! Paste_on_off()
  if g:paste_mode == 0
    set paste
    let g:paste_mode = 1
  else
    set nopaste
    let g:paste_mode = 0
  endif
  return
endfunc
"}}}

" NEO CACHE SETTINGS"{{{
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'


" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif"}}}

" Toggle relative/absolute numbering"{{{
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc "}}}

" Grep function {{{
function! SearchCurrentDirectory()
  let s:pat=input("Grep: ")
  let s:path=input("Path to search (ENTER for pwd): ", "", "dir")
  let s:ext=input("File extension (ENTER for all files): ")
  if s:ext==""
    let s:ext="*"
  endif
  if s:path==""
    let s:path="."
  endif
  if s:pat!=""
    execute("vimgrep /".s:pat."/gj ".s:path."/**/*.".s:ext)
    copen
  endif
endfunction


" }}} End Grep

"}}}

"{{{ Mappings

" crosshairs
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

" ,cd changes the current directory to here!
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

" Open Url on this line with the browser \w
map <Leader>w :call Browser ()<CR>

" Open Lusty Juggler
nnoremap <Leader>l :LustyJuggler<CR>

" Open the Project Plugin
nnoremap <silent> <Leader>pal  :Project .vimproject<CR>

" NOH please
nnoremap <silent> <F2> :noh<CR>


" take bufter and paste to new window
nnoremap <silent> <F3> :redir @a<CR>:g//<CR>:redir END<CR>:new<CR>:put! a<CR><CR>

" Grep for whatever
nnoremap <silent> <F4> :execute SearchCurrentDirectory()<CR>

" Open the Project Plugin <F2>
nnoremap <silent> <F5> :Project<CR>

" Switch Windows
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j

" Switch Tabs
nnoremap <A-Left> :tabprevious<CR>
nnoremap <A-Right> :tabnext<CR>
nnoremap <A-Up> :tn<CR>
nnoremap <A-Down> :tp<CR>:redraw<CR>

" Rotate Color Scheme <F8>
nnoremap <silent> <F8> :execute RotateColorTheme()<CR>

" Paste Mode!  Dang! <F10>
nnoremap <silent> <F10> :call Paste_on_off()<CR>
set pastetoggle=<F10>

" Edit vimrc \ev
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>

" Edit gvimrc \gv
nnoremap <silent> <Leader>gv :tabnew<CR>:e ~/.gvimrc<CR>

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

" Good call Benjie (r for i)
nnoremap <silent> <Home> i <Esc>r
nnoremap <silent> <End> a <Esc>r

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Space will toggle folds!
nnoremap <space> za

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

" Testing
set completeopt=longest,menuone,preview

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

" Swap ; and :  Convenient.
"nnoremap ; :
"nnoremap : ;

nnoremap <C-L> :call NumberToggle()<cr>



" Fix email paragraphs
nnoremap <leader>par :%s/^>$//<CR>

"make the middle mouse button paste
map <MiddleButton> "*p

"}}}

"{{{Taglist configuration
let Tlist_Use_Right_Window = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick = 1
let Tlist_Inc_Winwidth = 0
"}}}


let s:tlist_def_scala_settings = 'scala;t:trait;c:class;T:type;' .
      \ 'm:method;C:constant;l:local;p:package;o:object'

vmap <leader>c <esc>:'<,'>:CoffeeCompile<CR>
map <leader>c :CoffeeCompile<CR>

