-- this gets overriden by lazy vim. it is also space in lazy vim, but let's have it here explicitly
vim.g.mapleader = "<Space>"

-- package manager
require("config.lazy")

-- copy to system clibboard
vim.api.nvim_set_option("clipboard", "unnamed")

-- theme
--vim.cmd 'colorscheme neomodern'
vim.wo.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2
