local M = {}

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

function M.setup()
  map("n", "<leader>qq", vim.cmd.qall, "Quit all")
  map("n", "<leader>ww", vim.cmd.write, "Save file")
  map("n", "<leader>we", function()
    local ok = pcall(vim.cmd, "EdgyToggle")
    if not ok then
      vim.notify("Edgy is not available", vim.log.levels.WARN)
    end
  end, "Toggle Edgy layout")
  map("n", "<leader>wm", function()
    local ok = pcall(vim.cmd, "MaximizerToggle")
    if not ok then
      vim.notify("vim-maximizer not available", vim.log.levels.WARN)
    end
  end, "Toggle maximized window")
  map("n", "<leader>ws", vim.cmd.split, "Horizontal split")
  map("n", "<leader>wv", vim.cmd.vsplit, "Vertical split")
  map("n", "<leader>w=", function()
    vim.cmd("wincmd =")
  end, "Equalize window sizes")

  map("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
  end, "Find files")
  map("n", "<leader>fg", function()
    require("telescope.builtin").live_grep()
  end, "Live grep")
  map("n", "<leader>fs", function()
    require("telescope.builtin").grep_string()
  end, "Search string under cursor")
  map("n", "<leader>sd", function()
    require("telescope.builtin").diagnostics()
  end, "List diagnostics")
  map("n", "<leader>sb", function()
    require("telescope.builtin").current_buffer_fuzzy_find()
  end, "Search in buffer")
  map("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
  end, "List buffers")
  map("n", "<leader>fh", function()
    require("telescope.builtin").help_tags()
  end, "Help tags")

  map("n", "<leader>bd", function()
    vim.cmd.bdelete()
  end, "Close buffer")
  map("n", "<leader>bn", vim.cmd.bnext, "Next buffer")
  map("n", "<leader>bp", vim.cmd.bprevious, "Previous buffer")

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
  map("n", "<leader>ua", function()
    local ok = pcall(vim.cmd, "Alpha")
    if not ok then
      vim.notify("Alpha dashboard not available", vim.log.levels.WARN)
    end
  end, "Open Alpha dashboard")
  map("n", "<leader>ud", function()
    local ok = pcall(vim.cmd, "Dashboard")
    if not ok then
      vim.notify("Dashboard plugin not available", vim.log.levels.WARN)
    end
  end, "Open dashboard")
  map("n", "<leader>us", function()
    local ok, starter = pcall(require, "mini.starter")
    if ok then
      starter.open()
    else
      vim.notify("Mini Starter not available", vim.log.levels.WARN)
    end
  end, "Open Mini Starter")
  map("n", "<leader>?", function()
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.show("", { mode = "n" })
    else
      vim.notify("which-key not available", vim.log.levels.WARN)
    end
  end, "Show keymaps")
  map("v", "<leader>?", function()
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.show("", { mode = "v" })
    else
      vim.notify("which-key not available", vim.log.levels.WARN)
    end
  end, "Show keymaps (visual)")

  map("n", "<leader>Fr", function()
    local ok = pcall(vim.cmd, "FlutterRun")
    if not ok then
      vim.notify("Flutter tools not available", vim.log.levels.WARN)
    end
  end, "Flutter run")
  map("n", "<leader>FR", function()
    local ok = pcall(vim.cmd, "FlutterRestart")
    if not ok then
      vim.notify("Flutter tools not available", vim.log.levels.WARN)
    end
  end, "Flutter restart")
  map("n", "<leader>Fd", function()
    local ok = pcall(vim.cmd, "FlutterDevices")
    if not ok then
      vim.notify("Flutter tools not available", vim.log.levels.WARN)
    end
  end, "Flutter devices")
  map("n", "<leader>Fl", function()
    local ok = pcall(vim.cmd, "FlutterLogClear")
    if not ok then
      vim.notify("Flutter tools not available", vim.log.levels.WARN)
    end
  end, "Flutter clear logs")
end

return M
