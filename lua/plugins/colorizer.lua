return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
    config = function()
      require("colorizer").setup {
        filetypes = {
          "*",                     -- Highlight all files, but customize some others.
          css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
          html = { names = true }, -- Disable parsing "names" like Blue or Gray
        }
      }
      -- This will create an autocmd for FileType * to highlight every filetype.
    end
  }
}
