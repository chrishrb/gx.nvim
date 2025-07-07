local handler = require("gx.handlers.commit")
local handler_options = {
  git_remotes = { "upstream", "origin" },
}

describe("commit_handler_does_work", function()
  it("doesn't see a hash with < 7 characters", function()
    assert.is_nil(handler.handle("v", "1a2b3c", handler_options))
  end)

  it("does see a hash with 7 characters", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/commit/1a2b3c4",
      handler.handle("v", "1a2b3c4", handler_options)
    )
  end)

  it("does see a hash with 10 characters", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/commit/1a2b3c4d5f",
      handler.handle("v", "1a2b3c4d5f", handler_options)
    )
  end)

  it("does see a hash with 40 characters", function()
    local hash = "1a2b3c4d5f1a2b3c4d5f1a2b3c4d5f1a2b3c4d5f"
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/commit/" .. hash,
      handler.handle("v", hash, handler_options)
    )
  end)

  it("doesn't see a hash with > 40 characters", function()
    assert.is_nil(handler.handle("v", "1a2b3c4d5f1a2b3c4d5f1a2b3c4d5f1a2b3c4d5fa", handler_options))
  end)
end)
