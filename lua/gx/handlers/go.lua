local M = {
  -- every filetype and filename
  name = "go",
  filetype = { "go" },
  filename = nil,
}

local function is_import_spec(node)
  return node:type() == "import_spec"
end

local function is_gopls_attached()
  return #vim.lsp.get_clients({ name = "gopls" }) > 0
end

local function request_hover_info()
  local method = "textDocument/hover"
  local params = vim.lsp.util.make_position_params()
  -- The default timeout is 1000ms
  return vim.lsp.buf_request_sync(0, method, params)
end

-- TODO check if it is an internal pkg
local function get_link_from_response(res_tbl)
  local res = res_tbl[1]
  if res and res.result then
    local value = res.result.contents.value
    return value:match("https://pkg%.go%.dev[%w.#/]+")
  end
  return nil
end

function M.handle()
  local node = vim.treesitter.get_node()
  if not node then
    return
  end

  if not is_import_spec(node) then
    if node:type() == "import_declaration" then
      node = node:named_child(0)
    else
      node = node:parent()
    end

    if not is_import_spec(node) then
      if not is_gopls_attached() then
        return
      end

      local res_tbl, err = request_hover_info()
      if err or not res_tbl or vim.tbl_isempty(res_tbl) then
        return
      end

      local link = get_link_from_response(res_tbl)
      if link then
        return link
      end

      return
    end
  end

  local path_node = node:field("path")[1]
  local start_line, start_col, end_line, end_col = path_node:range()

  local line = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)[1]
  local pkg = line:sub(start_col + 2, end_col - 1) -- remove quotes

  return "https://pkg.go.dev/" .. pkg
end

return M
