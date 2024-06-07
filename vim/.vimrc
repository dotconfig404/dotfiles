""###### general TODO for importing this vimrc ###################################
""################################################################################
" 1) install vundle
" 2) configure tmux to work with the tmux-navigation plugin and vom movements (copy config file)
" 3) use terminal emulator with 256 colors, for a good looking statusline

" my custom bindings:
" , <leader>
" F2 - surround in hashtag block
" F3 - compile and run (e.g. java, c, go)
" F4 - nerdtree file explorer
" F5 - next tab
" F6 - prev tab
" F7 - new tab
" F8 - close tab
" F9
" F10
" F11
" F12
" * and # in visual mode search for current selection
" gv inside visual mode searches also for selection but with ack
" <leader> y is able to copy between vim instances
" Star is Select (PRIMARY)
" Control Plus C (Clipboard)
" noremap <Leader>y "*y 
" noremap <Leader>p "*p
" noremap <Leader>Y "+y
" noremap <Leader>P "+p
" <leader> ss toggle spell checking
" <leader> q quickly open buffer in ~/buffer for scribbling
" <leader> n turn off search highlighting
" C-n brings up autocompletion menu, selects first item
" M-, brings up omni-autocompletion menu, selects first item
" <space><space> in insert mode jumps to next <++> in textflow

""###########################################################
""#### tabbing, indent, textflow ############################
""###########################################################

set tabstop=4
" tab == 4 spaces in visual mode

set softtabstop=4
" and in editing mode, or sth like this...

set shiftwidth=4
" number of spaces for each step of (auto)indent
" e.g. with cindent, <<, >>

set expandtab
" spaces are used instead of tabs

set smarttab
" when tabbing, inserts blank spaces according to tabstop

set shiftround
" when indenting rounds the indetn to a multiple of shiftwidth

autocmd FileType html inoremap <Space><Space> <Esc>/<++><Enter>"_c4l
autocmd FileType html inoremap ;i <em></em><Space><++><Esc>FeT>i

" set colorcolumn=72

hi CursorLine   cterm=NONE ctermbg=brown ctermfg=lightgray guibg=brown guifg=white


""#########################################################
""########	general ########################################
""#########################################################

syntax on
" enable generally syntax/lexical highlighting

filetype off
" enable filetype detection for syntax/lexical highlighting
" reads ftplugin.vim and indent.vim from runtime directory
" now it is turned OFF, because it must be loaded AFTER all the plugins.
" last line in this vimrc

set ruler
" enables cursorposition in status line which is composed of:
" line, column and virtual column number and relative pos in %

set encoding=utf-8
" i like unicode.

set number relativenumber
" enables relative line number on left side
"augroup numbertoggle
"  autocmd!
"  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"  autocmd BufLeave,FocusLost,InsertEnter   * set number
"augroup END
"" toggles relativenumber on buffferenter/leaver

set showcmd
" shows entered vim commands below status line

set mouse=a
" yippi! i can click on stuff again. formerly done with mousemode

set nocompatible
" needed to disable vi compability and enable vim features
" and used as a system-wide vimrc. in user vimrc not needed.

"set visualbell
" stop annoying bell sound

set scrolloff=5
" set scrolloff=999
" when scrolling x lines are visible. 999 -> cursors always centered.

set cursorline
" show a line in the line where the cursor is

set lazyredraw
" do not redraw while executing macros, generally faster

set magic
" regular expression as one is used (some chars have different meanings)

set showmatch
" show matching brachets when cursor is on them ()
" deprecated with some plugin? maybe check later

set foldcolumn=0
" making sure there is no margin on left side

set laststatus=2
" always show status line

set history=700
" because why not (command history)

set background=dark
" just in case something is wrong with the theme, not needed usually

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" highlight trailing space

""#####################################################################
""######### session management ########################################
""#####################################################################

set viminfo='20,\"50,:20,/20,%,n~/.viminfo.go'
" Remember things between sessions
" '20  - remember marks for 20 previous files
" \"50 - save 50 lines for each register
" :20  - remember 20 items in command-line history
" /20  - remember 20 items in search history
" %    - remember the buffer list (if vim started without a file arg)
" n    - set name of viminfo file

set sessionoptions=blank,buffers,curdir,folds,help,winsize,tabpages
" Define what to save with :mksession
" blank - empty windows
" buffers - all buffers not only ones in a window
" curdir - the current directory
" folds - including manually created ones
" help - the help window
" options - all options and mapping
" winsize - window sizes
" tabpages - all tab pages

""###########################################################################
""######## popupmenu, autocompletion, search ################################
""###########################################################################
:set wildmenu
" wildmenu is for listing possible autocompletion when entering commands

set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
	set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
	set wildignore+=.git\*,.hg\*,.svn\*
endif
" Ignore compiled files

set completeopt=longest,menuone
" longest sets popupmenu to choose longest common text of all matches
" menuone makes the menu popup even when theres only one match

inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" enter key will select highlighted menu item, like C-Y does

inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" C-N brings up menu, automatically select nearest item in dropdown menu
" this way you can narrow down results and just press enter when you found it

inoremap <expr> <M-c> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" simulates C-X C-O to bring up omni completion menu, then simulates C-N C-P
" to remove longest common text and simulates <Down> to highlight first match

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

"autocmd BufReadPost *
"     \ if line("'\") > 0 && line("'\") <= line("$") |
"     \   exe \"normal! g`\" |
"     \ endif
" Return to last edit position when opening files

