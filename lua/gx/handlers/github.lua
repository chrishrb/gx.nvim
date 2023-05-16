local helper = require("gx.helper")
local git = require("gx.git")

local M = {}

-- every filetype and filename
M.filetype = nil
M.filename = nil

-- navigate to neovim github plugin url
function M.handle(mode, line, _)
  local pattern = "%a*%s#(%d*)"
  local github_issue = helper.find(line, mode, pattern)
  if not github_issue then
    return
  end
  local git_url = git.get_remote_url()
  if not git_url then
    return
  end
  return git_url .. "/issues/" .. github_issue
end

return M
