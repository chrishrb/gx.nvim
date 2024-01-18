local helper = require("gx.helper")

local M = {
  -- only cargo.toml
  filetype = { "toml" },
  filename = "Cargo.toml",
}

-- navigate to neovim github plugin url
function M.handle(mode, line, handler_options)
  local pattern = "(%w+)%s-=%s"
  local crate = helper.find(line, mode, pattern)
  if not crate then
    return
  end

  if handler_options.crate_registry == "crates.io" then
    return "https://crates.io/crates/" .. crate
  elseif handler_options.crate_registry == "docs.rs" then
    return "https://docs.rs/" .. crate
  else
    require("gx.notifier").error(handler_options.crate_registry .. " is not supported")
    return
  end
end

return M
