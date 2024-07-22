local shell = {}

function shell.execute(command, args, options)
  local cmd = { command, unpack(args) }
  options = options or {}
  local opts = vim.tbl_extend("force", {}, options)

  local obj = vim.system(cmd, opts):wait()

  return obj.code, (obj.stdout or "")
end

function shell.execute_with_error(command, args, options, url)
  local shell_args = {}
  for _, v in ipairs(args) do
    table.insert(shell_args, v)
  end
  table.insert(shell_args, url)

  local return_val, _ = shell.execute(command, shell_args, options)

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
