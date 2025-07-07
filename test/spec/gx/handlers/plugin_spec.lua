local handler = require("gx.handlers.plugin")

describe("plugin_handler_does_work", function()
  it('plugin with " string delimiter', function()
    assert.equals("https://github.com/user/example", handler.handle("v", '"user/example"'))
    assert.equals(
      "https://github.com/user123/example123",
      handler.handle("v", '"user123/example123"')
    )
    assert.equals("https://github.com/user_1/example_1", handler.handle("v", '"user_1/example_1"'))
    assert.equals("https://github.com/user-1/example-1", handler.handle("v", '"user-1/example-1"'))
  end)

  it("plugin with ' string delimiter", function()
    assert.equals("https://github.com/user/example", handler.handle("v", "'user/example'"))
    assert.equals(
      "https://github.com/user123/example123",
      handler.handle("v", "'user123/example123'")
    )
    assert.equals("https://github.com/user_1/example_1", handler.handle("v", "'user_1/example_1'"))
    assert.equals("https://github.com/user-1/example-1", handler.handle("v", "'user-1/example-1'"))
  end)
end)
