local helper = require("gx.helper")

local M = {
  -- every filetype and filename
  filetype = nil,
  filename = nil,
}

-- navigate to github url for commit
function M.handle(mode, line, handler_options)
  local search_pattern

  if mode == "v" then
    search_pattern = line
  else
    search_pattern = vim.fn.expand("<cword>")
  end

  local search_engine_url = helper.get_search_url_from_engine(handler_options.search_engine)
  if search_engine_url == nil then
    require("gx.notifier").error("search engine " .. handler_options.search_engine .. " not found!")
    return
  end

  return search_engine_url .. helper.urlencode(search_pattern)
end

return M
