local pattern = "[%a]*://.*%.[/?_%d%a]*"

local M = {}

-- get uri from line
function M.getUrl(line)
  local i, j = string.find(line, pattern)

  if not i then
    return i, j, nil
  end

  return i, j, string.sub(line, i, j)
end

-- TODO: add more parser

return M
