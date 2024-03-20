local handler = require("gx.handlers.github")

describe("github_handler_does_work", function()
  it("with_plain_issue_number", function()
    assert.equals("https://github.com/chrishrb/gx.nvim/issues/2", handler.handle("v", "#2"))
  end)
  it("with_text_before_issue_number", function()
    assert.equals("https://github.com/chrishrb/gx.nvim/issues/22", handler.handle("v", "Fixes #22"))
  end)
  it("with_text_after_issue_number", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/40",
      handler.handle("v", "#40 is a related issue")
    )
  end)
  it("with_text_all_around", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/4",
      handler.handle("v", "Fixes #4 once and for all")
    )
  end)
  it("with_issue_number_in_parentheses", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/51",
      handler.handle("v", "This is a squashed PR (#51)")
    )
  end)
end)
