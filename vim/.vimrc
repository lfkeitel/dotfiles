let mapleader="\<Space>"

" Genral UI settings
set number             " Enables the line numbers.
set ruler              " Enables the ruler on the bottom of the screen.
set laststatus=2       " Always show the statusline.
set showmatch          " Shows matching brackets when text indicator is over them.
set scrolloff=2        " Show the given number lines of context around the cursor.
set lazyredraw         " The screen won't be redrawn unless actions took place.
set scrolljump=0       " Jump only one line on scroll.
set showcmd            " Displays the selection size and the partion commands.
set ttyfast            " Improves redrawing for newer computers.
set nostartofline      " When moving thru the lines, the cursor will try to stay in the previous columns.

" Disable backup files, you are using a version control system anyway :)
set nobackup
set nowritebackup
set noswapfile

" Tab management
set tabstop=4          " How many spaces takes a tab character.
set softtabstop=4      " The number of spaces a tab character counts for.
set expandtab          " Use spaces instead of tabs for indenting.
set shiftwidth=4       " Autoindent width.
set smarttab           " A tab executes automatic indentation in insert mode.
set smartindent        " Adds automatic indentation on new line.
set autoindent         " Adds automatic indentation on copy paste as well.

" Buffer management
set hidden             " Enables hidden buffers. You don't have to close a buffer if you changes buffer.

" Search Options
" Highlight search.
nnoremap <leader>h :setlocal hlsearch!<cr>
set incsearch          " Incremental search.
set magic              " Set magic on, for regular expressions.
set ignorecase         " Searches are Non Case-sensitive.
set smartcase          " Overrides ignorecase, if search contains uppercase character.

nnoremap <leader>l :source ~/.vimrc<cr>

nnoremap ; :
vnoremap ; :

nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>mm :!clear && make<cr>
nnoremap <leader>mt :!clear && make test<cr>
nnoremap <leader>mc :!clear && make clean<cr>
nnoremap <leader>m<leader> :!clear && make

" Move lines in all modes
nnoremap J :m .+1<CR>==
nnoremap K :m .-2<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Uses https://github.com/junegunn/vim-plug for plugin management
call plug#begin('~/.vim/plugged')
  Plug 'jiangmiao/auto-pairs'
  Plug 'kana/vim-arpeggio'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'jeetsukumaran/vim-buffergator'
  Plug 'MattesGroeger/vim-bookmarks'
  Plug 'easymotion/vim-easymotion'
  Plug 'airblade/vim-gitgutter'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'scrooloose/nerdtree'
  Plug 'elzr/vim-json'
  Plug 'dbakker/vim-projectroot'
  Plug 'gregsexton/MatchTag'
  Plug 'mhinz/vim-startify'
  Plug 'tpope/vim-surround'
  Plug 'ervandew/supertab'
  Plug 'joeytwiddle/sexy_scroller.vim'
  Plug 'nathanalderson/yang.vim'
  Plug 'tpope/vim-repeat'
  Plug 'sukima/xmledit'
  Plug 'Blackrush/vim-gocode'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'tpope/vim-fugitive'
call plug#end()

"Arpeggio
call arpeggio#map('iv', '', 0, 'jk', '<Esc>')

"BetterWhitespace
nnoremap <leader>sw :StripWhitespace<cr>

"Bookmarks
let g:bookmark_sign = '>>'
let g:bookmark_annotation_sign = '##'
let g:bookmark_auto_close = 1
let g:bookmark_highlight_lines = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1
let g:bookmark_center = 1

"GitGutter
 let g:gitgutter_max_signs = 2000

"NERDTree
nnoremap <silent> <F2> :NERDTreeToggle<CR>
let g:NERDTreeMapMenu = '<F3>'
let g:NERDTreeChristmasTree = 1
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeWinPos = 'left'
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeDirArrows=0
let NERDTreeMinimalUI=0
let NERDTreeIgnore = ['\.pyc$']

"ProjectRoot
function! <SID>AutoProjectRootCD()
  try
    if &ft != 'help'
      ProjectRootCD
    endif
  catch
    " Silently ignore invalid buffers
  endtry
endfunction
autocmd BufEnter * call <SID>AutoProjectRootCD()

"SexyScroller
let g:SexyScroller_MaxTime = 400
let g:SexyScroller_EasingStyle = 3

set autoread

"Go source file settings
autocmd BufWritePost *.go silent !goreturns -w %
autocmd Filetype go setlocal noexpandtab

autocmd Filetype nerdtree setlocal nohlsearch

"Show invisible characters
nnoremap <leader>v :setlocal list!<cr>
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list

"Open NERDTree if no file was opened
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"Always show hidden files in NERDTree
let NERDTreeShowHidden=1

"Autocomplete setup
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

set t_Co=256
let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_powerline_fonts = 1
let g:airline_theme='dark'

"Rename tabs to show tab number.
"(Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction

"    set stal=2
"    set tabline=%!MyTabLine()
"    set showtabline=1
"    highlight link TabNum Special
endif

" Transparent editing of gpg encrypted files.
augroup encrypted
au!
" First make sure nothing is written to ~/.viminfo while editing
" an encrypted file.
autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
" We don't want a swap file, as it writes unencrypted data to disk
autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
" Switch to binary mode to read the encrypted file
autocmd BufReadPre,FileReadPre      *.gpg set bin
autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPre,FileReadPre      *.gpg let shsave=&sh
autocmd BufReadPre,FileReadPre      *.gpg let &sh='sh'
autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt --default-recipient-self 2> /dev/null
autocmd BufReadPost,FileReadPost    *.gpg let &sh=shsave
" Switch to normal mode for editing
autocmd BufReadPost,FileReadPost    *.gpg set nobin
autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
" Convert all text to encrypted text before writing
autocmd BufWritePre,FileWritePre    *.gpg set bin
autocmd BufWritePre,FileWritePre    *.gpg let shsave=&sh
autocmd BufWritePre,FileWritePre    *.gpg let &sh='sh'
autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --encrypt --default-recipient-self 2>/dev/null
autocmd BufWritePre,FileWritePre    *.gpg let &sh=shsave
" Undo the encryption so we are back in the normal text, directly
" after the file has been written.
autocmd BufWritePost,FileWritePost  *.gpg silent u
autocmd BufWritePost,FileWritePost  *.gpg set nobin
augroup END
