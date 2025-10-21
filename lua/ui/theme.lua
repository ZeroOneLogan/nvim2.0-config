local M = {}

local default = "catppuccin"

function M.current()
  return vim.g.nvim2_theme or default
end

function M.load(name)
  name = name or M.current()
  local ok, _ = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.notify("Failed to load colorscheme " .. name .. ", falling back to habamax", vim.log.levels.WARN)
    vim.cmd.colorscheme("habamax")
  end
end

return M
