local plugin_handler = require("gx.handlers.plugin")
local url_handler = require("gx.handlers.url")

local M = {}

function M.getUrl(mode, line)
  local url
  local filetype = vim.bo.filetype
  local handlers = {}
  local tkeys = {}

  table.insert(handlers, plugin_handler.priority, plugin_handler)
  table.insert(handlers, url_handler.priority, url_handler)

  for k in pairs(handlers) do
    table.insert(tkeys, k)
  end
  table.sort(tkeys)

  for _, k in ipairs(tkeys) do
    if not handlers[k].filetype or handlers[k].filetype == filetype then
      url = handlers[k].handle(mode, line)
    end

    if url then
      break
    end
  end

  return url
end

return M
