M = {}

local function parse_git_output(result)
  if not result or #result < 1 then
    return
  end

  local domain, repository = result[1]:match("@(.*%..*):(.*)%.git$")
  if domain and repository then
    return "https://" .. domain .. "/" .. repository
  end

  local url = result[1]:gsub("%.git%s*$", ""):match("^https?://.+")
  if url then
    return url
  end
end

function M.get_remote_url()
  local notifier = require("gx.notifier")

  local return_val, result = require("gx.shell").execute("git", { "remote", "get-url", "--push", "origin" })

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
