return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "b0o/schemastore.nvim",
      { "folke/neodev.nvim", opts = {} },
      { "j-hui/fidget.nvim", opts = {} },
      { "simrat39/rust-tools.nvim", lazy = true },
    },
    config = function()
      require("lsp").setup()
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local ok, jdtls = pcall(require, "jdtls")
      if not ok then return end
      local root = vim.fs.dirname(vim.fs.find({ "gradlew", "mvnw", ".git" }, { upward = true })[1])
      if not root then return end
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root, ":p:h:t")
      local lombok = vim.fn.glob(vim.fn.expand("$JAVA_HOME/lib/lombok.jar"))
      local cmd = { "jdtls", "-data", workspace_dir }
      if lombok ~= "" then
        table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok)
      end
      local config = {
        cmd = cmd,
        root_dir = root,
        settings = {
          java = {
            configuration = { updateBuildConfiguration = "interactive" },
          },
        },
        init_options = { bundles = {} },
      }
      jdtls.start_or_attach(config)
    end,
  },
}
