# 🔗 gx.nvim

![ci](https://github.com/chrishrb/gx.nvim/actions/workflows/ci.yml/badge.svg)

> ATTENTION: There was a breaking change in version v0.5.0. The keybinding `gx` must now be configured manually. See [Installation](#-installation)

## ✨ Features

* open links without `netrw`
* normal and visual mode support
* links with/without an explicit protocol (e.g. `google.com` will open `https://google.com`)
* open plugins in the browser with a single command (e.g. in lazy, packer you can hover over a plugin name, simply press `gx` or execute command `Browse` and you get to the github page of the plugin)
* open github issues directly in the browser (e.g. `Fixes #22` opens `https://github.com/chrishrb/gx.nvim/issues/22`)
* dependencies from `package.json` (e.g. line `"express": "^4.18.2",` in the `package.json` opens `https://www.npmjs.com/package/express`)
* formulae and casks from `Brewfile` (e.g. line `brew "neovim"` in the `Brewfile` opens `https://formulae.brew.sh/formula/neovim`)
* go packages from an import statement (e.g. line `import "github.com/joho/godotenv"` opens `https://pkg.go.dev/github.com/joho/godotenv`)
* if there is no url found under the cursor, the word/selection is automatically searched on the web
* supports user defined handlers to extend the functionality
* support for macOS, Linux and Windows
* if multiple patterns match you can simply select the desired URL from the menu

## ⚡️ Requirements

* Neovim >= 0.5.0
* macOS (`open`), Linux (`xdg-open`) or Windows (`powershell.exe start explorer.exe`)

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua

require("lazy").setup({
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function ()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true, -- default settings
    submodules = false, -- not needed, submodules are required only for tests

    -- you can specify also another config if you want
    config = function() require("gx").setup {
      open_browser_app = "os_specific", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
      open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
      handlers = {
        plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
        github = true, -- open github issues
        brewfile = true, -- open Homebrew formulaes and casks
        package_json = true, -- open dependencies from package.json
        search = true, -- search the web/selection on the web if nothing else is found
        go = true, -- open pkg.go.dev from an import statement (uses treesitter)
        jira = { -- custom handler to open Jira tickets (these have higher precedence than builtin handlers)
          name = "jira", -- set name of handler
          handle = function(mode, line, _)
            local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
            if ticket and #ticket < 20 then
              return "http://jira.company.com/browse/" .. ticket
            end
          end,
        },
        rust = { -- custom handler to open rust's cargo packages
          name = "rust", -- set name of handler
          filetype = { "toml" }, -- you can also set the required filetype for this handler
          filename = "Cargo.toml", -- or the necessary filename
          handle = function(mode, line, _)
            local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

            if crate then
              return "https://crates.io/crates/" .. crate
            end
          end,
        },
      },
      handler_options = {
        search_engine = "google", -- you can select between google, bing, duckduckgo, ecosia and yandex
        search_engine = "https://search.brave.com/search?q=", -- or you can pass in a custom search engine
        select_for_search = false, -- if your cursor is e.g. on a link, the pattern for the link AND for the word will always match. This disables this behaviour for default so that the link is opened without the select option for the word AND link

        git_remotes = { "upstream", "origin" }, -- list of git remotes to search for git issue linking, in priority
        git_remotes = function(fname) -- you can also pass in a function
            if fname:match("myproject") then
                return { "mygit" }
            end
            return { "upstream", "origin" }
        end,

        git_remote_push = false, -- use the push url for git issue linking,
        git_remote_push = function(fname) -- you can also pass in a function
          return fname:match("myproject")
        end,
      },
    } end,
  },
})
```

## 📡 Commands

* `Browse <URL or WORDS>`, e.g. `Browse http://google.de`, `Browse example`
* OR hover/select words, links and more and execute command `Browse`

## 🚀 Usage

When your cursor is over a link or you mark a link or part of a link with the visual mode, you can press `gx` to open the link in the browser.

## 📄 Acknowledgements

* lua functions library [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
