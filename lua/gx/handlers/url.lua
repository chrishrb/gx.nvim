local helper = require("gx.helper")

local M = {
  -- every filetype
  filetype = nil,
  filename = nil,
}

-- get url from line (with http/s)
function M.handle(mode, line, _)
  local pattern = "(https?://[a-zA-Z%d_/%%%-%.~@\\+#=?&:]+)"
  local url = helper.find(line, mode, pattern)

  -- match url without http(s)
  if not url then
    pattern = "([a-zA-Z%d_/%-%.~@\\+#]+%.[a-zA-Z%d_/%%%-%.~@\\+#=?&:]+)"
    url = helper.find(line, mode, pattern)
    if url then
      return "https://" .. url
    end
  end

  return url
end

return M
