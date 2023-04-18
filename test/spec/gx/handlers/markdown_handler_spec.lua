local handler = require("gx.handlers.markdown")

describe("url_parser_does_work", function()
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
    assert.equals(
      "http://localhost/api/v1/bla",
      handler.handle("v", "[url](http://localhost/api/v1/bla)")
    )
  end)
end)
