local helper = require("gx.helper")
local git = require("gx.git")

local M = {}

-- every filetype and filename
M.filetype = nil
M.filename = nil

-- navigate to github url for commit
function M.handle(mode, line)
  local long_pattern = "(%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x)"
  local long_commit_hash = helper.find(line, mode, long_pattern)

  local short_pattern = "(%x%x%x%x%x%x%x)"
  local short_commit_hash = helper.find(line, mode, short_pattern)

  if not long_commit_hash and not short_commit_hash then
    return
  end

  local git_url = git.get_remote_url()
  if not git_url then
    return
  end

  return git_url .. "/commit/" .. (long_commit_hash or short_commit_hash)
end

return M
