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
  vim.notify("Running health checks…", vim.log.levels.INFO)
  vim.cmd("checkhealth")
  local ok, lazy_health = pcall(require, "lazy.health")
  if ok then
    lazy_health.check()
  end
  local registry = mason_registry()
  if registry and registry.refresh then
    registry.refresh()
  end
  vim.notify("Review the health report buffer for actionable tips.", vim.log.levels.INFO)
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
