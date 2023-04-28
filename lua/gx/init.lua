local notfier = require("gx.notfier")
local helper = require("gx.helper")
local handler = require("gx.handler")
local shell = require("gx.shell")

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
  local url = handler.get_url(mode, line, M.options.handlers)

  if not url then
    return
  end

  shell.execute_with_error(M.options.open_browser_app, M.options.open_browser_args, url)
end

-- create keybindings
local function bind_keys()
  vim.g.netrw_nogx = 1 -- disable netrw gx

  local opts = { noremap = true, silent = true }
  keymap("n", "gx", search_for_url, opts)
  keymap("v", "gx", search_for_url, opts)
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

  return {
    open_browser_app = options.open_browser_app or get_open_browser_app(),
    open_browser_args = get_open_browser_args(options.open_browser_args or {}),
    handlers = {
      plugin = helper.ternary(options.handlers.plugin ~= nil, options.handlers.plugin, true),
      github = helper.ternary(options.handlers.github ~= nil, options.handlers.github, true),
      package_json = helper.ternary(
        options.handlers.package_json ~= nil,
        options.handlers.package_json,
        true
      ),
    },
  }
end

-- setup function
function M.setup(options)
  M.options = with_defaults(options)
  bind_keys()
end

M.options = nil

return M
