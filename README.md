# 🔗 gx.nvim

![ci](https://github.com/chrishrb/gx.nvim/actions/workflows/ci.yml/badge.svg)

## ✨ Features

* open links without `netrw`
* normal and visual mode support
* links with/without an explicit protocol (e.g. `google.com` will open `https://google.com`)
* open plugins in the browser with a single command (e.g. in lazy, packer you can hover over a plugin name, simply press `gx` and you get to the github page of the plugin)
* open github issues directly in the browser (e.g. `Fixes #22` opens `https://github.com/chrishrb/gx.nvim/issues/22`)
* dependencies from `package.json` (e.g. line `"express": "^4.18.2",` in the `package.json` opens `https://www.npmjs.com/package/vue-router`)
* more to come (jira issues, ..)

## ⚡️ Requirements

* Neovim >= 0.5.0
* macOS (`open`) or Linux (`xdg-open`)

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua

require("lazy").setup({
  {
    "chrishrb/gx.nvim",
    event = { "BufEnter" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true, -- default settings

    -- you can specify also another config if you want
    config = function() require("gx").setup {
      open_browser_app = "os_specific", -- specify your browser app; default for macOS is "open" and for Linux "xdg-open"
      open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
      handlers = {
        plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
        github = true, -- open github issues
        package_json = true, -- open dependencies from package.json
      },
    } end,
  },
})
```

## ⌨️ Mappings

* `gx` is overridden by default

## 🚀 Usage

When your cursor is over a link or you mark a link or part of a link with the visual mode, you can press `gx` to open the link in the browser.

## 📄 Acknowledgements

* lua functions library [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
