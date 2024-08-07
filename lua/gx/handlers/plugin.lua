local helper = require("gx.helper")

---@type GxHandler
local M = {
  -- every filename but only lua
  name = "nvim-plugin",
  filetype = { "lua", "vim" },
  filename = nil,
}

-- navigate to neovim github plugin url
function M.handle(mode, line, _)
  local pattern = "[\"']([^%s~/]*/[^%s~/]*)[\"']"
  local username_repo = helper.find(line, mode, pattern)
  if username_repo then
    return "https://github.com/" .. username_repo
  end
end

return M
