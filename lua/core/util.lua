local M = {}

---Check whether a plugin is available.
---@param name string
---@return boolean
function M.has(name)
  return package.loaded[name] or require("lazy.core.config").plugins[name] ~= nil
end

---Convenience wrapper around vim.keymap.set with defaults.
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table?
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

---Return the lazy.nvim spec that imports every module in lua/plugins.
---@return table
function M.lazy_spec()
  return {
    { import = "plugins" },
  }
end

return M
