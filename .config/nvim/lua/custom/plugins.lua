return function(use)
  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
  })

  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran', quit_key = ';' }
    end
  }

  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  use {
  "folke/zen-mode.nvim",
  config = function() require("zen-mode").setup {} end
  }

  -- use "mbbill/undotree"
  use "simnalamburt/vim-mundo"

  use { 'catppuccin/nvim', as = 'catppuccin' }
end
