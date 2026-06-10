return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps",
      },
    },
  },

  {
    "ggandor/leap.nvim",
    config = function()
      local leap = require("leap")
      leap.create_default_mappings = function() end
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
      vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
    end,
  },

  { "miikanissi/modus-themes.nvim", priority = 1000 },
  "cocopon/iceberg.vim",
  "rebelot/kanagawa.nvim",
  "folke/tokyonight.nvim",
  "matveyt/vim-modest",
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup({})
      vim.cmd('colorscheme github_light')
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({})
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup({})
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
          untracked    = { text = "┆" },
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end,
  },

  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gwrite', 'G Commit', 'GPush', 'Gread', 'Gblame' },
  },

  'christoomey/vim-tmux-navigator',

  'elihunter173/dirbuf.nvim',

  {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      require('config.coc')
    end,
  },

  {
    'lervag/vimtex',
    ft = { 'tex', 'latex' },
  },

  'tomlion/vim-solidity',
  'LnL7/vim-nix',
  'pixelneo/vim-python-docstring',
  'rodjek/vim-puppet',
}
