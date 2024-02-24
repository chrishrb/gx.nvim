local handler = require("gx.handlers.github")
local handler_options = {
  git_remotes = { "upstream", "origin" },
}

describe("github_handler_does_work", function()
  it("github_issue", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/22",
      handler.handle("v", "Fixes #22", handler_options)
    )
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/2",
      handler.handle("v", "New Error #2", handler_options)
    )
  end)
  it("github_issue owner detection", function()
    assert.equals(
      "https://github.com/foouser/gx.nvim/issues/42",
      handler.handle("v", "See foouser#42", handler_options)
    )
  end)
end)
