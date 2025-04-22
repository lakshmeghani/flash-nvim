return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      -- defining blink.cmp
      local cmp = require('blink-cmp')


      -- telling the lsp that there are certain capabilities that blink can perform on behalf of you
      local capabilities = cmp.get_lsp_capabilities()

      -- adding these capabilities to all attached mason servers
      -- note: mason is installing all servers
      -- mason-lsp-config beridges mason to here (lsp-config)
      -- lsp-config defines capabilities to these installed servers
      -- this is how they talk
      local lspconfig = require('lspconfig')
      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')

      -- setting mason up
      mason.setup()

      -- using mason_lspconfig's callback based approach to setup blink's capabilities to all
      -- installed language servers of mason (therefore we installed mason)
      mason_lspconfig.setup_handlers({
        function(server_name)            -- this is the callback function (server_name is the name of all installed servers)
          lspconfig[server_name].setup({
            capabilities = capabilities, -- sets capabilities and sets up all langauge servers at once
          })
        end
      })

      -- -- -- -- -- setting only lua server differently from mason
      -- setting up the lsp for `lua`
      require('lspconfig').lua_ls.setup {
        -- adding blink.cmp's capabilities for the lua language server
        capabilities = capabilities,

        -- settings for loading a bigger lsp-lua checking file (was exceeding the 500kb limit)
        settings = {
          Lua = {
            workspace = {
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
          },
        },
      }

      --- for all lsp-stuff
      vim.keymap.set("n", "<c-s-i>", function() vim.lsp.buf.format() end)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp', {}),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

          -- Auto-format on save.
          -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
          -- if not client:supports_method('textDocument/willSaveWaitUntil')
          --     and client:supports_method('textDocument/formatting') then
          --   vim.api.nvim_create_autocmd('BufWritePre', {
          --     group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
          --     buffer = args.buf,
          --     callback = function()
          --       vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
          --     end,
          --   })
          -- end

          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("lsp_auto_save_indent", {}),
            callback = function()
              vim.lsp.buf.format({
                async = false, -- Change to true for async formatting
              })
            end,
          })
        end,
      }) -- lsp-attach ends
    end,
  }
}
