local shell = {}

local function escape(args)
  local ret = {}
  for _, a in pairs(args) do
    local s = tostring(a)
    if s:match("[^A-Za-z0-9_/:=-]") then
      s = "'" .. s:gsub("'", "'\\''") .. "'"
    end
    table.insert(ret, s)
  end
  table.insert(ret, "&> /dev/null")
  return table.concat(ret, " ")
end

-- escape command and execute
function shell.execute(args)
  local command = escape(args)
  return command, os.execute(command)
end

return shell
