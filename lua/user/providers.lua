local M = {}

local function executable(cmd)
  if not cmd or cmd == "" then
    return false
  end
  return vim.fn.executable(cmd) == 1
end

local function resolve_command(command, fallback)
  if type(command) == "string" and command ~= "" then
    return command
  end
  return fallback
end

local function provider_status()
  local prefs = require("user.prefs").values
  local configured = prefs.providers or {}

  local status = {
    python = {
      enabled = configured.python == true,
      host = resolve_command(configured.python_host, vim.g.python3_host_prog),
      available = false,
      install = "pipx install pynvim",
    },
    ruby = {
      enabled = configured.ruby == true,
      host = resolve_command(configured.ruby_host, vim.g.ruby_host_prog),
      available = false,
      install = "gem install neovim",
    },
  }

  if not status.python.enabled then
    vim.g.loaded_python3_provider = 0
  else
    if type(status.python.host) == "string" and status.python.host ~= "" then
      vim.g.python3_host_prog = status.python.host
    end
    local host = resolve_command(status.python.host, "python3")
    status.python.host = host
    status.python.available = executable(host)
  end

  if not status.ruby.enabled then
    vim.g.loaded_ruby_provider = 0
  else
    local host = resolve_command(status.ruby.host, "ruby")
    status.ruby.host = host
    status.ruby.available = executable(host)
  end

  vim.g.loaded_perl_provider = 0

  return status
end

function M.setup()
  M._status = provider_status()
end

function M.status()
  if not M._status then
    M._status = provider_status()
  end
  return M._status
end

return M
