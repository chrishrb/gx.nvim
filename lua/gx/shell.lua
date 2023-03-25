local Job = require("plenary.job")
local notfier = require "gx.notfier"
local shell = {}

function shell.execute(command, args)
  local result, return_val = Job:new({
    command = command,
    args = args,
  }):sync()

  if return_val ~= 0 then
    local ret = {}
    for _, a in pairs(args) do
      table.insert(ret, a)
    end
    notfier.error('Command "' .. command .. table.concat(ret, " ") .. '" not successful.')
    return
  end

  return return_val, result
end

return shell
