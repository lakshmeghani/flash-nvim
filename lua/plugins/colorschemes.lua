return {
  {
    "Mofiqul/vscode.nvim",
    enabled = false, -- vscode plugin not in use
    config = function()
      vim.cmd.colorscheme "vscode"
    end
  }, -- more colorschemes can be added here
  {
    "folke/tokyonight.nvim",
    enabled = false,
    config = function()
      vim.cmd.colorscheme "tokyonight-storm"
    end
  },
  {
    "EdenEast/nightfox.nvim",
    enabled = true,
    config = function()
      vim.cmd.colorscheme "carbonfox"
    end
  },
  {
    "vv9k/vim-github-dark",
    enabled = false,
    config = function()
      vim.cmd.colorscheme "ghdark"
    end
  },
  {
    "ayu-theme/ayu-vim",
    enabled = false,
    config = function()
      vim.cmd.colorscheme "ayu"
    end
  },
}
