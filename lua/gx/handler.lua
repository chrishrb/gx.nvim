local helper = require("gx.helper")
local brewfile_handler = require("gx.handlers.brewfile")
local package_json_handler = require("gx.handlers.package_json")
local plugin_handler = require("gx.handlers.plugin")
local url_handler = require("gx.handlers.url")
local github_handler = require("gx.handlers.github")
local go_handler = require("gx.handlers.go")
local commit_handler = require("gx.handlers.commit")
local markdown_handler = require("gx.handlers.markdown")
local cve_handler = require("gx.handlers.cve")
local search_handler = require("gx.handlers.search")

local M = {}

---@param handlers table<string, boolean|GxHandler>
---@param handler boolean|GxHandler
---@param active boolean
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

---@param handlers table<string, boolean|GxHandler>
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
  add_handler(resolved, go_handler, handlers.go and exists.go == nil)
  add_handler(resolved, markdown_handler, handlers.markdown and exists.markdown == nil)
  add_handler(resolved, cve_handler, handlers.cve and exists.cve == nil)
  add_handler(resolved, url_handler, handlers.url and exists.url == nil)
  add_handler(resolved, search_handler, handlers.search and exists.search == nil)
  -- ###

  return resolved
end

-- handler function
---@param mode string
---@param line string
---@param configured_handlers table<string, boolean|GxHandler>
---@param handler_options GxHandlerOptions
---@return GxSelection[]
function M.get_url(mode, line, configured_handlers, handler_options)
  local detected_urls_set = {}
  local detected_urls = {}
  local handlers = resolve_handlers(configured_handlers)

  for _, handler in ipairs(handlers) do
    local url = handler.handle(mode, line, handler_options)

    -- only use search handler if no other pattern matches or word is selected in visual mode
    if
      url
      and (
        handler.name ~= "search"
        or #detected_urls == 0
        or mode ~= "n"
        or handler_options.select_for_search == true
      )
    then
      if detected_urls_set[url] == nil then
        detected_urls[#detected_urls + 1] = { ["name"] = handler.name, ["url"] = url }
        detected_urls_set[url] = true
      end
    end
  end

  return detected_urls
end

return M
