# 🔗 gx.nvim

![ci](https://github.com/chrishrb/gx.nvim/actions/workflows/ci.yml/badge.svg)

## ✨ Features

* open links without `netrw`
* normal and visual mode support
* open links with/without an explicit protocol (e.g. `google.com` will open `https://google.com`)
* open plugins in the browser with a single command (e.g. in lazy, packer you can hover over a plugin name, simply press `gx` and you get to the github page of the plugin)
* open github issues directly in the browser (e.g. `Fixes #22` opens `https://github.com/chrishrb/gx.nvim/issues/22`)
* more to come (jira issues, ..)

## ⚡️ Requirements

* Neovim >= 0.5.0
* macOS (`open`) or linux (`xdg-open`)

## 📦 Installation 

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua

require("lazy").setup({
  {
    "chrishrb/gx.nvim",
    event = { "BufEnter" },
    config = true, -- default settings

    -- you can specify also another config if you want
    config = function() require("gx").setup {
      open_browser_app = "os_specific", -- specify your browser app; default for macos is "open" and for linux "xdg-open"
      handlers = {
        plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
        github = true, -- open github issues
      },
    } end,
  },
})
```

## ⌨️ Mappings

* `gx` is overriden by default

## 🚀 Usage

When your cursor is over a link or you mark a link or part of a link with the visual mode, you can press `gx` to open the link in the browser.

## 📄 Acknowledgements

* Source code of `shell.lua` is partly from [lua-shell](https://github.com/ncopa/lua-shell)
