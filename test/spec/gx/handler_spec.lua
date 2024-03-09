local helper = require("gx.helper")
local handler = require("gx.handler")
local stub = require("luassert.stub")

describe("test handler", function()
  local activated_handlers

  before_each(function()
    before_mock_filetype = vim.bo.filetype
    activated_handlers = {
      plugin = false,
      github = false,
      package_json = false,
      search = false,
    }
  end)

  after_each(function()
    vim.bo.filetype = before_mock_filetype
  end)

  it("no extra handlers on", function()
    -- mock filetype
    vim.bo.filetype = "lua"

    assert.equals("https://github.com", handler.get_url("v", "github.com", activated_handlers))
    assert.equals(
      "https://github.com",
      handler.get_url("v", "https://github.com", activated_handlers)
    )
    assert.is.Nil(handler.get_url("v", '"example_user/example_plugin"', activated_handlers))
    assert.is.Nil(handler.get_url("v", "Fixes #22", activated_handlers))
  end)

  it("plugin handler on", function()
    activated_handlers.plugin = true

    -- mock filetype
    vim.bo.filetype = "lua"

    assert.equals("https://github.com", handler.get_url("v", "github.com", activated_handlers))
    assert.equals(
      "https://github.com",
      handler.get_url("v", "https://github.com", activated_handlers)
    )
    assert.equals(
      "https://github.com/example_user/example_plugin",
      handler.get_url("v", '"example_user/example_plugin"', activated_handlers)
    )
  end)

  it("plugin handler on and filetype vim", function()
    activated_handlers.plugin = true
    activated_handlers.github = true

    -- mock filetype
    vim.bo.filetype = "vim"

    assert.equals("https://github.com", handler.get_url("v", "github.com", activated_handlers))
    assert.equals(
      "https://github.com",
      handler.get_url("v", "https://github.com", activated_handlers)
    )
    assert.equals(
      "https://github.com/example_user/example_plugin",
      handler.get_url("v", '"example_user/example_plugin"', activated_handlers)
    )
  end)

  it("plugin handler on wrong filetype", function()
    activated_handlers.plugin = true

    -- mock filetype
    vim.bo.filetype = "java"

    assert.equals("https://github.com", handler.get_url("v", "github.com", activated_handlers))
    assert.equals(
      "https://github.com",
      handler.get_url("v", "https://github.com", activated_handlers)
    )
    assert.is.Nil(handler.get_url("v", '"example_user/example_plugin"', activated_handlers))
  end)

  it("github handler on", function()
    activated_handlers.github = true

    -- mock filetype
    vim.bo.filetype = "lua"

    assert.equals("https://github.com", handler.get_url("v", "github.com", activated_handlers))
    assert.equals(
      "https://github.com",
      handler.get_url("v", "https://github.com", activated_handlers)
    )
    assert.equals(
      "https://github.com/chrishrb/gx.nvim/issues/22",
      handler.get_url("v", "Fixes #22", activated_handlers)
    )
  end)

  it("package_json handler on", function()
    activated_handlers.package_json = true

    -- mock filetype
    vim.bo.filetype = "json"

    stub(helper, "get_filename")
    helper.get_filename.on_call_with().returns("package.json")

    assert.equals(
      "https://www.npmjs.com/package/@rushstack/eslint-patch",
      handler.get_url("v", '"@rushstack/eslint-patch": "^1.2.0",', activated_handlers)
    )

    helper.get_filename:revert()
  end)

  it("user defined handler has precedence", function()
    activated_handlers.commit = true
    activated_handlers.custom = {
      handle = function()
        return "https://from.user.handler"
      end,
    }

    assert.equals("https://from.user.handler", handler.get_url("v", "1a2b3c4", activated_handlers))
  end)

  it("user defined handler instead of builtin handler", function()
    activated_handlers.commit = true
    activated_handlers.commit = {
      handle = function()
        return "https://from.user.handler"
      end,
    }

    assert.equals("https://from.user.handler", handler.get_url("v", "1a2b3c4", activated_handlers))
  end)
end)
