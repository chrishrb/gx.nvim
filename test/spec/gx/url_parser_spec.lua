local handler = require("gx.handler")

describe("url_parser_does_work", function()
  it("urls", function()
    assert.equals("https://github.com", handler.getUrl("v", "https://github.com"))
    assert.equals("http://github.com", handler.getUrl("v", "http://github.com"))
    assert.equals("https://github.com", handler.getUrl("v", "github.com"))
  end)

  it("urls in markdown", function()
    assert.equals("https://github.com", handler.getUrl("v", "[github](https://github.com)"))
    assert.equals("https://github.com", handler.getUrl("v", "* ![github](https://github.com)"))
    assert.equals(
      "https://github.com",
      handler.getUrl(
        "v",
        "This is [github](https://github.com), where you can get open source software."
      )
    )
  end)

  it("urls in python", function()
    assert.equals("https://github.com", handler.getUrl("v", "# https://github.com"))
    assert.equals("https://github.com", handler.getUrl("v", "# github.com"))
    assert.equals("https://github.com", handler.getUrl("v", 'print("https://github.com")'))
  end)

  it("urls in lua", function()
    assert.equals("https://github.com", handler.getUrl("v", "// Go to https://github.com"))
    assert.equals("https://github.com", handler.getUrl("v", "// Go to github.com"))
    assert.equals("https://github.com", handler.getUrl("v", "// github.com"))
    assert.equals("https://github.com", handler.getUrl("v", 'print("github.com")'))
  end)
end)
