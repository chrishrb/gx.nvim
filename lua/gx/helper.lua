local M = {}

-- get visual selection
local function visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))

  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return cscol - 1, cecol
  else
    return cecol - 1, cscol
  end
end

-- check that cursor on uri in normal mode
function M.check_if_cursor_on_url(mode, i, j)
  if mode ~= "n" then
    return true
  end

  local col = vim.api.nvim_win_get_cursor(0)[2]
  if i <= (col + 1) and j >= (col + 1) then
    return true
  end

  return false
end

-- cut line if in visual mode
function M.cut_with_visual_mode(mode, line)
  if mode ~= "v" then
    return line
  end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", false)
  local i, j = visual_selection_range()
  return string.sub(line, i + 1, j)
end

-- find pattern in line and check if cursor on it
function M.find(line, mode, pattern, startIndex)
  startIndex = startIndex or 1
  local i, j, value = string.find(line, pattern, startIndex)

  if not i then
    return nil
  elseif M.check_if_cursor_on_url(mode, i, j) then
    return value
  else
    return M.find(line, mode, pattern, j + 1)
  end
end

-- ternary operator for lua
function M.ternary(cond, T, F)
  if cond then
    return T
  else
    return F
  end
end

-- check for filetype
function M.check_filetype(handler_filetype)
  local file_filetype = vim.bo.filetype
  if not handler_filetype then
    return true
  end
  if handler_filetype == file_filetype then
    return true
  end
  return false
end

-- get filename
function M.get_filename()
  return vim.fn.expand("%:t")
end

-- check for filename
function M.check_filename(handler_filename)
  local filename = M.get_filename()
  if not handler_filename then
    return true
  end
  if handler_filename == filename then
    return true
  end
  return false
end

return M
