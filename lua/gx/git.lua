local Job = require("plenary.job")
local notfier = require("gx.notfier")

M = {}

local function parse_git_output(result)
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
  local result, return_val = Job:new({
    command = "git",
    args = { "remote", "-v" },
  }):sync()

  if return_val ~= 0 then
    notfier.error("Could not get git infos.")
    return
  end

  if not table or table.getn(result) == 0 then
    notfier.warn("No remote repository found")
  end

  local url = parse_git_output(result[1])
  if not url then
    notfier.warn("No remote repository found")
  end
  return url
end

return M
