local handler = require("gx.handlers.cargo_toml")

describe("cargo_toml_handler_does_work", function()
  it("crates.io", function()
    local handler_options = {
      crate_registry = "crates.io",
    }

    assert.equals(
      "https://crates.io/crates/clap",
      handler.handle("v", 'clap = { version = "4.0.18", features = ["derive"] }', handler_options)
    )
    assert.equals(
      "https://crates.io/crates/regex",
      handler.handle("v", 'regex = "1"', handler_options)
    )
  end)

  it("docs.rs", function()
    local handler_options = {
      crate_registry = "docs.rs",
    }

    assert.equals(
      "https://docs.rs/clap",
      handler.handle("v", 'clap = { version = "4.0.18", features = ["derive"] }', handler_options)
    )
    assert.equals("https://docs.rs/regex", handler.handle("v", 'regex = "1"', handler_options))
  end)
end)
