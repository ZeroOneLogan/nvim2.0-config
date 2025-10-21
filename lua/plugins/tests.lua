local util = require("user.util")

if not util.is_enabled("tests") then
  return {}
end

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "haydenmeade/neotest-jest",
      "nvim-neotest/neotest-go",
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
          }),
          require("neotest-go")({
            experimental = { test_table = true },
            args = { "-count=1" },
          }),
        },
      })

      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
      end
      map("<leader>tn", function()
        neotest.run.run()
      end, "Run nearest test")
      map("<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, "Run file tests")
      map("<leader>ts", neotest.summary.toggle, "Toggle test summary")
      map("<leader>to", neotest.output.open, "Open test output")
    end,
  },
}
