-- print("advent of neovim")
-- print("advent of neovim 2")

-- configuring the package manager for loading all plugins
require("config.lazy")

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- highlighting yanked text in normal mode!
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when (yanking) copying text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  -- it creates a group called `kickstart-highlight-yank`
  -- this group has a parameter `clear = true`
  -- this means that whevever commands under this group have this clear=true card,
  -- they will not event-stack on congif-reloading otherwise the text might highlight 2 or 3 times if the config reloaded that many times
  -- it is a safe way when we want to execute the code without exiting the application and also not break exisiting code
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- setting neovim options
-- vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.number = true

-- enabling clipboard access
vim.opt.clipboard = "unnamedplus"

-- enabling the dialog box to decode this
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- requireing the live_multigrep plugin hand-written
require('config.telescope.multigrep').setup()

-- all tab shortcuts...
vim.keymap.set("n", "<space>nt", "<cmd>vnew<CR><C-W>T<cmd>Oil .<CR>")
vim.keymap.set("n", "<space>nT", "<cmd>vnew<CR><C-W>T<cmd>terminal<CR>i")

-- static moving between tabs in neovim using numbers from keymappad
for i = 1, 9 do
  vim.keymap.set({ 'n', 't' }, '<A-k' .. i .. '>', function()
    local status, err = pcall(function() -- using this pcall function is like a try-catch block
      -- (if error of tab not existing, we sugar-coat it to not scream)
      -- vim.cmd('tabnext ' .. i)
      require("bufferline").go_to(i, true)
    end)

    if not status then
      print("No tab open at - " .. i)
    end
  end, { desc = 'Go to tab ' .. i })
end

-- tweeking this to work with the bufferline plugin
-- static moving between tabs in neovim using normal number keymaps
for i = 1, 9 do
  vim.keymap.set({ 'n', 't' }, '<A-' .. i .. '>', function()
    local status, err = pcall(function()
      require("bufferline").go_to(i, true)
      -- vim.cmd('tabnext ' .. i)
    end, { noremap = true, silent = true })

    if not status then
      print("No tab open at - " .. i)
    end
  end, { desc = 'Go to tab ' .. i })
end

-- easifying changing modes in terminal mode to normal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

-- adding quickfix navigation keymaps
vim.keymap.set("n", "<A-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<A-k>", "<cmd>cprev<CR>")

-- configuring Neovim terminal
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('TermUIOpen', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- -- -- -- -- Creating a keybind to swap a boolean value of the line in normal mode
vim.keymap.set("n", "<C-b>", function()
  -- getting the start and end line numbers of the selected lines
  local line_num = vim.fn.line(".")

  vim.cmd(string.format("%ds/\\<true\\>/TEMPORARY/e", line_num))
  vim.cmd(string.format("%ds/\\<false\\>/true/e", line_num))
  vim.cmd(string.format("%ds/\\<TEMPORARY\\>/false/e", line_num))
  -- Notes: 1. We use regex matching so that it only swaps " true " as a word and not true_condition or istrue to *false*
  -- 2. we use TEMPORARY\\ to avoid an infinite loop like true -> false -> true -> false endless.....
  -- 3. You will have to use visual mode as visual line mode doesnt give line number properly
end)

-- setting a keymap for opening buffers using telescope
vim.keymap.set("n", "<space>fb", "<cmd>Telescope buffers<CR>")

-- requiring personal indentation parameters
require("indent")

-- mapping for deleting a buffer
vim.keymap.set("n", "bd", "<cmd>bd!<CR>", { noremap = true, silent = true })
