local profile = require("user.profile")
local util = require("user.util")

local M = {}

local function mason_registry()
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    vim.notify("Mason is not available – run :Lazy sync", vim.log.levels.WARN)
    return nil
  end
  return registry
end

local PROJECT_TOOLING = {
  {
    name = "Node / TypeScript",
    files = { "package.json", "tsconfig.json", "jsconfig.json" },
    packages = {
      "typescript-language-server",
      "eslint-lsp",
      "prettierd",
      "js-debug-adapter",
      "biome",
    },
  },
  {
    name = "Python",
    files = { "pyproject.toml", "requirements.txt", "setup.py" },
    packages = {
      "pyright",
      "ruff-lsp",
      "black",
      "isort",
      "debugpy",
      "ruff",
    },
  },
  {
    name = "Go",
    files = { "go.mod", "go.sum" },
    packages = {
      "gopls",
      "goimports",
      "gofumpt",
      "delve",
    },
  },
  {
    name = "Rust",
    files = { "Cargo.toml" },
    packages = {
      "rust-analyzer",
      "rustfmt",
      "codelldb",
    },
  },
  {
    name = "Lua",
    files = { ".luarc.json", "stylua.toml" },
    packages = {
      "lua-language-server",
      "stylua",
    },
  },
  {
    name = "Docker",
    files = { "Dockerfile" },
    packages = { "dockerfile-language-server" },
  },
  {
    name = "Terraform",
    files = { "main.tf" },
    packages = { "terraform-ls" },
  },
  {
    name = "Markdown / Docs",
    files = { "README.md" },
    packages = { "marksman", "markdownlint" },
  },
}

local function detect_tooling()
  local detected = {}
  for _, spec in ipairs(PROJECT_TOOLING) do
    if util.in_project_root(spec.files) then
      table.insert(detected, spec)
    end
  end
  return detected
end

local function install_packages(packages)
  if #packages == 0 then
    vim.notify("All recommended tools are already installed ✅", vim.log.levels.INFO)
    return
  end
  local choice = vim.fn.confirm("Install missing tools?\n" .. table.concat(packages, "\n"), "&Yes\n&No", 1)
  if choice ~= 1 then
    return
  end
  vim.cmd("MasonInstall " .. table.concat(packages, " "))
end

local function analyze_and_install(registry)
  local detected = detect_tooling()
  if vim.tbl_isempty(detected) then
    vim.notify("No project fingerprints detected – customize via :Mason", vim.log.levels.INFO)
    return
  end
  local missing = {}
  for _, spec in ipairs(detected) do
    for _, pkg in ipairs(spec.packages) do
      local ok, package = pcall(registry.get_package, registry, pkg)
      if not ok or not package:is_installed() then
        table.insert(missing, pkg)
      end
    end
  end
  local uniq = {}
  local deduped = {}
  for _, pkg in ipairs(missing) do
    if not uniq[pkg] then
      uniq[pkg] = true
      table.insert(deduped, pkg)
    end
  end
  install_packages(deduped)
end

local function onboarding()
  local registry = mason_registry()
  if not registry then
    return
  end
  if registry.refresh then
    registry.refresh(function()
      analyze_and_install(registry)
    end)
  else
    analyze_and_install(registry)
  end
end

local function doctor()
  local lines = { "# Nvim2 Doctor", "" }

  table.insert(lines, "## Providers")
  local providers = require("user.providers").status()
  local provider_keys = vim.tbl_keys(providers)
  table.sort(provider_keys)
  for _, key in ipairs(provider_keys) do
    local info = providers[key]
    if not info.enabled then
      table.insert(lines, string.format("- %s: disabled (enable via prefs.providers.%s)", key, key))
    elseif info.available then
      table.insert(lines, string.format("- %s: ready (%s)", key, info.host or "auto"))
    else
      table.insert(
        lines,
        string.format(
          "- %s: missing `%s` → %s",
          key,
          info.host or (key == "python" and "python3" or key),
          info.install or "see README tooling table"
        )
      )
    end
  end
  if #provider_keys == 0 then
    table.insert(lines, "- No dynamic providers configured.")
  end

  table.insert(lines, "")
  table.insert(lines, "## Formatters")
  local formatting = require("lsp.formatting")
  local formatter_meta = formatting.meta()
  local missing_formatters = formatting.detect_missing_formatters()
  if vim.tbl_isempty(missing_formatters) then
    table.insert(lines, "- All configured formatters available (or LSP fallback active). ✅")
  else
    local fts = vim.tbl_keys(missing_formatters)
    table.sort(fts)
    for _, ft in ipairs(fts) do
      local missing = missing_formatters[ft]
      local entries = {}
      for _, name in ipairs(missing) do
        local hint = formatter_meta[name] and formatter_meta[name].install
        if hint then
          table.insert(entries, string.format("%s (%s)", name, hint))
        else
          table.insert(entries, name)
        end
      end
      table.insert(lines, string.format("- %s → %s", ft, table.concat(entries, ", ")))
    end
  end

  table.insert(lines, "")
  table.insert(lines, "## Debug Adapters")
  local adapters = {
    {
      name = "python",
      command = providers.python and providers.python.host or "python",
      install = ":MasonInstall debugpy",
    },
    {
      name = "pwa-node",
      command = "node",
      install = ":MasonInstall js-debug-adapter",
    },
  }
  for _, adapter in ipairs(adapters) do
    local cmd = adapter.command or adapter.name
    if vim.fn.executable(cmd) == 1 then
      table.insert(lines, string.format("- %s: `%s` available", adapter.name, cmd))
    else
      table.insert(lines, string.format("- %s: missing `%s` → %s", adapter.name, cmd, adapter.install))
    end
  end

  table.insert(lines, "")
  table.insert(lines, "Run `:checkhealth` for upstream plugin diagnostics if needed.")

  local util = vim.lsp and vim.lsp.util
  if util and util.open_floating_preview then
    local buf, win = util.open_floating_preview(lines, "markdown", { border = "rounded", focusable = true })
    if win then
      vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")
    end
    if buf then
      vim.bo[buf].bufhidden = "wipe"
    end
  else
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
  end
end

local function pick_profile()
  local options = profile.available()
  vim.ui.select(options, { prompt = "Select Nvim2 profile" }, function(choice)
    if choice then
      profile.set_profile(choice)
    end
  end)
end

function M.open_prefs()
  local prefs = require("user.prefs")
  local path = prefs.persist_path()
  if not vim.uv.fs_stat(path) then
    local default_path = vim.api.nvim_get_runtime_file("lua/user/prefs.lua", false)[1]
    if default_path then
      vim.notify_once("Opening default prefs.lua – save to create prefs.local.lua", vim.log.levels.INFO)
      vim.cmd.edit(default_path)
    else
      vim.notify("prefs.lua not found", vim.log.levels.ERROR)
    end
    return
  end
  vim.cmd.edit(path)
end

function M.setup()
  vim.api.nvim_create_user_command("Nvim2Setup", onboarding, { desc = "Project onboarding assistant" })
  vim.api.nvim_create_user_command("Nvim2Doctor", doctor, { desc = "Run health checks" })
  vim.api.nvim_create_user_command("Nvim2Profile", pick_profile, { desc = "Switch profile" })
  vim.api.nvim_create_user_command("Nvim2Keys", function()
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.show("<leader>")
    else
      vim.cmd("Telescope keymaps")
    end
  end, { desc = "Show keymaps" })
end

return M
