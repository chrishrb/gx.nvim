local helper = require "gx.helper"
local mock = require "luassert.mock"

describe("gx.nvim:", function()
  before_each(function()
    api_mock = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api_mock)
  end)

  it("cursor is on url", function()
    api_mock.nvim_win_get_cursor.on_call_with(0).returns { _, 5 }

    assert.True(helper.checkIfCursorOnUrl("n", 1, 10))
    assert.True(helper.checkIfCursorOnUrl("n", 1, 6))
    assert.True(helper.checkIfCursorOnUrl("n", 6, 7))
    assert.False(helper.checkIfCursorOnUrl("n", 1, 4))
    assert.False(helper.checkIfCursorOnUrl("n", 7, 9))
    assert.False(helper.checkIfCursorOnUrl("n", 16, 25))
  end)

  -- TODO: add test
  it("cut with visual mode", function() end)
end)
