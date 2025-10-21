return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = require("core.util").map
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(gs.next_hunk)
          return "<Ignore>"
        end, { buffer = bufnr, expr = true })
        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(gs.prev_hunk)
          return "<Ignore>"
        end, { buffer = bufnr, expr = true })
        map({ "n", "v" }, "<leader>gr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
        map({ "n", "v" }, "<leader>gs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
        map("n", "<leader>gS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
        map("n", "<leader>gu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
        map("n", "<leader>gp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { buffer = bufnr, desc = "Blame line" })
        map("n", "<leader>gd", gs.diffthis, { buffer = bufnr, desc = "Diff this" })
        map("n", "<leader>gD", function() gs.diffthis("~") end, { buffer = bufnr, desc = "Diff previous" })
      end,
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git status (fugitive)" },
    },
  },
}
