local M = {}

function M.prefs()
  return require("user.prefs").values
end

function M.is_enabled(key)
  local prefs = M.prefs()
  local value = prefs[key]
  if value == nil then
    return false
  end
  return value
end

function M.profile()
  return M.prefs().profile
end

function M.profile_is(name)
  return M.profile() == name
end

function M.safe_require(mod)
  local ok, result = pcall(require, mod)
  if not ok then
    vim.notify(string.format("Failed to load %s: %s", mod, result), vim.log.levels.WARN)
    return nil
  end
  return result
end

function M.create_augroup(name)
  return vim.api.nvim_create_augroup("Nvim2" .. name, { clear = true })
end

function M.autocmd(event, opts)
  return vim.api.nvim_create_autocmd(event, opts)
end

function M.join_paths(...)
  return vim.fs.joinpath(...)
end

function M.file_exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

function M.in_project_root(names)
  local cwd = vim.uv.cwd() or vim.loop.cwd()
  for _, name in ipairs(names) do
    if M.file_exists(M.join_paths(cwd, name)) then
      return true
    end
  end
  return false
end

return M
