local helper = require("gx.helper")

---@type GxHandler
local M = {
  -- every filetype
  name = "url",
  filetype = nil,
  filename = nil,
}

-- get url from line (with http/s)
function M.handle(mode, line, _)
  local pattern = "(https?://[a-zA-Z%d_/%%%-%.~@\\+#=?&:*]+)"
  local url = helper.find(line, mode, pattern)

  -- match url without http(s)
  if not url then
    pattern = "([a-zA-Z%d_/%-%.~@\\+#]+%.[a-zA-Z_/%%%-%.~@\\+#=?&:]+)"
    url = helper.find(line, mode, pattern)
    if url then
      url = "https://" .. url
    end
  end

  if not url then
    return
  end

  return url:gsub("\\([%p])", "%1")
end

return M
