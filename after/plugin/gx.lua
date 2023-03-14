if vim.g.loaded_gx_plugin then
  return
end

vim.g.loaded_gx_plugin = true

require("gx").setup()