""###########################################################
""#### misc bindings ########################################
""###########################################################

nnoremap <F2> :center 80<cr>hhv0r#A<space><esc>40A#<esc>d80<bar>YppVr#kk.
" quick comment/hashtag block around text as seen in this vimrc

let mapleader = ","
" remap leader key

set backspace=indent,eol,start
" better binding for backspace

set whichwrap+=<,>,h,l
" when cursor goes over the line it moves to next one, as many are used

vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>
" Visual mode pressing * or # searches for the current selection
" idea by Michael Naumann

map <F5> :tabnext<cr>
map <F6> :tabprevious<cr>
map <F7> :tabedit <c-r>=expand("%:p:h")<cr>/
map <F8> :tabclose<cr>]
" tab management, F7 makes new tab with same working directory

" vmap <leader>y :w! ~/.vbuf<cr>
" allow copy paster between vim instances
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

map <leader>ss :setlocal spell!<cr>
" toggle spell checking

map <leader>q :e ~/buffer<cr>
" quickly open buffer for scribbling

nmap <silent> <leader>n :silent :nohlsearch<cr>
" turn off search highlighting

cmap w!! w !sudo tee % >/dev/null
" write w!! to save using sudo
"
 nnoremap <leader>w :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>

""################################################################################
""################################# programming ##################################
""################################################################################
map <F3> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!gcc % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java -cp %:p:h %:t:r"
    elseif &filetype == 'sh'
        exec "!time bash %"
    elseif &filetype == 'python'
        exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    elseif &filetype == 'tex'
        :VimtexCompile
    endif
endfunc

""########################################################
""######## vim-plug ######################################
""########################################################

call plug#begin()
" start of vundle plugin manager

" latex in vim, quite good
Plug 'lervag/vimtex'

" nice colors
Plug 'flazz/vim-colorschemes'

Plug 'Shougo/neocomplete'
" keyword completion with a cache in current buffer
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

Plug 'VundleVim/Vundle.vim'
" load actual vundle manager

Plug 'Raimondi/delimitMate'
" automatic parantheses brackets etc closing

Plug 'ctrlpvim/ctrlp.vim'
" fuzzy search! toggle using.... ctrl-p. :-)
" some alternatives worth looking at: unite and fzf

Plug 'scrooloose/nerdtree'
" used for file explorer on side
" toggle using F3:
nmap <F4> :NERDTreeToggle<CR>
let NERDTreeDirArrows=0

" turning nerd tree into a panel
Plug 'jistr/vim-nerdtree-tabs'

" and adding some git functinality
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'itchyny/lightline.vim'
" alternative to airline, much lighter.
" setting theme:
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

""##### git and tmux ########################################
Plug 'tpope/vim-fugitive'
" awesome git support! adds commands like:
" :GWrite (git add)
" :GCommit (git commit)
" :GPush (git push)
" :Gread (git checkout <file>
" :Gblame (git blame)

Plug 'airblade/vim-gitgutter'
" shows which lines have been added, removed or modified
" besides the numbers in git files.

Plug 'christoomey/vim-tmux-navigator'
" allows tmux to recognize vim in buffer and use vim bindings for movement
" needs also a snippet or plugin in the tmux.conf


""#### syntax plugins ########################################
Plug 'vim-syntastic/syntastic'
" actual syntax checker, unlike vims lexical scanning

Plug 'tomlion/vim-solidity'
" lexical highlighting for solidity

Plug 'dmdque/solidity.vim'
augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost make nested copen
augroup END
"compile stuff for solidity
let g:syntastic_sol_checkers = ['solc', 'solium']

""################################################################################
""##################################### java #####################################
""################################################################################
"Plug 'artur-shaik/vim-javacomplete2'
"autocmd FileType java setlocal omnifunc=javacomplete#Complete
" java autompletion for the omni menu
" some recommended bindings:
" To enable smart (trying to guess import option) inserting class imports with
" F4, add:
" nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
" imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
" To enable usual (will ask for import option) inserting class imports with
" F5, add:
" nmap <F5> <Plug>(JavaComplete-Imports-Add)
" imap <F5> <Plug>(JavaComplete-Imports-Add)
" To add all missing imports with F6:
" nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
" imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
" To remove all unused imports with F7:
" nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
" imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
" some plugin unreleated stuff:
"autocmd Filetype java set makeprg=javac\ %
"set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
"map <F9> :make<Return>:copen<Return>
"map <F10> :cprevious<Return>
"map <F11> :cnext<Return>

"""----------
""" Plug 'xolox/vim-easytags' tag management and generation
""" to be used at a later point perhaps, seems interesting.
""" also other plugins of xolox might be of use.
""" use together with: Plug 'majutsushi/tagbar'
"""----------

Plug 'LnL7/vim-nix'
" nix lang support

Plug 'pixelneo/vim-python-docstring'
" vim docstrings

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" conquerer of completion, rn for python

Plug 'Exafunction/codeium.vim'
" copilot alternative 

call plug#end()

"#################################################################
"####################### coc config ##############################
"#################################################################
" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
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
" Example: `<leader>aap` for current paragraph
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
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"###############################################################################
"############################### coc config end ################################
"###############################################################################


" if using a colorscheme from the plugin, this needs to go in the end
colorscheme kalahari

" using single click for opening files etc in nerdtree
let NERDTreeMouseMode=3
colorscheme torte
