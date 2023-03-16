local helper = require("gx.helper")

local M = {}

M.filetype = nil

-- get url from line (with and without http/s)
function M.handle(mode, line)
  local pattern = "[%a]*[:/]?[^)%]%[\"'`˚:,!:;{}%s]*%.[/?_%-%d%a]*"
  local url = helper.find(line, mode, pattern)
  if url and not url:find("^http[s]?://") then
    url = "https://" .. url
  end
  return url
end

return M
