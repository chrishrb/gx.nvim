local Job = require("plenary.job")
local notfier = require("gx.notfier")
local shell = require("gx.shell")

M = {}

local function parse_git_output(result)
  if not result or table.getn(result) < 1 then
    return
  end

  local _, _, domain, repository = string.find(result, "^origin\t.*git@(.*%..*):(.*/.*).git")
  if domain and repository then
    return "https://" .. domain .. "/" .. repository
  end

  local _, _, url = string.find(result, "origin\t(.*)%s")
  if url then
    return url
  end
end

function M.get_remote_url()
  local return_val, result = shell.execute("git", { "remote", "-v" })

  if return_val ~= 0 then
    notfier.warn("No git information available!")
    return
  end

  local url = parse_git_output(result)
  if not url then
    notfier.warn("No remote git repository found!")
  end

  return url
end

return M
