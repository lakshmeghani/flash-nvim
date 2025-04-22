return {
  {
    "nvimtools/none-ls.nvim", -- older was null-ls
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier.with({
            extra_args = { "--tab-width", "2", "--use-tabs", "false" } }),
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.completion.spell,
        },
      })
    end,
  },
}
