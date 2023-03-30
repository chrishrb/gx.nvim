local helper = require("gx.helper")

local M = {}

-- every filetype
M.filetype = nil
M.filename = nil

-- get url from line (with http/s)
function M.handle(mode, line)
  local pattern = "(https?://[a-zA-Z0-9_/%-%.~@\\+#=?&]+)"
  local url = helper.find(line, mode, pattern)

  -- match url without http(s)
  if not url then
    pattern = "([a-zA-Z0-9_/%-%.~@\\+#]+%.[a-zA-Z0-9_/%-%.~@\\+#%=?&]+)"
    url = helper.find(line, mode, pattern)
    if url then
      return "https://" .. url
    end
  end

  return url
end

return M
