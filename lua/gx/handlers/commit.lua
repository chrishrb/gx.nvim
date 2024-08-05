local helper = require("gx.helper")

---@type GxHandler
local M = {
  -- every filetype and filename
  name = "commit",
  filetype = nil,
  filename = nil,
}

-- navigate to github url for commit
function M.handle(mode, line, handler_options)
  local pattern = "(%x%x%x%x%x%x%x+)"
  local commit_hash = helper.find(line, mode, pattern)
  if not commit_hash or #commit_hash > 40 then
    return
  end

  local remotes = handler_options.git_remotes
  if type(remotes) == "function" then
    remotes = remotes(vim.fn.expand("%:p"))
  end

  local push = handler_options.git_remote_push
  if type(push) == "function" then
    push = push(vim.fn.expand("%:p"))
  end

  local git_url = require("gx.git").get_remote_url(remotes, push)
  if not git_url then
    return
  end
  return git_url .. "/commit/" .. commit_hash
end

return M
