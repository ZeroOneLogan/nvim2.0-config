local prefs = require("user.prefs")

local M = {}

local formatters_by_ft = {
  lua = { "stylua" },
  python = { "black", "isort" },
  javascript = { "prettierd", "prettier", "biome", "eslint_d" },
  typescript = { "prettierd", "prettier", "biome", "eslint_d" },
  typescriptreact = { "prettierd", "prettier", "biome", "eslint_d" },
  javascriptreact = { "prettierd", "prettier", "biome", "eslint_d" },
  tsx = { "prettierd", "prettier", "biome" },
  json = { "prettierd", "prettier", "biome" },
  jsonc = { "prettierd", "prettier", "biome" },
  markdown = { "markdownlint", "prettierd", "prettier" },
  yaml = { "yamlfmt", "prettierd", "prettier", "lsp" },
  toml = { "taplo" },
  go = { "gofumpt", "goimports" },
  rust = { "rustfmt" },
  sh = { "shfmt" },
  bash = { "shfmt" },
  css = { "prettierd", "prettier", "biome" },
  scss = { "prettierd", "prettier", "biome" },
  html = { "prettierd", "prettier", "biome" },
  terraform = { "terraform_fmt", "lsp" },
  c = { "clang_format" },
  cpp = { "clang_format" },
}

local formatter_meta = {
  stylua = { exe = "stylua", install = ":MasonInstall stylua" },
  black = { exe = "black", install = ":MasonInstall black" },
  isort = { exe = "isort", install = ":MasonInstall isort" },
  prettierd = { exe = "prettierd", install = ":MasonInstall prettierd" },
  prettier = { exe = "prettier", install = "npm install -g prettier" },
  biome = { exe = "biome", install = ":MasonInstall biome" },
  eslint_d = { exe = "eslint_d", install = "npm install -g eslint_d" },
  markdownlint = { exe = "markdownlint", install = ":MasonInstall markdownlint" },
  yamlfmt = { exe = "yamlfmt", install = "go install github.com/google/yamlfmt/cmd/yamlfmt@latest" },
  taplo = { exe = "taplo", install = ":MasonInstall taplo" },
  gofumpt = { exe = "gofumpt", install = "go install mvdan.cc/gofumpt@latest" },
  goimports = { exe = "goimports", install = "go install golang.org/x/tools/cmd/goimports@latest" },
  rustfmt = { exe = "rustfmt", install = "rustup component add rustfmt" },
  shfmt = { exe = "shfmt", install = ":MasonInstall shfmt" },
  terraform_fmt = { exe = "terraform", install = "brew install terraform" },
  clang_format = { exe = "clang-format", install = ":MasonInstall clang-format" },
}

local missing_by_ft = {}
local notified = false

local function is_executable(name)
  return vim.fn.executable(name) == 1
end

local function formatter_available(name)
  if name == "lsp" then
    return true
  end
  local meta = formatter_meta[name]
  if meta and meta.available then
    return meta.available()
  end
  local exe = meta and meta.exe or name
  return is_executable(exe)
end

local function missing_for_ft(ft)
  local formatters = formatters_by_ft[ft]
  if not formatters or vim.tbl_isempty(formatters) then
    return true, {}
  end
  local available = false
  local missing = {}
  for _, name in ipairs(formatters) do
    if formatter_available(name) then
      available = true
    elseif name ~= "lsp" then
      table.insert(missing, name)
    end
  end
  return available, missing
end

local function append_missing(ft, missing)
  if vim.tbl_isempty(missing) then
    return
  end
  local store = missing_by_ft[ft] or {}
  for _, name in ipairs(missing) do
    if not vim.tbl_contains(store, name) then
      table.insert(store, name)
    end
  end
  missing_by_ft[ft] = store
end

local function notify_once()
  if notified or vim.tbl_isempty(missing_by_ft) then
    return
  end
  notified = true
  local lines = { "Formatters missing for some filetypes:" }
  for ft, missing in pairs(missing_by_ft) do
    local entries = {}
    for _, name in ipairs(missing) do
      local hint = formatter_meta[name] and formatter_meta[name].install
      if hint then
        table.insert(entries, string.format("%s (%s)", name, hint))
      else
        table.insert(entries, name)
      end
    end
    table.insert(lines, string.format("  %s → %s", ft, table.concat(entries, ", ")))
  end
  table.insert(lines, "Install via :Mason or your system package manager, then reopen the file.")
  vim.schedule(function()
    vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN)
  end)
end

local function check_buffer(bufnr)
  local ft = vim.bo[bufnr].filetype
  if not ft or ft == "" then
    return
  end
  local available, missing = missing_for_ft(ft)
  if available then
    return
  end
  append_missing(ft, missing)
  notify_once()
end

local function exe(cmd)
  return vim.fn.executable(cmd) == 1
end

local function compute_tool_list()
  local tools = {
    "stylua",
    "black",
    "isort",
    "prettierd",
    "prettier",
    "markdownlint",
    "taplo",
  }
  if exe("node") == 1 then
    vim.list_extend(tools, { "biome", "eslint_d" })
  end
  if exe("go") == 1 then
    vim.list_extend(tools, { "gofumpt", "goimports" })
  end
  if exe("rustup") == 1 or exe("rustfmt") == 1 then
    table.insert(tools, "rustfmt")
  end
  if exe("terraform") == 1 then
    table.insert(tools, "terraform-ls")
  end
  if exe("shfmt") == 1 then
    table.insert(tools, "shfmt")
  end
  if exe("yamlfmt") == 1 then
    table.insert(tools, "yamlfmt")
  end
  table.insert(tools, "clang-format")
  return tools
end

function M.setup_tools()
  local ok, installer = pcall(require, "mason-tool-installer")
  if not ok then
    return
  end
  installer.setup({ ensure_installed = compute_tool_list(), auto_update = false })
end

function M.detect_missing_formatters()
  local report = {}
  for ft, _ in pairs(formatters_by_ft) do
    local available, missing = missing_for_ft(ft)
    if not available and not vim.tbl_isempty(missing) then
      report[ft] = vim.deepcopy(missing)
    end
  end
  return report
end

function M.session_missing()
  return vim.deepcopy(missing_by_ft)
end

function M.meta()
  return formatter_meta
end

function M.by_ft()
  return formatters_by_ft
end

function M.opts()
  return {
    notify_on_error = false,
    formatters_by_ft = formatters_by_ft,
    format_on_save = function(bufnr)
      if not prefs.values.format_on_save then
        return false
      end
      check_buffer(bufnr)
      return { timeout_ms = 3000, lsp_fallback = true }
    end,
  }
end

return M
