local handler = require("gx.handler")

describe("test handler", function()
  local activated_handlers = {
    plugin = false,
  }

  it("no extra handlers on", function()
    local filetype = "lua"

    assert.equals(
      "https://github.com",
      handler.get_url("v", "github.com", filetype, activated_handlers)
    )
    assert.equals(
      "https://github.com",
      handler.get_url("v", "https://github.com", filetype, activated_handlers)
    )

    assert.equals(
      nil,
      handler.get_url("v", '"example_user/example_plugin"', "lua", activated_handlers)
    )
  end)

  it("plugin handler on", function()
    local filetype = "lua"
    activated_handlers.plugin = true

    assert.equals(
      "https://github.com",
      handler.get_url("v", "github.com", filetype, activated_handlers)
    )
    assert.equals(
      "https://github.com",
      handler.get_url("v", "https://github.com", filetype, activated_handlers)
    )

    assert.equals(
      "https://github.com/example_user/example_plugin",
      handler.get_url("v", '"example_user/example_plugin"', filetype, activated_handlers)
    )
  end)

  it("plugin handler on wrong filetype", function()
    local filetype = "java"
    activated_handlers.plugin = true

    assert.equals(
      "https://github.com",
      handler.get_url("v", "github.com", filetype, activated_handlers)
    )
    assert.equals(
      "https://github.com",
      handler.get_url("v", "https://github.com", filetype, activated_handlers)
    )

    assert.equals(
      nil,
      handler.get_url("v", '"example_user/example_plugin"', filetype, activated_handlers)
    )
  end)
end)
