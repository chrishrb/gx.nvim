local helper = require("gx.helper")

---@type GxHandler
local M = {
  -- every filetype and filename
  name = "elixir",
  filetype = { "exs" },
  filename = nil,
}

-- hex.pm pattern: https://hex.pm/packages/<package>/<version>
local hex_url = "https://hex.pm/packages/"
local pattern = '{:([%l_]*),%s[~>=]-%s"([%d.]*)"[^}]*}'

-- matches package and version from line, e.g. {:dep, ~> "1.0.0"} => "dep", "1.0.0"
function M.handle(_, line, _)
  local package_name, version = string.match(line, pattern)
  package_name = package_name ~= "" and package_name or nil
  version = version ~= "" and version or nil

  local hex_path = package_name and version and (package_name .. "/" .. version)
    or package_name
    or nil

  return hex_path and (hex_url .. hex_path) or nil
end

return M
