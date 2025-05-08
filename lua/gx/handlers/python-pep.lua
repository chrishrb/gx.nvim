local helper = require("gx.helper")

---@type GxHandler
local M = {
  name = "python-pep",
  filetype = nil,
  filename = nil,
}

function M.handle(mode, line, _)
  local id = helper.find(line, mode, "PEP%s?-?(%d+)")
  if not id then
    return
  end
  return "https://peps.python.org/" .. "pep-" .. id
end

return M
