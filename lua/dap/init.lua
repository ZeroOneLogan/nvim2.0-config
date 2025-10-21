local M = {}

local function keymaps()
  local dap = require("dap")
  local dapui = require("dapui")
  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
  end
  map("<leader>db", dap.toggle_breakpoint, "Toggle breakpoint")
  map("<leader>dc", dap.continue, "Continue")
  map("<leader>do", dap.step_over, "Step over")
  map("<leader>di", dap.step_into, "Step into")
  map("<leader>du", function()
    dapui.toggle({ reset = true })
  end, "Toggle DAP UI")
end

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")
  dapui.setup()
  require("nvim-dap-virtual-text").setup()

  keymaps()

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

return M
