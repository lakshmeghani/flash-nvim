return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

      -- After setting up mason-lspconfig you may set up servers via lspconfig
      -- require("lspconfig").rust_analyzer.setup {}
      -- as i have setup blink in lspconfig, it is better to add servers in the lspconfig.lua file only
      -- .
    end
  },
}
