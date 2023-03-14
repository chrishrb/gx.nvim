local parser = require "gx.parser"

describe("url_parser_does_work", function()
  it("url in markdowns", function()
    assert.equals("https://github.com", parser.getUrl("n", "https://github.com"))
    assert.equals("http://github.com", parser.getUrl("n", "http://github.com"))
    assert.equals("https://github.com", parser.getUrl("n", "github.com"))
  end)
end)
