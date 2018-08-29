" vim: fdm=marker foldenable sw=4 ts=4 sts=4
" Lee Keitel's .vimrc file
" "zo" to open folds, "zc" to close, "zn" to disable.

" {{{ Plugins
" Uses https://github.com/junegunn/vim-plug for plugin management
call plug#begin('~/.vim/plugged')
    Plug 'benmills/vimux'
    Plug 'PotatoesMaster/i3-vim-syntax', { 'for': 'i3' }
    Plug 'kana/vim-arpeggio'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'jeetsukumaran/vim-buffergator'
    Plug 'easymotion/vim-easymotion'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'elzr/vim-json', { 'for': 'json' }
    Plug 'dbakker/vim-projectroot'
    Plug 'gregsexton/MatchTag'
    Plug 'mhinz/vim-startify', { 'on': 'Startify' }
    Plug 'tpope/vim-surround'
    Plug 'nathanalderson/yang.vim', { 'for': 'yang' }
    Plug 'tpope/vim-repeat'
    Plug 'sukima/xmledit', { 'for': 'xml' }
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-commentary'
    Plug 'christoomey/vim-sort-motion'
    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-textobj-entire'
    Plug 'kana/vim-textobj-indent'
    Plug 'kana/vim-textobj-line'
    Plug 'PProvost/vim-ps1', { 'for': 'ps1' }
    Plug 'leafgarland/typescript-vim'
    Plug 'Quramy/tsuquyomi'
    Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity'] }
    Plug 'vim-syntastic/syntastic'

" {{{ Rust
    Plug 'racer-rust/vim-racer', { 'for': 'rust' }
    Plug 'rust-lang/rust.vim'

    au FileType rust nmap gd <Plug>(rust-def)
    au FileType rust nmap gs <Plug>(rust-def-split)
    au FileType rust nmap gx <Plug>(rust-def-vertical)
    au FileType rust nmap <leader>gd <Plug>(rust-doc)
" }}}

" {{{ Sexy scroller
    Plug 'joeytwiddle/sexy_scroller.vim'

    let g:SexyScroller_MaxTime = 400
    let g:SexyScroller_EasingStyle = 3
" }}}

" {{{ NerdTree
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

    let g:NERDTreeMapMenu = '<F3>'
    let g:NERDTreeChristmasTree = 1
    let g:NERDTreeCaseSensitiveSort = 0
    let g:NERDTreeQuitOnOpen = 1
    let g:NERDTreeWinPos = 'left'
    let g:NERDTreeShowBookmarks = 1
    let g:NERDTreeDirArrows = 0
    let g:NERDTreeMinimalUI = 0
    let g:NERDTreeIgnore = ['\.pyc$']
    let g:NERDTreeShowHidden = 1
    autocmd Filetype nerdtree setlocal nohlsearch
" }}}

" {{{ Git gutter
    Plug 'airblade/vim-gitgutter'

    let g:gitgutter_max_signs = 2000
" }}}

" {{{ Bookmarks
    Plug 'MattesGroeger/vim-bookmarks'

    let g:bookmark_sign = '>>'
    let g:bookmark_annotation_sign = '##'
    let g:bookmark_auto_close = 1
    let g:bookmark_highlight_lines = 1
    let g:bookmark_save_per_working_dir = 1
    let g:bookmark_auto_save = 1
    let g:bookmark_center = 1
" }}}

" {{{ System copy
    Plug 'christoomey/vim-system-copy'

    " xclip is already installed for Tmux, might as well use it
    let g:system_copy#copy_command='xclip -sel clipboard'
    let g:system_copy#paste_command='xclip -sel clipboard -o'
" }}}

" {{{ Titlecase
    Plug 'christoomey/vim-titlecase'

    let g:titlecase_map_keys = 0
" }}}

" {{{ Golang
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }
    Plug 'zchee/deoplete-go', { 'for': 'go' }
" }}}

" {{{ Deoplete
    if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    endif

    let g:deoplete#enable_at_startup = 1
