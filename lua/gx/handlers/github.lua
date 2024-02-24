local helper = require("gx.helper")

local M = {
  -- every filetype and filename
  name = "github",
  filetype = nil,
  filename = nil,
}

-- navigate to neovim github plugin url
function M.handle(mode, line, handler_options)
  local match = helper.find(line, mode, "([%w-_]+#%d+)")
  if not match then
    match = helper.find(line, mode, "(#%d+)")
  end
  if not match then
    return
  end
  local owner, issue = match:match("(.*)#(.+)")

  local remotes = handler_options.git_remotes
  if type(remotes) == "function" then
    remotes = remotes(vim.fn.expand("%:p"))
  end

  local git_url = require("gx.git").get_remote_url(remotes, owner)
  if not git_url then
    return
  end
  return git_url .. "/issues/" .. issue
end

return M
