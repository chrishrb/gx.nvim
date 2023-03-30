local helper = require("gx.helper")
local mock = require("luassert.mock")

describe("gx.nvim:", function()
  before_each(function()
    m = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(m)
  end)

  it("cursor is on url", function()
    m.nvim_win_get_cursor.on_call_with(0).returns({ _, 5 })

    assert.True(helper.check_if_cursor_on_url("n", 1, 10))
    assert.True(helper.check_if_cursor_on_url("n", 1, 6))
    assert.True(helper.check_if_cursor_on_url("n", 6, 7))
    assert.False(helper.check_if_cursor_on_url("n", 1, 4))
    assert.False(helper.check_if_cursor_on_url("n", 7, 9))
    assert.False(helper.check_if_cursor_on_url("n", 16, 25))
  end)

  -- TODO: add test
  it("cut with visual mode", function() end)

  -- TODO: add test
  it("find pattern in line and check if cursor on it", function() end)

  it("ternary operator", function()
    assert.equals("foo", helper.ternary(true, "foo", "bar"))
    assert.equals("bar", helper.ternary(false, "foo", "bar"))
    assert.equals("bar", helper.ternary(nil, "foo", "bar"))
  end)
end)
