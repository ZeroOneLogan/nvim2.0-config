local prefs = require("user.prefs")

local M = {}

function M.opts()
  return {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      go = { "goimports", "gofumpt" },
      javascript = { "biome", "prettierd" },
      typescript = { "biome", "prettierd" },
      typescriptreact = { "biome", "prettierd" },
      javascriptreact = { "biome", "prettierd" },
      json = { "biome", "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      html = { "prettierd" },
      markdown = { "prettierd", "markdownlint" },
      yaml = { "yamlfmt" },
      rust = { "rustfmt" },
      toml = { "taplo" },
      terraform = { "terraform_fmt" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      c = { "clang_format" },
      cpp = { "clang_format" },
    },
    format_on_save = function()
      if prefs.values.format_on_save then
        return { timeout_ms = 3000, lsp_fallback = true }
      end
      return false
    end,
  }
end

return M
