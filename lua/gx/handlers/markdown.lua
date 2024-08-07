local helper = require("gx.helper")

---@type GxHandler
local M = {
  -- every filetype and filename
  name = "markdown",
  filetype = { "markdown" },
  filename = nil,
}

-- navigate to neovim github plugin url
function M.handle(mode, line, _)
  local pattern = "%[[%a%d%s.,?!:;@_{}~]*%]%((https?://[a-zA-Z0-9_/%-%.~@\\+#=?&]+)%)"

  return helper.find(line, mode, pattern)
end

return M
