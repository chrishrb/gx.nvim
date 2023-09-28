local shell = {}

function shell.execute(command, args)
  -- TODO: This could use vim.system() in 0.10+
  local Job = require("plenary.job")

  local result, return_val = Job:new({
    command = command,
    args = args,
  }):sync()

  return return_val, result
end

function shell.execute_with_error(command, args, url)
  local shell_args = {}
  for _, v in ipairs(args) do
    table.insert(shell_args, v)
  end
  table.insert(shell_args, url)

  local return_val, _ = shell.execute(command, shell_args)

  if return_val ~= 0 then
    local ret = {}
    for _, a in pairs(args) do
      table.insert(ret, a)
    end

    require("gx.notifier").error(
      'Command "' .. command .. " " .. table.concat(ret, " ") .. '" not successful.'
    )
  end
end

return shell
