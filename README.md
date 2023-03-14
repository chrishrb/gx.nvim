# 🔗 gx.nvim

![ci](https://github.com/chrishrb/gx.nvim/actions/workflows/ci.yml/badge.svg)

## ✨ Features

* open links without `netrw`
* normal and visual mode support
* open links with/without an explicit protocol (e.g. `google.com` will open `https://google.com`)
* more to come (github, jira, ..)

## ⚡️ Requirements

* Neovim >= 0.5.0
* macOS (`open`) or linux (`xdg-open`)

## 📦 Installation 

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua

require("lazy").setup({
  {
    "chrishrb/gx.nvim",
    config = function()
      require("gx").setup()
    end,
  },
})
```

## ⌨️ Mappings

* `gx` is overriden by default

## 🚀 Usage

When your cursor is over a link or you mark a link or part of a link with the visual mode, you can press `gx` to open the link in the browser.
