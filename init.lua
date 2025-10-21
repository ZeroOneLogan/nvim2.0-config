-- nvim2.0-config: Main entry point
-- Bootstraps lazy.nvim and loads the configuration modules.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.notify("Installing lazy.nvim – sit tight...", vim.log.levels.INFO)
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

-- Load core settings first so plugins inherit sensible defaults
require("core.options")
require("core.keymaps")
require("core.autocmds")

require("lazy").setup({
  spec = require("core.util").lazy_spec(),
  defaults = { lazy = true, version = false },
  install = { colorscheme = { "catppuccin", "tokyonight", "habamax" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Set the default theme after plugins are setup
require("ui.theme").load()
