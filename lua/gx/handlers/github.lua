local helper = require("gx.helper")
local git = require("gx.git")

local M = {}

-- every filetype
M.filetype = nil

-- navigate to neovim github plugin url
function M.handle(mode, line)
  local pattern = "%a*%s#(%d*)"
  local github_issue = helper.find(line, mode, pattern)
  if github_issue then
    local git_url = git.get_remote_url()
    return git_url .. "/issues/" .. github_issue
  end
end

return M
