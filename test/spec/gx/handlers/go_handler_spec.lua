local handler = require("gx.handlers.go")

describe("go handler works", function()
  vim.cmd("edit test/fixtures/test.go")
  local function test_line(line, startpos, endpos, expected)
    for i = startpos, endpos do
      vim.api.nvim_win_set_cursor(0, { line, i })
      assert.equals(expected, handler.handle())
    end
  end
  it("parses single line imports", function()
    test_line(3, 0, 11, "https://pkg.go.dev/fmt")
  end)
  it("parses single line named imports", function()
    test_line(5, 0, 15, "https://pkg.go.dev/io")
  end)
  it("parses imports in list", function()
    test_line(8, 1, 26, "https://pkg.go.dev/github.com/joho/godotenv")
  end)
  it("parses named imports in list", function()
    test_line(9, 1, 27, "https://pkg.go.dev/k8s.io/api/core/v1")
  end)
end)
