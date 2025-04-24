local indent_path = vim.fn.stdpath("config") .. "/lua/indent"
for _, file in ipairs(vim.fn.readdir(indent_path)) do
  if file:match("%.lua$") and file ~= "init.lua" then
    require("indent." .. file:gsub("%.lua$", ""))
  end
end