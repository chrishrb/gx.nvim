local notfier = require("gx.notfier")
local helper = require("gx.helper")
local parser = require("gx.parser")

local keymap = vim.keymap.set
local sysname = vim.loop.os_uname().sysname
local opts = { noremap = true, silent = true }

if not sysname == "Darwin" or not sysname == "Linux" then
  notfier.error "Windows is not supported at the moment"
  return
end

local M = {}

-- execute command on macOs and linux
local function executeCommand(uri)
  local app

  if sysname == "Darwin" then
    app = "open"
  elseif sysname == "Linux" then
    app = "xdg-open"
  end

  local command = app .. ' "' .. uri .. '"'
  os.execute(command)
end

local function searchForUrl()
  local line = vim.api.nvim_get_current_line()
  local mode = vim.api.nvim_get_mode().mode

  -- cut if in visual mode
  line = helper.cutWithVisualMode(mode, line)

  -- search for url
  local url = parser.getUrl(mode, line)

  if not url then
    return
  end

  executeCommand(url)
end

local function bindKeys()
  vim.g.netrw_nogx = 1 -- disable netrw gx

  keymap("n", "gx", searchForUrl, opts)
  keymap("v", "gx", searchForUrl, opts)
end

function M.setup()
  bindKeys()
end

M.setup()

return M
