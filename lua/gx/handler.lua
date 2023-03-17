local plugin_handler = require("gx.handlers.plugin")
local url_handler = require("gx.handlers.url")
local github_handler = require("gx.handlers.github")

local M = {}

local function is_correct_filetype(handler_filetype, file_filetype)
  if not handler_filetype then
    return true
  end
  if handler_filetype == file_filetype then
    return true
  end
  return false
end

local function add_handler(handlers, handler, file_filetype, active)
  if not active or not is_correct_filetype(handler.filetype, file_filetype) then
    return
  end
  table.insert(handlers, handler)
end

-- handler function
function M.get_url(mode, line, file_filetype, activated_handlers)
  local url
  local handlers = {}
  local tkeys = {}

  -- ### add here new handlers
  add_handler(handlers, plugin_handler, file_filetype, activated_handlers.plugin)
  add_handler(handlers, github_handler, file_filetype, activated_handlers.github)
  add_handler(handlers, url_handler, file_filetype, true)
  -- ###

  for k in pairs(handlers) do
    table.insert(tkeys, k)
  end
  table.sort(tkeys)

  for _, k in ipairs(tkeys) do
    url = handlers[k].handle(mode, line)

    if url then
      break
    end
  end

  return url
end

return M
