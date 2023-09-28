local helper = require("gx.helper")

local M = {
  -- only Brewfile
  filetype = nil,
  filename = "Brewfile",
}

-- navigate to Homebrew Formulae url
function M.handle(mode, line, _)
  local brew_pattern = 'brew ["]([^%s]*)["]'
  local cask_pattern = 'cask ["]([^%s]*)["]'
  local brew = helper.find(line, mode, brew_pattern)
  local cask = helper.find(line, mode, cask_pattern)
  if brew then
    return "https://formulae.brew.sh/formula/" .. brew
  end
  if cask then
    return "https://formulae.brew.sh/cask/" .. cask
  end
end

return M
