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

local cached_mod_name
local function get_mode_name()
  if cached_mod_name then
    return cached_mod_name
  end

  local files = vim.fs.find("go.mod", { upward = true })
  if #files == 0 or vim.tbl_isempty(files) then
    return ""
  end

  local file = files[1]
  local line = vim.fn.readfile(file, "", 1)
  if #line == 0 then
    return ""
  end
  local mod_name = line[1]:match("^module%s+([^\n]+)")
  if mod_name then
    cached_mod_name = mod_name
    return mod_name
  end

  return ""
end

local function is_internal(url)
  local mod = get_mode_name()
  return mod ~= "" and url:find(mod, 1, true)
end

local function request_hover_info()
  local method = "textDocument/hover"
  local params = vim.lsp.util.make_position_params()
  -- The default timeout is 1000ms
  return vim.lsp.buf_request_sync(0, method, params)
end

local function get_url_from_response(res_tbl)
  local res = res_tbl[1]
  if res and res.result then
    local value = res.result.contents.value
    -- Test case
    -- https://pkg.go.dev/github.com/json-iterator/go@v1.1.12#API.Unmarshal
    -- https://pkg.go.dev/context#Context
    local url = value:match("%(https://pkg%.go%.dev[%S]+%)")
    if not url then
      return nil
    end
    url = url:sub(2, -2)
    if is_internal(url) then
      return nil
    end
    return url
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
    if not node then
      return
    end

    if not is_import_spec(node) then
      if not is_gopls_attached() then
        return
      end

      local res_tbl, err = request_hover_info()
      if err or not res_tbl or vim.tbl_isempty(res_tbl) then
        return
      end

      local url = get_url_from_response(res_tbl)
      if url then
        return url
      end

      return
    end
  end

  local path_node = node:field("path")[1]
  local start_line, start_col, end_line, end_col = path_node:range()

  local line = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)[1]
  local pkg = line:sub(start_col + 2, end_col - 1) -- remove quotes
  if is_internal(pkg) then
    return
  end

  return "https://pkg.go.dev/" .. pkg
end

return M
