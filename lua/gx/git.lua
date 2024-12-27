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

local function discover_remote(remotes, push, path)
  local url = nil
  for _, remote in ipairs(remotes) do
    local args = { "-C", path, "remote", "get-url", remote }
    if push then
      table.insert(args, "--push")
    end
    local exit_code, result = require("gx.shell").execute("git", args)
    if exit_code == 0 then
      url = parse_git_output(result)
      if url then
        return url
      end
    end
  end
  return url
end

function M.get_remote_url(remotes, push, owner, repo)
  local notifier = require("gx.notifier")

  local path = vim.fn.expand("%:p:h")
  local url = discover_remote(remotes, push, path)
  if not url then
    url = discover_remote(remotes, push, vim.loop.cwd())
  end

  local has_owner = type(owner) == "string" and owner ~= ""
  local has_repo = type(repo) == "string" and repo ~= ""
  if not url and has_owner and has_repo then
    -- fallback to github if owner and repo are present
    url = "https://github.com/foo/bar"
  end
  if not url then
    notifier.warn("No remote git repository found!")
    return
  end
  if has_owner then
    local domain, repository = url:match("^https?://([^/]+)/[^/]+/([^/]*)")
    if has_repo then
      repository = repo
    end
    url = string.format("https://%s/%s/%s", domain, owner, repository)
  end

  return url
end

return M
