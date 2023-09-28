local helper = require("gx.helper")

local M = {
  -- every filetype and filename
  filetype = { "markdown" },
  filename = nil,
}

-- navigate to neovim github plugin url
function M.handle(mode, line, _)
  local pattern = "%[.*%]%((https?://[a-zA-Z0-9_/%-%.~@\\+#=?&]+)%)"

  return helper.find(line, mode, pattern)
end

return M
