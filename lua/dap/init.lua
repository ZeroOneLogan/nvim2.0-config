local M = {}

local function register_keymaps(dap, toggle_ui)
  if M._keymaps_registered then
    return
  end
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
  end
  map("<leader>db", dap.toggle_breakpoint, "Toggle breakpoint")
  map("<leader>dc", dap.continue, "Continue")
  map("<leader>do", dap.step_over, "Step over")
  map("<leader>di", dap.step_into, "Step into")
  map("<leader>du", toggle_ui, "Toggle DAP UI")
  M._keymaps_registered = true
end

local function ensure_listeners(dap, dapui)
  if not dapui then
    return
  end
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

local function configure_stubs(dap)
  dap.adapters = dap.adapters or {}
  dap.configurations = dap.configurations or {}

  local python_command = vim.g.python3_host_prog or "python"
  dap.adapters.python = dap.adapters.python
    or { type = "executable", command = python_command, args = { "-m", "debugpy.adapter" } }

  local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
  dap.adapters["pwa-node"] = dap.adapters["pwa-node"]
    or {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = { js_debug_path, "${port}" },
      },
    }
end

function M.setup()
  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then
    return
  end

  configure_stubs(dap)

  local dapui
  local dapui_ok
  dapui_ok, dapui = pcall(require, "dapui")
  if dapui_ok then
    dapui.setup()
  end

  local vt_ok, vt = pcall(require, "nvim-dap-virtual-text")
  if vt_ok then
    vt.setup()
  end

  local mnd_ok, mason_dap = pcall(require, "mason-nvim-dap")
  if mnd_ok then
    mason_dap.setup({ ensure_installed = { "python", "js" }, automatic_installation = true, handlers = {} })
  end

  local function toggle_ui()
    if dapui_ok then
      dapui.toggle({ reset = true })
    else
      vim.notify_once("nvim-dap-ui is not available", vim.log.levels.WARN)
    end
  end

  ensure_listeners(dap, dapui_ok and dapui or nil)
  register_keymaps(dap, toggle_ui)
end

return M
