---@type GxHandler
local M = {
  -- every filetype and filename
  name = "go",
  filetype = { "go" },
  filename = nil,
}

function M.handle()
  local node = vim.treesitter.get_node()
  if not node then
    return
  end
  if node:type() ~= "import_spec" then
    if node:type() == "import_declaration" then
      node = node:named_child(0)
    else
      node = node:parent()
    end
    if node:type() ~= "import_spec" then
      return
    end
  end

  local path_node = node:field("path")[1]
  local start_line, start_col, end_line, end_col = path_node:range()

  local line = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)[1]
  local pkg = line:sub(start_col + 2, end_col - 1) -- remove quotes

  return "https://pkg.go.dev/" .. pkg
end

return M
