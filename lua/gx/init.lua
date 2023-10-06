local helper = require("gx.helper")

local keymap = vim.keymap.set
local sysname = vim.loop.os_uname().sysname

local M = {}

-- search for url with handler
local function search_for_url()
  local line = vim.api.nvim_get_current_line()
  local mode = vim.api.nvim_get_mode().mode

  -- cut if in visual mode
  line = helper.cut_with_visual_mode(mode, line)

  -- search for url
  local url =
    require("gx.handler").get_url(mode, line, M.options.handlers, M.options.handler_options)

  if not url then
    return
  end

  return M.browse(url)
end

function M.browse(url)
  return require("gx.shell").execute_with_error(
    M.options.open_browser_app,
    M.options.open_browser_args,
    url
  )
end

-- create keybindings
local function bind_keys()
  vim.g.netrw_nogx = 1 -- disable netrw gx

  local opts = { noremap = true, silent = true }
  keymap({ "n", "x" }, "gx", search_for_url, opts)
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
local function get_open_browser_args(args)
  if sysname == "Windows_NT" then
    local win_args = { "start", "explorer.exe" }
    return helper.concat_tables(win_args, args)
  end
  return args
end

local function with_defaults(options)
  options = options or {}
  options.handlers = options.handlers or {}
  options.handler_options = options.handler_options or {}

  return {
    open_browser_app = options.open_browser_app or get_open_browser_app(),
    open_browser_args = get_open_browser_args(options.open_browser_args or {}),
    handlers = {
      brewfile = helper.ternary(options.handlers.brewfile ~= nil, options.handlers.brewfile, true),
      plugin = helper.ternary(options.handlers.plugin ~= nil, options.handlers.plugin, true),
      github = helper.ternary(options.handlers.github ~= nil, options.handlers.github, true),
      package_json = helper.ternary(
        options.handlers.package_json ~= nil,
        options.handlers.package_json,
        true
      ),
      search = helper.ternary(options.handlers.search ~= nil, options.handlers.search, true),
    },
    handler_options = {
      search_engine = options.handler_options.search_engine or "google",
    },
  }
end

-- setup function
function M.setup(options)
  M.options = with_defaults(options)
  bind_keys()
  vim.api.nvim_create_user_command("Browse", function(opts)
    M.browse(opts.fargs[1])
  end, { nargs = 1 })
end

M.options = nil

return M
