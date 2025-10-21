local M = {}

local servers = {
  bashls = {},
  clangd = {},
  cssls = {},
  dockerls = {},
  gopls = {},
  html = {},
  jdtls = {},
  jsonls = require("lsp.servers.jsonls"),
  kotlin_language_server = {},
  lua_ls = require("lsp.servers.lua_ls"),
  marksman = {},
  pyright = {},
  ruff_lsp = require("lsp.servers.ruff_lsp"),
  rust_analyzer = require("lsp.servers.rust_analyzer"),
  tailwindcss = {},
  taplo = {},
  tsserver = require("lsp.servers.tsserver"),
  yamlls = require("lsp.servers.yamlls"),
  eslint = {},
  intelephense = {},
  terraformls = {},
}

local function get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
  return capabilities
end

local function lsp_keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end
  map("n", "gd", vim.lsp.buf.definition, "Goto definition")
  map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  map("n", "gr", vim.lsp.buf.references, "Goto references")
  map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>f", function()
    require("conform").format({ async = true })
  end, "Format buffer")
  map("n", "<leader>ds", vim.diagnostic.open_float, "Line diagnostics")
end

function M.on_attach(client, bufnr)
  lsp_keymaps(bufnr)
  if client.server_capabilities.inlayHintProvider then
    pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
  end
  if client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens then
    vim.lsp.semantic_tokens.start(bufnr, client.id)
  end
end

function M.setup()
  require("mason").setup()
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })

  local capabilities = get_capabilities()

  mason_lspconfig.setup_handlers({
    function(server_name)
      local opts = vim.tbl_deep_extend("force", {}, servers[server_name] or {})
      opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
      local server_on_attach = opts.on_attach
      opts.on_attach = function(client, bufnr)
        if server_on_attach then
          server_on_attach(client, bufnr)
        end
        M.on_attach(client, bufnr)
      end
      require("lspconfig")[server_name].setup(opts)
    end,
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return M
