M = {}

local function parse_git_output(result)
  if not result or #result < 1 then
    return
  end

  local domain, repository = result[1]:gsub("%.git%s*$", ""):match("@(.*%..*):(.*)$")
  if domain and repository then
    return "https://" .. domain .. "/" .. repository
  end

  local url = result[1]:gsub("%.git%s*$", ""):match("^https?://.+")
  if url then
    return url
  end
end

function M.get_remote_url(remotes, push, owner, repo)
  local notifier = require("gx.notifier")

  local url = nil
  local path = vim.fn.expand("%:p:h")
  for _, remote in ipairs(remotes) do
    local args = { "-C", path, "remote", "get-url", remote }
    if push then
      table.insert(args, "--push")
    end
    local exit_code, result = require("gx.shell").execute("git", args)
    if exit_code == 0 then
      url = parse_git_output(result)
      if url then
        break
      end
    end
  end

  if not url then
    notifier.warn("No remote git repository found!")
    return
  end
  if type(owner) == "string" and owner ~= "" then
    local domain, repository = url:match("^https?://([^/]+)/[^/]+/([^/]*)")
    if repo ~= "" then
      repository = repo
    end
    url = string.format("https://%s/%s/%s", domain, owner, repository)
  end

  return url
end

return M
