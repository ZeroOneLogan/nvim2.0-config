local prefs = require("user.prefs")

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize" } },
  },
  {
    "ahmedkhalf/project.nvim",
    enabled = prefs.values.project,
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "package.json", "pyproject.toml", "go.mod", "Cargo.toml" },
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      pcall(require("telescope").load_extension, "projects")
    end,
  },
}
