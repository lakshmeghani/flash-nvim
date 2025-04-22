local pickers = require 'telescope.pickers'       -- pickers is the utility that hepls us display the ripgrep results in telescope
local finders = require 'telescope.finders'       -- finders is the utility that helps us define sync or async tasks using telescope ran under bash
local make_entry = require 'telescope.make_entry' -- make-entry bridges the gap between the bash optput and telescope output
local conf = require 'telescope.config'
    .values                                       -- conf contains all the default configuration telescope needs to run (we are making a new one so we pass the defaults)

local M = {}                                      -- defining a versitile returning object

local live_multigrep = function(opts)
  opts = opts or {}                   -- if options passed otherwise {}
  opts.cwd = opts.cwd or vim.uv.cwd() -- if path of searching passed then opts.cwd or taking current buffers path

  local finder = finders.new_async_job {

    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end                                    -- this is if-block end

      local pieces = vim.split(prompt, "  ") -- using the "  " double space for extra parameters to be passed to ripgrep
      local args = { "rg" }                  -- this is the 1st arguement, to execute ripgrep

      if pieces[1] then                      -- the finding string or pattern (e.g. function or init.lua file etc)
        table.insert(args, "-e")             -- explicity telling ripgrep to use the regex pattern for finding
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g") -- telling to find only in extensions of pieces[2] files like .js or .ts or .tsx
        table.insert(args, pieces[2])
      end

      ---@diagnostic disable-next-line: deprecated
      return vim.tbl_flatten {
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden" },
        -- this table and the args table will be flattened and merged into one ripgrep command
        -- this table contains a good terminal output which can be directly and easily absorbed by telescope using the make_entry bridge
        -- some include line numbers, file names and smart case make searching case-insensitive
      }
    end, -- end of command_generator function (this is the first key-value pair of finder(async job))

    -- using the entry_maker (2nd key-value pair)
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd, -- already defined opts eariles so making sure that opts has the cwd key-value, we add it explicitly
  }                 -- finder ends here (ui will be in the main live_grep function and not async)

  -- using pickers to define the UI (as part of the live_multigrep function)
  pickers.new(opts, {
    debounce = 100,                                                   -- async timer
    prompt_title = "Multi Grep",                                      -- ui floating window title
    finder = finder,                                                  -- what job to do and how (async as described)
    previewer = conf.grep_previewer(opts),                            -- adding the file preview functionality pre-built in telescope
    sorter = require('telescope.sorters').get_generic_fuzzy_sorter(), -- using a fuzzy sorter on ripgrep's output
  }):find()                                                           -- :find() is just applies all the ui stuff and launches or opens the floating window with telescope
end                                                                   -- live_mumltigrep fucntion ends

-- setting keymap to launch the live_multigrep function
M.setup = function()
  vim.keymap.set("n", "<space>mg", live_multigrep)
end

return M
