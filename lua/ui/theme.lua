local prefs = require("user.prefs")

local M = {}

local fallbacks = { "tokyonight", "habamax" }

function M.load()
  local theme = prefs.values.theme or "catppuccin"
  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if not ok then
    vim.notify(string.format("Failed to load %s: %s", theme, err), vim.log.levels.WARN)
    for _, fallback in ipairs(fallbacks) do
      if pcall(vim.cmd.colorscheme, fallback) then
        theme = fallback
        break
      end
    end
  end
  if prefs.values.transparency and prefs.values.transparency > 0 then
    local groups = { "Normal", "NormalFloat", "SignColumn" }
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
  end
  return theme
end

return M
