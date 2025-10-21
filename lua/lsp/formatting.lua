local M = {}

local conform_formatters = {
  lua = { "stylua" },
  python = { "isort", "black" },
  javascript = { "prettierd", "prettier", "biome" },
  javascriptreact = { "prettierd", "prettier", "biome" },
  typescript = { "prettierd", "prettier", "biome" },
  typescriptreact = { "prettierd", "prettier", "biome" },
  vue = { "prettierd", "prettier", "biome" },
  css = { "prettierd", "prettier" },
  scss = { "prettierd", "prettier" },
  html = { "prettierd", "prettier" },
  json = { "prettierd", "prettier" },
  jsonc = { "prettierd", "prettier" },
  yaml = { "prettierd", "prettier" },
  markdown = { "prettierd", "prettier", "markdownlint" },
  graphql = { "prettierd", "prettier" },
  go = { "gofumpt", "goimports" },
  rust = { "rustfmt" },
  sh = { "shfmt" },
  bash = { "shfmt" },
  ruby = { "rubocop" },
  toml = { "taplo" },
  php = { "prettierd", "prettier" },
}

function M.conform_opts()
  return {
    format_on_save = function(bufnr)
      return { timeout_ms = 1000, lsp_fallback = not conform_formatters[vim.bo[bufnr].filetype] }
    end,
    formatters_by_ft = conform_formatters,
    formatters = {
      prettierd = {
        env = { PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/.prettierrc.json") },
      },
      biome = {
        condition = function(ctx)
          return vim.fs.find({ "biome.json", "biome.jsonc" }, { upward = true, path = ctx.filename })[1] ~= nil
        end,
      },
    },
  }
end

function M.setup_lint()
  local lint = require("lint")
  lint.linters_by_ft = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    vue = { "eslint_d" },
    python = { "ruff" },
    markdown = { "markdownlint" },
    lua = { "selene" },
    sh = { "shellcheck" },
    go = { "golangci_lint" },
  }

  local group = vim.api.nvim_create_augroup("nvim2_lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = group,
    callback = function()
      lint.try_lint()
    end,
  })
end

return M
