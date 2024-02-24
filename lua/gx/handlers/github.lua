local helper = require("gx.helper")

local M = {
  -- every filetype and filename
  filetype = nil,
  filename = nil,
}

-- navigate to neovim github plugin url
function M.handle(mode, line, _)
  local match = helper.find(line, mode, "%a*%s([%w-_]+#%d+)")
  if not match then
    match = helper.find(line, mode, "%a*%s(#%d+)")
  end
  if not match then
    return
  end
  local owner, issue = match:match("(.*)#(.+)")

  local git_url = require("gx.git").get_remote_url(owner)
  if not git_url then
    return
  end
  return git_url .. "/issues/" .. issue
end

return M
