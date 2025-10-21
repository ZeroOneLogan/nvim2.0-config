local M = {}

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

function M.setup()
  map("n", "<leader>qq", vim.cmd.qall, "Quit all")
  map("n", "<leader>ww", vim.cmd.write, "Save file")

  map("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
  end, "Find files")
  map("n", "<leader>fg", function()
    require("telescope.builtin").live_grep()
  end, "Live grep")
  map("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
  end, "List buffers")
  map("n", "<leader>fh", function()
    require("telescope.builtin").help_tags()
  end, "Help tags")

  map("n", "<leader>e", function()
    local ok = pcall(vim.cmd, "Neotree toggle")
    if not ok then
      vim.notify("Explorer disabled", vim.log.levels.WARN)
    end
  end, "Toggle explorer")

  map("n", "<leader>o", function()
    local ok = pcall(vim.cmd, "AerialToggle")
    if not ok then
      vim.notify("Outline disabled", vim.log.levels.WARN)
    end
  end, "Toggle outline")

  map("n", "<leader>xx", function()
    local ok, trouble = pcall(require, "trouble")
    if ok then
      trouble.toggle()
    else
      vim.notify("Trouble not available", vim.log.levels.WARN)
    end
  end, "Toggle Trouble")
  map("n", "<leader>xq", vim.diagnostic.setloclist, "Send diagnostics to loclist")

  map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

  map("n", "<leader>tt", function()
    local ok = pcall(vim.cmd, "ToggleTerm")
    if not ok then
      vim.notify("ToggleTerm not available", vim.log.levels.WARN)
    end
  end, "Toggle terminal")

  map("t", "<Esc>", [[<C-\><C-n>]], "Leave terminal")

  map("n", "<leader>up", function()
    require("user.commands").open_prefs()
  end, "Open preferences")
end

return M