" }}}

" {{{ CtrlP
    Plug 'ctrlpvim/ctrlp.vim'

    " Setup some default ignores
    let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site|node_modules)$',
      \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
    \}

    " Use the nearest .git directory as the cwd
    " This makes a lot of sense if you are working on a project that is in version
    " control. It also supports works with .svn, .hg, .bzr.
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_map = '<leader>p'
    let g:ctrlp_cmd = 'CtrlPMixed'
    let g:ctrlp_show_hidden = 1
" }}}

" {{{ Auto Pairs
    Plug 'jiangmiao/auto-pairs'

    " Disable auto-pairs from taking over C-h in i mode
    let g:AutoPairsMapCh = 0
" }}}

" {{{ Silver Searcher
    Plug 'mileszs/ack.vim'
    if executable('ag')
      let g:ackprg = 'ag --nogroup --nocolor --column'
    endif

    cnoreabbrev Ack Ack!
    nnoremap <Leader>a :Ack!<Space>
" }}}

" {{{ Airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    set t_Co=256
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#fnamemod = ':t'
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_symbols.space = "\ua0"
    let g:airline_powerline_fonts = 1
    let g:airline_theme='dark'
    if has('nvim')
    set termguicolors
    endif
" }}}
call plug#end()
" }}}

" {{{ General UI settings
if has('mouse')
set mouse=a " Enable mouse
endif
set number relativenumber " Enables the line numbers.
set ruler                 " Enables the ruler on the bottom of the screen.
set laststatus=2          " Always show the statusline.
set showmatch             " Shows matching brackets when text indicator is over them.
set scrolloff=2           " Show the given number lines of context around the cursor.
set lazyredraw            " The screen won't be redrawn unless actions took place.
set scrolljump=0          " Jump only one line on scroll.
set showcmd               " Displays the selection size and the partion commands.
set ttyfast               " Improves redrawing for newer computers.
set nostartofline         " When moving thru the lines, the cursor will try to stay in the previous columns.
set autoread

" Set rulers
highlight ColorColumn guifg=White guibg=#592929 ctermbg=red ctermfg=white
set colorcolumn=80,100

if has('termguicolors')
highlight Pmenu guibg=LightGray guifg=Black
highlight PmenuSel guibg=Black guifg=LightGray
else
highlight Pmenu ctermbg=LightGray ctermfg=Black
highlight PmenuSel ctermbg=Black ctermfg=LightGray
endif

" {{{ Show invisible characters
nnoremap <leader>v :setlocal list!<cr>
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" set list
" }}}

" }}}

" {{{ Backup settings
" Disable backup files, you are using a version control system anyway :)
set nobackup
set nowritebackup
set noswapfile
" }}}

" {{{ Indention management
set tabstop=4          " How many spaces takes a tab character.
set softtabstop=4      " The number of spaces a tab character counts for.
set expandtab          " Use spaces instead of tabs for indenting.
set shiftwidth=4       " Autoindent width.
set smarttab           " A tab executes automatic indentation in insert mode.
set smartindent        " Adds automatic indentation on new line.
set autoindent         " Adds automatic indentation on copy paste as well.

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" }}}

" {{{ Search Options
set wrapscan
set incsearch          " Incremental search.
set nohlsearch
set magic              " Set magic on, for regular expressions.
set ignorecase         " Searches are Non Case-sensitive.
set smartcase          " Overrides ignorecase, if search contains uppercase character.
set infercase
" }}}

" {{{ Buffer management
set hidden             " Enables hidden buffers. You don't have to close a buffer if you changes buffer.
set splitbelow
set splitright
" }}}

" {{{ Fold stuff, F9 will toggle folds
set foldcolumn=4                " (fdc) width of fold column (to see where folds are)
set foldmethod=indent           " (fdm) creates a fold for every level of indentation
set foldlevel=99                " (fdl) when file is opened, don't close any folds
set foldenable

inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

hi Folded ctermfg=195
hi Folded ctermbg=232

