local notfier = require("gx.notfier")
local helper = require("gx.helper")
local handler = require("gx.handler")
local shell = require("gx.shell")

local keymap = vim.keymap.set
local sysname = vim.loop.os_uname().sysname

local M = {}

-- execute command on macOS and linux
local function execute_command(uri)
  local command, ok = shell.execute({ M.options.open_browser_app, uri })
  if ok ~= 0 then
    notfier.error('Command "' .. command .. '" not successful.')
  end
end

-- search for url with handler
local function search_for_url()
  local line = vim.api.nvim_get_current_line()
  local mode = vim.api.nvim_get_mode().mode
  local filetype = vim.bo.filetype

  -- cut if in visual mode
  line = helper.cut_with_visual_mode(mode, line)

  -- search for url
  local url = handler.get_url(mode, line, filetype, M.options.handlers)

  if not url then
    return
  end

  execute_command(url)
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
  end
  return app
end

local function with_defaults(options)
  options = options or {}
  options.handlers = options.handlers or {}

  return {
    open_browser_app = options.open_browser_app or get_open_browser_app(),
    handlers = {
      plugin = helper.ternary(options.handlers.plugin ~= nil, options.handlers.plugin, true),
    },
  }
end

-- setup function
function M.setup(options)
  if not sysname == "Darwin" or not sysname == "Linux" then
    notfier.error("Windows is not supported at the moment")
    return
  end

  M.options = with_defaults(options)
  bind_keys()
end

M.options = nil

return M
