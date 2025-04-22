local M = {}

M.setup = function()
  --nothing
end

-- delaring a parse slides fucntion that takes a table of lines
-- we will parse each markdown file line here in the form of a table of strings (arrray) = {}

local parse_slides = function(lines)
  local all_slides = {}
  -- declaring a table for storing all slides

  -- declaring a new table function that returns a table
  -- so that i do not keep changing the reference
  -- of a statically saved table to a variable
  local new_slide = function(head, body)
    return {
      head = head, -- will be one sinle line
      body = body, -- has to be a table of lines
    }
  end

  -- delaring for the first one
  local current_slide = new_slide(nil, {})
  for _, line in ipairs(lines) do               -- goes through every line
    local separator = "^#"                      -- seperates with a degree 1 markdown heading
    if line:find(separator) then                -- if it is a heading
      if not current_slide.head then            -- checking if a head pre-exists for a current_slide
        current_slide.head = line               -- adding a new heading to a start of a current_slide
      else
        table.insert(all_slides, current_slide) -- saving already existing current_slide
        current_slide = new_slide(nil, {})      -- creating a new current_slide
        current_slide.head = line               -- saving the newly encountered heading
      end
    else
      table.insert(current_slide.body, line) -- adding normal lines as a head body
    end
  end
  table.insert(all_slides, current_slide)
  -- as a slide is added if we encounter a new heading
  -- the last heeading is still stored under current_slide
  -- therefore, adding the lastly_stores current_slide
  -- vim.print(all_slides) --debugging purposes
  -- vim.print(all_slides[1].body)
  return all_slides
end -- parsed slide ends here

local make_floating_window = function(config, focus_window)
  if focus_window == nil then
    focus_window = false
  end
  -- delaring a buf and then opening it as a windows so that we can set window options
  local buf = vim.api.nvim_create_buf(false, true)

  -- declaring the window to lead with a specific config
  local win = vim.api.nvim_open_win(buf, focus_window or false, config)

  -- returning the bufnr and winid for setting the presentation slides
  return { buf = buf, win = win }
end

local load_windows_configuration = function()
  -- setting window-wise configurations
  -- setting globals
  local width = vim.o.columns
  local height = vim.o.lines

  -- defining height logic
  local header_height = 1 + 2                                    -- 1 + border
  local footer_height = 1                                        -- no border
  local body_height = height - header_height - footer_height - 3 -- 2 for border + 1 for extra line after header

  return {
    background = {
      relative = "editor",
      width = width,
      height = height,
      style = "minimal",
      col = 0,
      row = 0,
      zindex = 1,
    },
    header = {
      relative = "editor",
      width = width,
      height = 1,
      style = "minimal",
      border = "rounded",
      col = 0,
      row = 0,
      zindex = 2,
    },
    body = {
      relative = "editor",
      width = width - 8,
      height = body_height,
      border = { " ", " ", " ", " ", " ", " ", " ", " ", },
      style = "minimal",
      row = 4,
      col = 8,
    },
    footer = {
      relative = "editor",
      width = vim.o.columns,
      height = 1,
      style = "minimal",
      -- border = "rounded", -- TODO: top border
      col = 0,
      row = height - 1,
      zindex = 3,
    },
  }
end

-- start the presentation
M.start_presentation = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or 0

  local buffer_lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false) -- of the buffer we choose
  local parsed_lines = parse_slides(buffer_lines)

  local windows = load_windows_configuration()

  -- getting the file name we use this plugin on for the Footer
  local file_name = vim.fn.expand("%:t")

  -- making the background window for indented text
  local background_window = make_floating_window(windows.background)
  -- making the header window
  local title_window = make_floating_window(windows.header)
  vim.bo[title_window.buf].filetype = "markdown"
  -- making the body window
  local body_window = make_floating_window(windows.body, true)
  vim.bo[body_window.buf].filetype = "markdown"
  -- making the footer window
  local footer_window = make_floating_window(windows.footer)

  local current_slide_number = 1 -- by default 1st slide should show
  -- also used for window resizing

  -- making a buffer-line adder function so that we can re-use code
  local buffer_line_setter = function(index) -- note that the index of either body or head or footer for that matter will be the same
    local title = string.rep(" ", (vim.o.columns - #parsed_lines[index].head) / 2) .. parsed_lines[index].head
    vim.api.nvim_buf_set_lines(title_window.buf, 0, -1, false, { title })
    vim.api.nvim_buf_set_lines(body_window.buf, 0, -1, false, parsed_lines[index].body)
    local footer = string.format(
      "  %d | %d  -  %s",
      current_slide_number,
      #parsed_lines,
      file_name
    )
    vim.api.nvim_buf_set_lines(footer_window.buf, 0, -1, false, { footer })
  end

  -- adding keymaps to go to next lines, previous lines and vice-versa

  vim.keymap.set("n", "n", function()
    current_slide_number = math.min(current_slide_number + 1, #parsed_lines)
    buffer_line_setter(current_slide_number)
  end, {
    buffer = body_window.buf
  }) --  going to next slide

  vim.keymap.set("n", "p", function()
    current_slide_number = math.max(current_slide_number - 1, 1)
    buffer_line_setter(current_slide_number)
  end, {
    buffer = body_window.buf
  })

  vim.keymap.set("n", "q", function()
    -- vim.api.nvim_win_close(0, true)
    vim.cmd("bd!")
  end, {
    buffer = body_window.buf
  })

  -- setting a table to globel configuration options so that we can restore them on quitting the buffer
  local restore = {
    cmdheight = {
      original = vim.o.cmdheight,
      present = 0,
    },
    laststatus = {
      original = vim.o.laststatus,
      present = 0
    },
    showtabline = {
      original = vim.opt.showtabline,
      present = 0,
    },
  }

  -- this sets in as a global config for all the existing windows, but the buffer will be the one open!
  for option, config in pairs(restore) do
    vim.opt[option] = config.present
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    -- plan: adding the keymap to only one floating buffer window, cause
    -- if we add to add the floating windows we cannot track which
    -- floating window caused that kyeymap, and if we cannot track,
    -- then we wouldn't know that which windows are left
    -- therefore, we clearup after body buffer's closing is captured
    buffer = body_window.buf,
    callback = function()
      -- resetting the global configs back to the original as they are meant to be for all windows
      for option, config in pairs(restore) do
        vim.opt[option] = config.original
      end

      -- closing all other windows
      vim.api.nvim_win_close(title_window.win, true)
      vim.api.nvim_win_close(background_window.win, true)
      vim.api.nvim_win_close(footer_window.win, true)
    end
  })

  -- setting an autocmd to re-apply the window configurations once Vim is Resized
  vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("present-sized", {}),
    callback = function()
      -- specifying this Resizing options only for the valid body_windows there (avoid all other windows if Resized)
      if not vim.api.nvim_win_is_valid(body_window.win) or body_window.win == nil then
        return
      end

      -- re-setting window configs
      local windowConfigs = load_windows_configuration()
      vim.api.nvim_win_set_config(body_window.win, windowConfigs.body)
      vim.api.nvim_win_set_config(title_window.win, windowConfigs.header)
      vim.api.nvim_win_set_config(background_window.win, windowConfigs.background)
      vim.api.nvim_win_set_config(footer_window.win, windowConfigs.footer)

      -- re-calibrating positioning of content
      buffer_line_setter(current_slide_number)
    end

  })

  buffer_line_setter(1)
end

-- parse_slides({
--   "# lol",
--   "hi",
--   "hi",
--   "# this is awesome",
--   "h!",
--   "lol",
--   "great",
--   "# h4",
--   "hi"
-- })

return M
