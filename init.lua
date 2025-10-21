vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.notify("Installing lazy.nvim…", vim.log.levels.INFO)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local prefs = require("user.prefs")
require("user.providers").setup()
require("user.profile").apply_startup(prefs.values.profile)

require("user.options").setup()
require("user.autocmds").setup()

require("lazy").setup("plugins", {
  defaults = { lazy = true, version = false },
  install = { colorscheme = { "catppuccin", "tokyonight", "habamax" } },
  rocks = { enabled = false, hererocks = false },
  change_detection = { notify = false },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "netrwPlugin",
      },
    },
  },
})

require("user.keymaps").setup()
require("user.commands").setup()
require("ui.theme").load()
