local helper = require("gx.helper")

local M = {
  -- every filetype and filename
  filetype = nil,
  filename = nil,
}

-- navigate to neovim github plugin url
function M.handle(mode, line, _)
  local pattern = "%a*%s#(%d*)"
  local github_issue = helper.find(line, mode, pattern)
  if not github_issue then
    return
  end
  local git_url = require("gx.git").get_remote_url()
  if not git_url then
    return
  end
  return git_url .. "/issues/" .. github_issue
end

return M
