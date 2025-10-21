local M = {}

local servers = {
  bashls = {},
  clangd = {},
  cssls = {},
  dockerls = {},
  docker_compose_language_service = {},
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        analyses = { unusedparams = true },
        staticcheck = true,
      },
    },
  },
  html = {},
  jdtls = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  kotlin_language_server = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            "${3rd}/luv/library",
          },
        },
      },
    },
  },
  marksman = {},
  pyright = {},
  ruff = {},
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
      },
    },
  },
  solargraph = {},
  tailwindcss = {},
  taplo = {},
  tsserver = {},
  eslint = {},
  intelephense = {},
  terraformls = {},
  vimls = {},
  yamlls = {
    settings = {
      yaml = {
        keyOrdering = false,
        schemaStore = { enable = false, url = "" },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
}

local function setup_diagnostics()
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = { spacing = 4, prefix = "●" },
  })
end

local function on_attach(client, bufnr)
  local map = require("core.util").map
  local function buf_map(mode, lhs, rhs, desc)
    map(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  buf_map("n", "gd", vim.lsp.buf.definition, "Goto definition")
  buf_map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  buf_map("n", "gr", vim.lsp.buf.references, "References")
  buf_map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
  buf_map("n", "K", vim.lsp.buf.hover, "Hover")
  buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  buf_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  buf_map("n", "<leader>lf", function() require("conform").format({ async = true }) end, "Format file")
  buf_map("n", "<leader>ls", vim.lsp.buf.signature_help, "Signature help")
  buf_map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  buf_map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  buf_map("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List workspace folders")

  if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

local function capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_ok then
    caps = cmp_nvim_lsp.default_capabilities(caps)
  end
  caps.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return caps
end

function M.setup()
  setup_diagnostics()

  require("mason").setup()
  require("mason-tool-installer").setup({
    ensure_installed = {
      "stylua",
      "black",
      "isort",
      "ruff",
      "prettier",
      "prettierd",
      "eslint_d",
      "biome",
      "goimports",
      "gofumpt",
      "shfmt",
      "rubocop",
      "rustfmt",
      "markdownlint",
      "taplo",
      "yamllint",
      "selene",
      "shellcheck",
      "golangci-lint",
      "debugpy",
      "js-debug-adapter",
      "delve",
    },
    auto_update = false,
    run_on_start = true,
  })

  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({
    ensure_installed = {
      "bashls",
      "clangd",
      "cssls",
      "dockerls",
      "gopls",
      "html",
      "jdtls",
      "jsonls",
      "kotlin_language_server",
      "lua_ls",
      "marksman",
      "pyright",
      "ruff",
      "rust_analyzer",
      "solargraph",
      "tailwindcss",
      "taplo",
      "tsserver",
      "vimls",
      "yamlls",
      "eslint",
      "intelephense",
      "terraformls",
      "docker_compose_language_service",
    },
  })

  mason_lspconfig.setup_handlers({
    function(server)
      local server_opts = servers[server] or {}
      server_opts.capabilities = capabilities()
      server_opts.on_attach = on_attach
      require("lspconfig")[server].setup(server_opts)
    end,
    jdtls = function() end,
  })

  -- Rust tools
  if require("core.util").has("rust-tools.nvim") then
    require("rust-tools").setup({
      tools = { inlay_hints = { auto = true } },
      server = {
        on_attach = on_attach,
        capabilities = capabilities(),
        settings = servers.rust_analyzer.settings,
      },
    })
  end
end

return M
