local handler = require("gx.handlers.cve")

describe("cve_handler_works", function()
  it("with_only_CVE_number_on_the_line", function()
    assert.equals(
      "https://nvd.nist.gov/vuln/detail/CVE-2020-24372",
      handler.handle("v", "CVE-2020-24372")
    )
  end)
  it("with_surrounding_text", function()
    assert.equals(
      "https://nvd.nist.gov/vuln/detail/CVE-2020-24372",
      handler.handle("v", "This fixes CVE-2020-24372 for sure")
    )
  end)
  it("with_comments", function()
    assert.equals(
      "https://nvd.nist.gov/vuln/detail/CVE-2020-24372",
      handler.handle("v", "#CVE-2020-24372")
    )
    assert.equals(
      "https://nvd.nist.gov/vuln/detail/CVE-2020-24372",
      handler.handle("v", "--CVE-2020-24372")
    )
    assert.equals(
      "https://nvd.nist.gov/vuln/detail/CVE-2020-24372",
      handler.handle("v", "//CVE-2020-24372")
    )
  end)
  it("within_parentheses", function()
    assert.equals(
      "https://nvd.nist.gov/vuln/detail/CVE-2020-24372",
      handler.handle("v", "This is related to CVE (CVE-2020-24372) and should be fixed")
    )
  end)
end)
