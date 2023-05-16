local helper = require("gx.helper")
local git = require("gx.git")

local M = {}

-- every filetype and filename
M.filetype = nil
M.filename = nil

-- navigate to github url for commit
function M.handle(mode, line, _)
  local pattern = "(%x%x%x%x%x%x%x+)"
  local commit_hash = helper.find(line, mode, pattern)
  if not commit_hash or #commit_hash > 40 then
    return
  end
  local git_url = git.get_remote_url()
  if not git_url then
    return
  end
  return git_url .. "/commit/" .. commit_hash
end

return M
