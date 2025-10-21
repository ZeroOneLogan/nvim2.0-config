local M = {}

function M.setup()
  local lint = require("lint")
  lint.linters_by_ft = {
    python = { "ruff" },
    markdown = { "markdownlint" },
    yaml = { "yamllint" },
  }

  local group = vim.api.nvim_create_augroup("Nvim2Lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = group,
    callback = function()
      lint.try_lint()
    end,
  })
end

return M
