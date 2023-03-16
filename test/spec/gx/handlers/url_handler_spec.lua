local handler = require("gx.handlers.url")

describe("url_parser_does_work", function()
  it("urls", function()
    assert.equals("https://github.com", handler.handle("v", "https://github.com"))
    assert.equals("http://github.com", handler.handle("v", "http://github.com"))
    assert.equals("https://github.com", handler.handle("v", "github.com"))
  end)

  it("urls in markdown", function()
    assert.equals("https://github.com", handler.handle("v", "[github](https://github.com)"))
    assert.equals("https://github.com", handler.handle("v", "* ![github](https://github.com)"))
    assert.equals(
      "https://github.com",
      handler.handle(
        "v",
        "This is [github](https://github.com), where you can get open source software."
      )
    )
  end)

  it("urls in python", function()
    assert.equals("https://github.com", handler.handle("v", "# https://github.com"))
    assert.equals("https://github.com", handler.handle("v", "# github.com"))
    assert.equals("https://github.com", handler.handle("v", 'print("https://github.com")'))
  end)

  it("urls in lua", function()
    assert.equals("https://github.com", handler.handle("v", "// Go to https://github.com"))
    assert.equals("https://github.com", handler.handle("v", "// Go to github.com"))
    assert.equals("https://github.com", handler.handle("v", "// github.com"))
    assert.equals("https://github.com", handler.handle("v", 'print("github.com")'))
  end)
end)
