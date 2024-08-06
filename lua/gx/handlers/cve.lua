local helper = require("gx.helper")

---@type GxHandler
local M = {
  -- every filetype and filename
  name = "cve",
  filetype = nil,
  filename = nil,
}

function M.handle(mode, line, _)
  local cve_id = helper.find(line, mode, "(CVE[%d-]+)")
  if not cve_id or #cve_id > 20 then
    return
  end
  return "https://nvd.nist.gov/vuln/detail/" .. cve_id
end

return M
