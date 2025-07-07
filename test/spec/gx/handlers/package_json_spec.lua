local handler = require("gx.handlers.package_json")

describe("package_json_handler_does_work", function()
  it("package_json", function()
    assert.equals(
      "https://www.npmjs.com/package/@cucumber/cucumber",
      handler.handle("v", '"@cucumber/cucumber": "^9.0.1",')
    )
    assert.equals(
      "https://www.npmjs.com/package/@prisma/client",
      handler.handle("v", '"@prisma/client": "^4.11.0",')
    )
    assert.equals(
      "https://www.npmjs.com/package/express",
      handler.handle("v", '"express": "^4.18.2",')
    )
    assert.equals(
      "https://www.npmjs.com/package/vue-router",
      handler.handle("v", '"vue-router": "^4.1.6"')
    )
  end)
end)
