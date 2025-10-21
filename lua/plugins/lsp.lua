return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonLog", "MasonUpdate" },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    config = function()
      require("lsp.formatting").setup_tools()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      require("lsp").setup()
    end,
  },
  {
    "folke/neodev.nvim",
    ft = { "lua" },
    opts = {},
  },
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = function()
      local lsp = require("lsp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp.default_capabilities(capabilities)
      end
      return {
        ui = { border = "rounded" },
        decorations = { statusline = { app_version = true, device = true } },
        widget_guides = { enabled = true },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
        lsp = {
          on_attach = lsp.on_attach,
          capabilities = capabilities,
          settings = {
            dart = {
              completeFunctionCalls = true,
              showTodos = true,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("flutter-tools").setup(opts)
    end,
  },
}
