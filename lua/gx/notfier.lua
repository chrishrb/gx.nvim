local M = {}
local name = "gx.nvim"

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.warn(msg)
  vim.notify(name .. ": " .. msg, vim.log.levels.WARN, { title = name or "Warning" })
end

function M.error(msg)
  vim.notify(name .. ": " .. msg, vim.log.levels.ERROR, { title = name or "Error Message" })
end

function M.info(msg)
  vim.notify(name .. ": " .. msg, vim.log.levels.INFO, { title = name or "Information" })
end

return M
