local handler = require("gx.handlers.cve")

describe("cve_handler_works", function()
  it("opens CVE-s", function()
    assert.equals(
      "https://nvd.nist.gov/vuln/detail/CVE-2020-24372",
      handler.handle("v", "CVE-2020-24372")
    )
  end)
  it("opens CVE-s embedded in surrounding text", function()
    assert.equals(
      "https://nvd.nist.gov/vuln/detail/CVE-2020-24372",
      handler.handle("v", "This fixes CVE-2020-24372 for sure")
    )
  end)
end)
