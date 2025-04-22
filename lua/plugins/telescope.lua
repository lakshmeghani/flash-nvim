-- plugins/telescope.lua:
return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
      },
    },
    config = function()
      require('telescope').setup {
        -- Adding fzf in extensions
        extensions = {
          fzf = {}
        },
      } -- end of telescope setup
      -- Loading telescope fzf extension
      require('telescope').load_extension("fzf")

      vim.keymap.set("n", "<space>fd", require("telescope.builtin").find_files)
      vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags)
      vim.keymap.set("n", "<space>fn", function()
        require("telescope.builtin").find_files {
          cwd = vim.fn.stdpath('config')
        }
      end) -- end of keymap
      vim.keymap.set("n", "<space>fp", function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end) -- end of keymap
    end
  }
}
