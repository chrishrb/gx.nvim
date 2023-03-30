local helper = require("gx.helper")
local package_json_handler = require("gx.handlers.package_json")
local plugin_handler = require("gx.handlers.plugin")
local url_handler = require("gx.handlers.url")
local github_handler = require("gx.handlers.github")

local M = {}

local function add_handler(handlers, handler, active)
  if not active or not helper.check_filetype(handler.filetype) or not helper.check_filename(handler.filename) then
    return
  end
  table.insert(handlers, handler)
end

-- handler function
function M.get_url(mode, line, activated_handlers)
  local url
  local handlers = {}
  local tkeys = {}

  -- ### add here new handlers
  add_handler(handlers, package_json_handler, activated_handlers.package_json)
  add_handler(handlers, plugin_handler, activated_handlers.plugin)
  add_handler(handlers, github_handler, activated_handlers.github)
  add_handler(handlers, url_handler, true)
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
