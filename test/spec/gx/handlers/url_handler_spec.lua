local handler = require("gx.handlers.url")

describe("url_parser_does_work", function()
  it("urls", function()
    assert.equals("https://github.com", handler.handle("v", "https://github.com"))
    assert.equals("http://github.com", handler.handle("v", "http://github.com"))
    assert.equals("https://github.com", handler.handle("v", "github.com"))

    assert.equals(
      "https://example.hello.github.com/chrishrb/gx.nvim/#-installation",
      handler.handle("v", "https://example.hello.github.com/chrishrb/gx.nvim/#-installation")
    )
    assert.equals(
      "https://example.hello.github.com/chrishrb/gx.nvim/#-installation",
      handler.handle("v", "example.hello.github.com/chrishrb/gx.nvim/#-installation")
    )
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/#-installation",
      handler.handle("v", "https://github.com/chrishrb/gx.nvim/#-installation")
    )
    assert.equals(
      "http://github.com/chrishrb/gx.nvim/#-installation",
      handler.handle("v", "http://github.com/chrishrb/gx.nvim/#-installation")
    )
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/#-installation",
      handler.handle("v", "github.com/chrishrb/gx.nvim/#-installation")
    )
    assert.equals(
      "https://signin.aws.amazon.com/switchrole?roleName=my-role&account=111111111",
      handler.handle(
        "v",
        "https://signin.aws.amazon.com/switchrole?roleName=my-role&account=111111111"
      )
    )
    assert.equals(
      "http://localhost:8080/backend/swagger-ui/#/project-controller",
      handler.handle("v", "http://localhost:8080/backend/swagger-ui/#/project-controller")
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
