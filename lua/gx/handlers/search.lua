local helper = require("gx.helper")

---@type GxHandler
local M = {
  -- every filetype and filename
  name = "search",
  filetype = nil,
  filename = nil,
}

-- navigate to github url for commit
function M.handle(mode, line, handler_options)
  local search_pattern

  if mode == "v" or mode == "c" then
    search_pattern = line
  else
    search_pattern = vim.fn.expand("<cword>")
  end

  local search_engine_url = helper.get_search_url_from_engine(handler_options.search_engine)
  return search_engine_url .. helper.urlencode(search_pattern)
end

return M
