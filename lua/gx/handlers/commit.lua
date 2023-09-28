local helper = require("gx.helper")

local M = {
  -- every filetype and filename
  filetype = nil,
  filename = nil,
}

-- navigate to github url for commit
function M.handle(mode, line, _)
  local pattern = "(%x%x%x%x%x%x%x+)"
  local commit_hash = helper.find(line, mode, pattern)
  if not commit_hash or #commit_hash > 40 then
    return
  end
  local git_url = require("gx.git").get_remote_url()
  if not git_url then
    return
  end
  return git_url .. "/commit/" .. commit_hash
end

return M
