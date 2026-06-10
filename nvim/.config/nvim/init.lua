-- leader key
-- remap leader key (must be set before lazy.nvim loads)
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- package manager
require("config.lazy")

-----------------------------------------------------------
-- tabbing, indent
-----------------------------------------------------------

vim.opt.tabstop = 4
-- tab == 4 spaces in visual mode

vim.opt.shiftwidth = 4
-- number of spaces for each step of (auto)indent
-- e.g. with cindent, <<, >>

vim.opt.expandtab = true
-- spaces are used instead of tabs

vim.opt.smarttab = true
-- when tabbing, inserts blank spaces according to tabstop

vim.opt.shiftround = true
-- when indenting rounds the indent to a multiple of shiftwidth

-- vim.opt.colorcolumn = "72"
-- set a visible guide column for line length

-- vim.api.nvim_set_hl(0, "CursorLine", { cterm = { NONE = true }, ctermbg = "brown", ctermfg = "lightgray", bg = "brown", fg = "white" })


-----------------------------------------------------------
-- general
-----------------------------------------------------------

vim.cmd("syntax on")
-- enable generally syntax/lexical highlighting

vim.opt.ruler = true
-- enables cursorposition in status line which is composed of:
-- line, column and virtual column number and relative pos in %

vim.opt.encoding = "utf-8"
-- i like unicode.

vim.opt.number = true
vim.opt.relativenumber = true
-- enables relative line number on left side

vim.opt.showcmd = true
-- shows entered vim commands below status line

vim.opt.mouse = "a"
-- yippi! i can click on stuff again. formerly done with mousemode

vim.opt.hidden = true
-- allow switching buffers without saving

vim.opt.autoread = true
-- auto-reload files changed outside vim

vim.opt.clipboard = "unnamed"
-- use system clipboard by default

vim.opt.scrolloff = 5
-- when scrolling x lines are visible

vim.opt.cursorline = true
-- show a line in the line where the cursor is

vim.opt.lazyredraw = true
-- do not redraw while executing macros, generally faster

vim.opt.magic = true
-- regular expression as one is used (some chars have different meanings)

vim.opt.showmatch = true
-- show matching brackets when cursor is on them ()

vim.opt.foldcolumn = "0"
-- making sure there is no margin on left side

vim.opt.laststatus = 2
-- always show status line

vim.opt.history = 10000
-- command history size

vim.opt.backup = false
vim.opt.writebackup = false
-- do not keep backup files around

vim.opt.updatetime = 300
-- faster completion and diagnostic refresh

vim.opt.signcolumn = "yes"
-- always show the signcolumn, prevents text shifting

-- vim.opt.background = "dark"
-- just in case something is wrong with the theme, not needed usually

-- highlight trailing space
vim.api.nvim_set_hl(0, "ExtraWhitespace", { ctermbg = "red", bg = "red" })
vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
  pattern = "*",
  command = "match ExtraWhitespace /\\s\\+$/",
})
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  command = "match ExtraWhitespace /\\s\\+\\%#\\@<!$/",
})

-----------------------------------------------------------
-- session management
-----------------------------------------------------------

vim.opt.shada = "'20,\"50,:20,/20,%,h,!"
-- '20  - remember marks for 20 previous files
-- \"50 - save 50 lines for each register
-- :20  - remember 20 items in command-line history
-- /20  - remember 20 items in search history
-- %    - remember the buffer list (if vim started without a file arg)
-- h    - disable hlsearch on startup
-- !    - save global variables

vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,winsize,tabpages"
-- Define what to save with :mksession
-- blank - empty windows
-- buffers - all buffers not only ones in a window
-- curdir - the current directory
-- folds - including manually created ones
-- help - the help window
-- winsize - window sizes
-- tabpages - all tab pages

-----------------------------------------------------------
-- popupmenu, search
-----------------------------------------------------------

vim.opt.wildmenu = true
-- wildmenu is for listing possible autocompletion when entering commands

vim.opt.wildignore = "*.o,*~,*.pyc,.git*,.hg*,.svn*"
-- Ignore compiled files and version control dirs

vim.opt.completeopt = "longest,menuone"
-- longest sets popupmenu to choose longest common text of all matches
-- menuone makes the menu popup even when theres only one match

vim.opt.ignorecase = true
-- search also for matches which have different cases

vim.opt.smartcase = true
-- ignore ignorecase option when writing capital letters

vim.opt.infercase = true
-- when match has different case then whats written, autocomplete but keep case

vim.opt.incsearch = true
-- highlighting search while searching, incremental search

vim.opt.hlsearch = true
-- highlight all occurunces of search result

-----------------------------------------------------------
-- misc bindings
-----------------------------------------------------------

vim.opt.backspace = "indent,eol,start"
-- better binding for backspace

vim.opt.whichwrap:append("<,>,h,l")
-- when cursor goes over the line it moves to next one

-- Visual mode pressing * or # searches for the current selection
vim.keymap.set("v", "*", [[y/\V<C-R>"<CR>]], { silent = true })
vim.keymap.set("v", "#", [[y?\V<C-R>"<CR>]], { silent = true })

-- quickly open buffer for scribbling
vim.keymap.set("n", "<leader>q", ":e ~/buffer<cr>")

-- turn off search highlighting
vim.keymap.set("n", "<leader>n", ":silent :nohlsearch<cr>")

-- write w!! to save using sudo
vim.keymap.set("c", "w!!", "w !sudo tee % >/dev/null", { noremap = true })

-- toggle spell checking
vim.keymap.set("n", "<leader>ss", ":setlocal spell!<cr>")

-----------------------------------------------------------
-- programming
-----------------------------------------------------------

vim.keymap.set("n", "<F3>", function()
  vim.cmd("w")
  local ft = vim.bo.filetype
  if ft == "c" then
    vim.cmd("!gcc % -o %<")
    vim.cmd("!./%<")
  elseif ft == "cpp" then
    vim.cmd("!g++ % -o %<")
    vim.cmd("!./%<")
  elseif ft == "java" then
    vim.cmd("!javac %")
    vim.cmd("!java -cp %:p:h %:t:r")
  elseif ft == "sh" then
    vim.cmd("!bash %")
  elseif ft == "python" then
    vim.cmd("!python3 %")
  elseif ft == "html" then
    vim.cmd("!firefox % &")
  elseif ft == "go" then
    vim.cmd("!go build %<")
    vim.cmd("!go run %")
  elseif ft == "mkd" then
    vim.cmd("!~/.vim/markdown.pl % > %.html &")
    vim.cmd("!firefox %.html &")
  elseif ft == "tex" then
    vim.cmd("VimtexCompile")
  end
end)

vim.opt.runtimepath:append("~/.vim/manually_installed_plugins/vim-ipxe")
vim.cmd("source ~/.vim/manually_installed_plugins/vim-ipxe/scripts.vim")
