local prefs = require("user.prefs")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = prefs.values.explorer == "neo-tree",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<space>"] = "toggle_node",
          ["<CR>"] = "open",
          ["o"] = "open",
          ["q"] = "close_window",
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    enabled = prefs.values.explorer == "nvim-tree",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      respect_buf_cwd = true,
      sync_root_with_cwd = true,
      update_focused_file = { enable = true },
      renderer = { highlight_git = true, indent_markers = { enable = true } },
      view = { width = 30 },
    },
  },
  {
    "stevearc/aerial.nvim",
    enabled = prefs.values.outline,
    cmd = "AerialToggle",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      attach_mode = "global",
      backends = { "treesitter", "lsp", "markdown" },
      layout = { max_width = { 40, 0.2 } },
      show_guides = true,
    },
  },
}
