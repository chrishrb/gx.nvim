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
    active == false
    or not helper.check_filetype(handler.filetype)
    or not helper.check_filename(handler.filename)
  then
    return
  end
  handlers[#handlers + 1] = handler
end

---@param handlers { [string]: (boolean | GxHandler)[] }
---@return GxHandler[]
local function resolve_handlers(handlers)
  local resolved = {}
  local exists = {}

  for name, config in pairs(handlers) do
    if type(config) == "table" then
      add_handler(resolved, config, true)
      exists[name] = true
    end
  end

  -- ### add here new handlers
  add_handler(resolved, brewfile_handler, handlers.brewfile and exists.brewfile == nil)
  add_handler(resolved, package_json_handler, handlers.package_json and exists.package_json == nil)
  add_handler(resolved, plugin_handler, handlers.plugin and exists.plugin == nil)
  add_handler(resolved, github_handler, handlers.github and exists.github == nil)
  add_handler(resolved, commit_handler, handlers.commit and exists.commit == nil)
  add_handler(resolved, markdown_handler, handlers.markdown and exists.markdown == nil)
  add_handler(resolved, url_handler, handlers.url and exists.url == nil)
  add_handler(resolved, search_handler, handlers.search and exists.search == nil)
  -- ###

  return resolved
end

-- handler function
---@param mode string
---@param line string
---@param configured_handlers { [string]: (boolean | GxHandler)[] }
---@return string | nil
function M.get_url(mode, line, configured_handlers, handler_options)
  local handlers = resolve_handlers(configured_handlers)

  for _, handler in ipairs(handlers) do
    local url = handler.handle(mode, line, handler_options)

    if url then
      return url
    end
  end
end

return M
