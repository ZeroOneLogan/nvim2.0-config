local util = require("user.util")

local enabled = util.profile_is("Full-IDE")

return {
  {
    "mfussenegger/nvim-dap",
    enabled = enabled,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      require("dap.init").setup()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    enabled = enabled,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    enabled = enabled,
    opts = {},
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = enabled,
    opts = {
      ensure_installed = { "python", "js" },
      handlers = {},
      automatic_installation = false,
    },
  },
}
