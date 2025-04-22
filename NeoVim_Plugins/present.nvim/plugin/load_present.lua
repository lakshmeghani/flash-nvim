vim.api.nvim_create_user_command("StartPresentation", function()
  require("present").start_presentation()
end
, {})

-- setting a autocommand to launch this in a markdown buffer only
local bufnr_md_file = nil
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set('n', '<space>md', function()
      bufnr_md_file = vim.api.nvim_get_current_buf()
      require("present").start_presentation { bufnr = bufnr_md_file }
    end, { buffer = bufnr_md_file })
  end
})
