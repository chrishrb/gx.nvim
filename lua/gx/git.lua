M = {}

local function parse_git_output(result)
  if not result or #result < 1 then
    return
  end

  local _, _, domain, repository = string.find(result[1], "^origin\t.*git@(.*%..*):(.*/.*).git")
  if domain and repository then
    return "https://" .. domain .. "/" .. repository
  end

  local _, _, url = string.find(result[1], "origin\t(.*)%s")
  if url then
    return url
  end
end

function M.get_remote_url()
  local notifier = require("gx.notifier")

  local return_val, result = require("gx.shell").execute("git", { "remote", "-v" })

  if return_val ~= 0 then
    notifier.warn("No git information available!")
    return
  end

  local url = parse_git_output(result)
  if not url then
    notifier.warn("No remote git repository found!")
    return
  end

  return url
end

return M
