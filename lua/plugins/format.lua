return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      return require("lsp.formatting").opts()
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("lsp.linting").setup()
    end,
  },
}
