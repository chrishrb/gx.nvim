local helper = require("gx.helper")
local brewfile_handler = require("gx.handlers.brewfile")
local package_json_handler = require("gx.handlers.package_json")
local plugin_handler = require("gx.handlers.plugin")
local url_handler = require("gx.handlers.url")
local github_handler = require("gx.handlers.github")
local commit_handler = require("gx.handlers.commit")
local markdown_handler = require("gx.handlers.markdown")
local search_handler = require("gx.handlers.search")

local M = {}

local function add_handler(handlers, handler, active)
  if
    not active
    or not helper.check_filetype(handler.filetype)
    or not helper.check_filename(handler.filename)
  then
    return
  end
  table.insert(handlers, handler)
end

-- handler function
function M.get_url(mode, line, activated_handlers, handler_options)
  local url
  local handlers = {}
  local tkeys = {}

  -- ### add here new handlers
  add_handler(handlers, brewfile_handler, activated_handlers.brewfile)
  add_handler(handlers, package_json_handler, activated_handlers.package_json)
  add_handler(handlers, plugin_handler, activated_handlers.plugin)
  add_handler(handlers, github_handler, activated_handlers.github)
  add_handler(handlers, commit_handler, activated_handlers.github)
  add_handler(handlers, markdown_handler, true)
  add_handler(handlers, url_handler, true)
  add_handler(handlers, search_handler, activated_handlers.search)
  -- ###

  for k in pairs(handlers) do
    table.insert(tkeys, k)
  end
  table.sort(tkeys)

  for _, k in ipairs(tkeys) do
    url = handlers[k].handle(mode, line, handler_options)

    if url then
      break
    end
  end

  return url
end

return M
