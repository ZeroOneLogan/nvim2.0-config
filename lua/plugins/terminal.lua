local prefs = require("user.prefs")

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      shade_terminals = false,
      persist_size = true,
      direction = "float",
      float_opts = { border = "rounded" },
    },
  },
  {
    "ojroques/nvim-osc52",
    enabled = prefs.values.osc52,
    event = "TextYankPost",
    config = function()
      local osc52 = require("osc52")
      osc52.setup({ trim = true })
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
            osc52.copy_register("+")
          end
        end,
      })
    end,
  },
}