autocmd FileType vim setlocal foldmethod=marker
" }}}

" {{{ Keybinds

" {{{ Buffer management
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nnoremap <leader>T :enew<cr>
" Move to the next buffer
nnoremap <leader>' :bnext<CR>
" Move to the previous buffer
nnoremap <leader>; :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nnoremap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nnoremap <leader>bl :ls<CR>

" Make buffer changes a little quicker
nnoremap <F5> :buffers<CR>:buffer<Space>
" }}}

" {{{ Keybinds to move lines up or down
nnoremap <C-S-Down> :m .+1<CR>==
nnoremap <C-S-Up> :m .-2<CR>==
inoremap <C-S-Down> <Esc>:m .+1<CR>==gi
inoremap <C-S-Up> <Esc>:m .-2<CR>==gi
vnoremap <C-S-Down> :m '>+1<CR>gv=gv
vnoremap <C-S-Up> :m '<-2<CR>gv=gv

nnoremap <C-Down> <C-d>
nnoremap <C-Up> <C-u>
" }}}

" {{{ Search Options
nnoremap <leader>h :noh<cr>
" }}}

" {{{ Misc maps
if has("nvim")
nnoremap <leader>l :source ~/.config/nvim/init.vim<cr>
else
nnoremap <leader>l :source ~/.vimrc<cr>
endif

nnoremap ; :
nnoremap ;; ;
vnoremap ; :
vnoremap ;; ;

command! Wq wq
command! Q q
nnoremap <leader>q :q<cr>
nnoremap <leader>Q :q!<cr>

inoremap <leader><Space> <C-o>/<++><cr><C-o>d4l
nnoremap <leader><Space> /<++><cr>d4li

inoremap jk <Esc>
" }}}

" {{{ Window navigation
if has('nvim')
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
endif
inoremap <C-h> <C-o><C-w>h
inoremap <C-j> <C-o><C-w>j
inoremap <C-k> <C-o><C-w>k
inoremap <C-l> <C-o><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>t :call TabToggle()<cr>
function! TabToggle()
  if tabpagewinnr(tabpagenr(), '$') > 1
    " Zoom in when this tab has more than one window
    tab split
  elseif tabpagenr('$') > 1
    " Zoom out when this tab is not the last tab
    if tabpagenr() < tabpagenr('$')
      tabclose
      tabprevious
    else
      tabclose
    endif
  endif
endfunction
" }}}

" {{{ Create/delete blank lines
nnoremap <C-o> O<Esc>j
nnoremap <C-p> o<Esc>k
nnoremap <leader>o jddk
nnoremap <leader>P kdd
" }}}

" {{{ Make Ctrl-S a thing to save
nnoremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>
" }}}

" {{{ BetterWhitespace
nnoremap <leader>sw :StripWhitespace<cr>
" }}}

" {{{ CtrlP
" Easy bindings for its various modes
nnoremap <leader>bb :CtrlPBuffer<cr>
nnoremap <leader>bm :CtrlPMixed<cr>
nnoremap <leader>bs :CtrlPMRU<cr>
" }}}

" {{{ Titlecase
nnoremap <leader>gt <Plug>Titlecase
vnoremap <leader>gt <Plug>Titlecase
nnoremap <leader>gT <Plug>TitlecaseLine
" }}}

" {{{ NERDTree
nnoremap <silent> <F2> :NERDTreeToggle<CR>
" }}}

" }}}

" {{{ Determine correct project root directory
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
" }}}

" {{{ Open NERDTree and Startify if no file was opened
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | call RunOnEnter() | endif

function! RunOnEnter()
    Startify
    NERDTreeToggle
endfunction
" }}}

" {{{ Go settings
autocmd BufWritePost *.go silent !goreturns -w %
autocmd Filetype go setlocal noexpandtab
" }}}

" {{{ Transparent editing of gpg encrypted files.
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
" }}}

" {{{ Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
" }}}

set background = "dark"
set secure
