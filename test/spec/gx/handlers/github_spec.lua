local handler = require("gx.handlers.github")
local handler_options = {
  git_remotes = { "upstream", "origin" },
}

describe("github_handler_does_work", function()
  it("with_plain_issue_number", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/2",
      handler.handle("v", "#2", handler_options)
    )
  end)
  it("with_text_before_issue_number", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/22",
      handler.handle("v", "Fixes #22", handler_options)
    )
  end)
  it("with_text_after_issue_number", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/40",
      handler.handle("v", "#40 is a related issue", handler_options)
    )
  end)
  it("with_text_all_around", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/4",
      handler.handle("v", "Fixes #4 once and for all", handler_options)
    )
  end)
  it("with_issue_number_in_parentheses", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/51",
      handler.handle("v", "This is a squashed PR (#51)", handler_options)
    )
  end)
  it("github_issue owner detection", function()
    assert.equals(
      "https://github.com/foouser/gx.nvim/issues/42",
      handler.handle("v", "See foouser#42", handler_options)
    )
  end)
  it("parses owner/repo#issue format", function()
    assert.equals(
      "https://github.com/neovim/neovim/issues/23943",
      handler.handle("v", "Waiting on upstream neovim/neovim#23943", handler_options)
    )
  end)
  it("parses owner/repo#issue formats with dots", function()
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/46",
      handler.handle("v", "Waiting on upstream chrishrb/gx.nvim#46", handler_options)
    )
  end)
end)
