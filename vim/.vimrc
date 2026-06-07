" my custom bindings:
" , <leader>
" F2 - surround in hashtag block
" F3 - compile and run (e.g. java, c, go)
" F4 - nerdtree file explorer
" F5 - next tab
" F6 - prev tab
" F7 - new tab
" F8 - close tab
" * and # in visual mode search for current selection
" <leader> y is able to copy between vim instances
" Star is Select (PRIMARY)
" Control Plus C (Clipboard)
" <leader> ss toggle spell checking
" <leader> q quickly open buffer in ~/buffer for scribbling
" <leader> n turn off search highlighting

"###########################################################
"#### tabbing, indent ######################################
"###########################################################

set tabstop=4
" tab == 4 spaces in visual mode

set shiftwidth=4
" number of spaces for each step of (auto)indent
" e.g. with cindent, <<, >>

set expandtab
" spaces are used instead of tabs

set smarttab
" when tabbing, inserts blank spaces according to tabstop

set shiftround
" when indenting rounds the indent to a multiple of shiftwidth

"set colorcolumn=72
" set a visible guide column for line length

"hi CursorLine   cterm=NONE ctermbg=brown ctermfg=lightgray guibg=brown guifg=white


"#########################################################
"########	general ########################################
"#########################################################

syntax on
" enable generally syntax/lexical highlighting

set ruler
" enables cursorposition in status line which is composed of:
" line, column and virtual column number and relative pos in %

set encoding=utf-8
" i like unicode.

set number relativenumber
" enables relative line number on left side

set showcmd
" shows entered vim commands below status line

set mouse=a
" yippi! i can click on stuff again. formerly done with mousemode

set hidden
" allow switching buffers without saving

set autoread
" auto-reload files changed outside vim

set clipboard=unnamed
" use system clipboard by default

set scrolloff=5
" when scrolling x lines are visible

set cursorline
" show a line in the line where the cursor is

set lazyredraw
" do not redraw while executing macros, generally faster

set magic
" regular expression as one is used (some chars have different meanings)

set showmatch
" show matching brachets when cursor is on them ()

set foldcolumn=0
" making sure there is no margin on left side

set laststatus=2
" always show status line

set history=10000
" command history size

set nobackup
set nowritebackup
" do not keep backup files around

set updatetime=300
" faster completion and diagnostic refresh

set signcolumn=yes
" always show the signcolumn, prevents text shifting

"set background=dark
" just in case something is wrong with the theme, not needed usually

highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
" highlight trailing space

"#####################################################################
"######### session management ########################################
"#####################################################################

set viminfo='20,\"50,:20,/20,%,h,!
" '20  - remember marks for 20 previous files
" \"50 - save 50 lines for each register
" :20  - remember 20 items in command-line history
" /20  - remember 20 items in search history
" %    - remember the buffer list (if vim started without a file arg)
" h    - disable hlsearch on startup
" !    - save global variables

set sessionoptions=blank,buffers,curdir,folds,help,winsize,tabpages
" Define what to save with :mksession
" blank - empty windows
" buffers - all buffers not only ones in a window
" curdir - the current directory
" folds - including manually created ones
" help - the help window
" winsize - window sizes
" tabpages - all tab pages

"###########################################################################
"######## popupmenu, search ################################
"###########################################################################
:set wildmenu
" wildmenu is for listing possible autocompletion when entering commands

set wildignore=*.o,*~,*.pyc,.git*,.hg*,.svn*
" Ignore compiled files and version control dirs

set completeopt=longest,menuone
" longest sets popupmenu to choose longest common text of all matches
" menuone makes the menu popup even when theres only one match

set ignorecase
" search also for matches which have different cases

set smartcase
" ignore ignorecase option when writing capital letters

set infercase
" when match has different case then whats written, autocomplete but keep case

set incsearch
" highlighting search while searching, incremental search

set hlsearch
" highlight all occurunces of search result

"###########################################################
"#### misc bindings ########################################
"###########################################################

nnoremap <F2> :center 80<cr>hhv0r#A<space><esc>40A#<esc>d80<bar>YppVr#kk.
" quick comment/hashtag block around text

let mapleader = ","
" remap leader key

set backspace=indent,eol,start
" better binding for backspace

set whichwrap+=<,>,h,l
" when cursor goes over the line it moves to next one

vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>
" Visual mode pressing * or # searches for the current selection

map <F5> :tabnext<cr>
map <F6> :tabprevious<cr>
map <F7> :tabedit <c-r>=expand("%:p:h")<cr>/
map <F8> :tabclose<cr>
" tab management, F7 makes new tab with same working directory

noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p
" allow copy paste between vim instances

map <leader>ss :setlocal spell!<cr>
" toggle spell checking

map <leader>q :e ~/buffer<cr>
" quickly open buffer for scribbling

nmap <silent> <leader>n :silent :nohlsearch<cr>
" turn off search highlighting

cmap w!! w !sudo tee % >/dev/null
" write w!! to save using sudo

nnoremap <leader>w :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>
" open file with default application

"################################################################################
"################################# programming ##################################
"################################################################################
map <F3> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!gcc % -o %<"
        exec "!./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!java -cp %:p:h %:t:r"
    elseif &filetype == 'sh'
        exec "!bash %"
    elseif &filetype == 'python'
        exec "!python3 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
        exec "!go build %<"
        exec "!go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    elseif &filetype == 'tex'
        :VimtexCompile
    endif
endfunc


"########################################################
"######## vim-plug ######################################
"########################################################

call plug#begin('~/.vim/plugged')
" start of vim-plug plugin manager

" latex in vim, quite good
Plug 'lervag/vimtex'

" nice colors
Plug 'projekt0n/github-nvim-theme'
Plug 'rebelot/kanagawa.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'matveyt/vim-modest'

" automatic parantheses brackets etc closing
Plug 'Raimondi/delimitMate'

Plug 'tpope/vim-fugitive'
" awesome git support! adds commands like:
" :GWrite (git add)
" :GCommit (git commit)
" :GPush (git push)
" :Gread (git checkout <file>
" :Gblame (git blame)

Plug 'christoomey/vim-tmux-navigator'
" allows tmux to recognize vim in buffer and use vim bindings for movement
" needs also a snippet or plugin in the tmux.conf

" lexical highlighting for solidity
Plug 'tomlion/vim-solidity'
"compile stuff for solidity
augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost make nested copen
augroup END
let g:syntastic_sol_checkers = ['solc', 'solium']

Plug 'LnL7/vim-nix'
" nix lang support

Plug 'pixelneo/vim-python-docstring'
" vim docstrings

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" conquerer of completion

call plug#end()

"################################################################################
"########################## manually installed plugins ##########################
"################################################################################
set rtp+=~/.vim/manually_installed_plugins/vim-ipxe
source ~/.vim/manually_installed_plugins/vim-ipxe/scripts.vim

"#################################################################
"####################### coc config ##############################
"#################################################################
" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-@> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use CTRL-S for selections ranges
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"###############################################################################
"############################### coc config end ################################
"###############################################################################

" if using a colorscheme from the plugin, this needs to go in the end
colorscheme koehler
