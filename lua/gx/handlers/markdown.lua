local helper = require("gx.helper")
local git = require("gx.git")

local M = {}

-- every filetype and filename
M.filetype = { "markdown" }
M.filename = nil

-- navigate to neovim github plugin url
function M.handle(mode, line, _)
  local pattern = "%[.*%]%((https?://[a-zA-Z0-9_/%-%.~@\\+#=?&]+)%)"
  local url = helper.find(line, mode, pattern)
  return url
end

return M
