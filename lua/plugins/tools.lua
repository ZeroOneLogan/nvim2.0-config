return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = require("lsp.formatting").conform_opts(),
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      require("lsp.formatting").setup_lint()
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xw", "<cmd>Trouble workspace_diagnostics toggle<cr>", desc = "Workspace diagnostics" },
      { "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", desc = "References" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
    },
    opts = {
      use_diagnostic_signs = true,
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>tt", function()
        require("toggleterm").toggle(1, nil, vim.loop.cwd(), "float")
      end, desc = "Toggle terminal" },
    },
    opts = {
      open_mapping = [[<c-\>]],
      direction = "float",
      float_opts = { border = "curved" },
      size = 12,
      shade_terminals = true,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      vim.api.nvim_create_user_command("ToggleTermTab", function()
        require("toggleterm").toggle(0, nil, vim.loop.cwd(), "tab")
      end, { desc = "Toggle terminal tab" })
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize" } },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save session" },
    },
  },
}
