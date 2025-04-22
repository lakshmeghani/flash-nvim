-- setting keymaps
vim.keymap.set({ "n", "t" }, "<space><Tab>", "<cmd>Floaterminal<CR>")

-- definind the state of the terminal
local state = {
  floating = {
    buf = -1,
    win = -1
  }
}

function OpenFloatingTerminal(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    -- Create a new buffer (not listed)
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded'
  })

  return { win = win, buf = buf }
  -- we return the win and buf so that we can add it as a state variable to hold the state of the terminal
  -- therefore, this terminal can also be accessed as a background task executor
end

-- adding a command to make this terminal toggable
vim.api.nvim_create_user_command("Floaterminal", function()
  -- checking for a valid window there or not:
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = OpenFloatingTerminal({ buf = state.floating.buf })
    -- setting the state and opeing a new floating terminal
  else
    vim.api.nvim_win_hide(state.floating.win) -- this doesnt tell to reuse the buffer
  end
  -- now setting the type of the buffer to be a terminal only the first time
  -- otherwise, assigning it again and again will erase the buffer
  if vim.bo[state.floating.buf].buftype ~= "terminal" then
    vim.cmd.term()
    vim.cmd("startinsert")
  else
    vim.cmd("startinsert")
  end
end, {})

--returning lazy and empty table
return {}
