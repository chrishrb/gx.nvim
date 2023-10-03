local helper = require("gx.helper")

local M = {
  -- every filename but only lua
  filetype = { "go" },
  filename = nil,
}

-- navigate to neovim github plugin url
function M.handle(mode, line, _)
  local pattern = "[\"']([^%s~/]*/[^%s~/]*)[\"']"
  local package_name = helper.find(line, mode, pattern)
  if package_name then
    return "https://pkg.go.dev/" .. package_name
  end
end

return M
