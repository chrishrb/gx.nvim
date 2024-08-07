local helper = require("gx.helper")

local sysname = vim.loop.os_uname().sysname

local M = {}

---@class GxHandlerOptions
---@field search_engine string
---@field select_for_search boolean
---@field git_remotes string[]
---@field git_remote_push boolean

---@class GxHandler
---@field name string
---@field filetype string[]?
---@field filename string?
---@field handle fun(mode: string, line: string, handler_options: GxHandlerOptions): string?

---@class GxOptions
---@field open_browser_app string
---@field open_browser_args string[]
---@field handlers table<string, boolean|GxHandler>
---@field handler_options GxHandlerOptions

---@class GxSelection
---@field name string?
---@field url string

-- search for url with handler
function M.open(mode, line)
  if not line then
    line = vim.api.nvim_get_current_line()
    mode = vim.api.nvim_get_mode().mode
  end

  -- cut if in visual mode
  line = helper.cut_with_visual_mode(mode, line)

  local urls =
    require("gx.handler").get_url(mode, line, M.options.handlers, M.options.handler_options)

  if #urls == 0 then
    return
  elseif #urls == 1 then
    return require("gx.shell").execute_with_error(
      M.options.open_browser_app,
      M.options.open_browser_args,
      urls[1].url
    )
  else
    vim.ui.select(urls, {
      prompt = "Multiple patterns match. Select:",
      format_item = function(item)
        return item.url .. " (" .. item.name .. ")"
      end,
    }, function(selected)
      if not selected then
        return
      end

      return require("gx.shell").execute_with_error(
        M.options.open_browser_app,
        M.options.open_browser_args,
        selected.url
      )
    end)
  end
end

-- get the app for opening the webbrowser
local function get_open_browser_app()
  local app
  if sysname == "Darwin" then
    app = "open"
  elseif sysname == "Linux" then
    app = "xdg-open"
  elseif sysname == "Windows_NT" then
    app = "powershell.exe"
  end
  return app
end

-- get the args for opening the webbrowser
local function get_open_browser_args()
  local args = {}
  if sysname == "Windows_NT" then
    args = { "start", "explorer.exe" }
  end
  return args
end

---@param options GxOptions
local function with_defaults(options)
  options = options or {}
  options.handler_options = options.handler_options or {}

  return {
    open_browser_app = options.open_browser_app or get_open_browser_app(),
    open_browser_args = options.open_browser_args or get_open_browser_args(),
    handlers = options.handlers or {},
    handler_options = {
      search_engine = options.handler_options.search_engine or "google",
      select_for_search = options.handler_options.select_for_search or false,
      git_remotes = options.handler_options.git_remotes or { "upstream", "origin" },
      git_remote_push = options.handler_options.git_remote_push or false,
    },
  }
end

local function bind_command()
  vim.api.nvim_create_user_command("Browse", function(opts)
    local fargs = opts.fargs[1]
    if fargs then
      M.open("c", fargs)
      return
    end

    if opts.range == 2 then
      local range = vim.fn.getline(opts.line1)
      M.open("v", range)
      return
    end

    M.open()
  end, { nargs = "?", range = 1 })
end

---@param options GxOptions
function M.setup(options)
  M.options = with_defaults(options)
  bind_command()
end

---@type GxOptions
M.options = nil

return M
