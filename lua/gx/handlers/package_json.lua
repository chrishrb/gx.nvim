local helper = require("gx.helper")

local M = {
  -- only package.json
  filetype = { "json" },
  filename = "package.json",
}

-- navigate to neovim github plugin url
function M.handle(mode, line, _)
  local pattern = '["]([^%s]*)["]:'
  local npm_package = helper.find(line, mode, pattern)
  if not npm_package then
    return
  end
  return "https://www.npmjs.com/package/" .. npm_package
end

return M
