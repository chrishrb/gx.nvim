local init = require("gx")
local assert = require("luassert")

describe("test plugin setup", function()
  before_each(function()
    init.options = nil
  end)

  it("retains custom handler options", function()
    local options = {
      handler_options = {
        custom_url = "example.com",
      },
    }
    init.setup(options)
    assert.same(options.handler_options.custom_url, init.options.handler_options.custom_url)
  end)
end)
