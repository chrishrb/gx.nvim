local helper = require "gx.helper"

local M = {}

-- find pattern in line and check if cursor on it
local function find(line, mode, pattern, startIndex)
  startIndex = startIndex or 1
  local i, j = string.find(line, pattern, startIndex)

  if helper.checkIfCursorOnUrl(mode, i, j) then
    return string.sub(line, i, j)
  elseif not i then
    return nil
  else
    return find(line, mode, pattern, j + 1)
  end
end

-- get url from line (with and without http/s)
function M.getUrl(mode, line)
  local pattern = "[%a]*[://]?[^)%]%[\"'`˚:,!:;{}]*%.[/?_%-%d%a]*"
  local url = find(line, mode, pattern)
  if url and not url:find("^http[s]?://") then
    url = "https://" .. url
  end
  return url
end

-- TODO: add more parser

return M
