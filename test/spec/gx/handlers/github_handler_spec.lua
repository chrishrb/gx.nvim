local handler = require("gx.handlers.github")

describe("github_handler_does_work", function()
  it("github_issue", function()
    assert.equals("https://github.com/chrishrb/gx.nvim/issues/22", handler.handle("v", "Fixes #22"))
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/2",
      handler.handle("v", "New Error #2")
    )
  end)
end)
