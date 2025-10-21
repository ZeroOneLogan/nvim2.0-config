local fs = vim.fs or {}

local function joinpath(...)
  local join = fs.joinpath
  if join then
    return join(...)
  end
  local parts = { ... }
  return table.concat(parts, "/")
end

local function dirname(path)
  if fs.dirname then
    return fs.dirname(path)
  end
  return path:match("(.+)/[^/]+$")
end

local defaults = {
  theme = "catppuccin",
  profile = "Full-IDE",
  osc52 = true,
  explorer = "neo-tree",
  outline = true,
  tests = true,
  ai = false,
  alpha = true,
  project = true,
  ufo = true,
  statuscol = false,
  transparency = 0,
  diagnostics_virtual_text = true,
  format_on_save = true,
  providers = {
    python = false,
    ruby = false,
    python_host = nil,
    ruby_host = nil,
  },
}

local function persist_path()
  return joinpath(vim.fn.stdpath("config"), "lua", "user", "prefs.local.lua")
end

local function load_persisted()
  local ok, persisted = pcall(dofile, persist_path())
  if not ok then
    if persisted and not persisted:match("No such file or directory") then
      vim.notify_once("Nvim2 prefs: failed to load overrides – " .. persisted, vim.log.levels.WARN)
    end
    return {}
  end
  if type(persisted) ~= "table" then
    vim.notify_once("Nvim2 prefs: overrides file must return a table", vim.log.levels.WARN)
    return {}
  end
  return persisted
end

local M = {}

M.values = vim.tbl_deep_extend("force", {}, defaults, load_persisted())

function M.defaults()
  return vim.deepcopy(defaults)
end

function M.persist_path()
  return persist_path()
end

function M.update(opts)
  if not opts then
    return M.values
  end
  M.values = vim.tbl_deep_extend("force", M.values, opts)
  return M.values
end

local function serialize_table(tbl)
  local keys = vim.tbl_keys(tbl)
  table.sort(keys)
  local lines = {"return {"}
  for _, key in ipairs(keys) do
    local value = tbl[key]
    if type(value) == "string" then
      table.insert(lines, string.format("  %s = %q,", key, value))
    else
      table.insert(lines, string.format("  %s = %s,", key, vim.inspect(value)))
    end
  end
  table.insert(lines, "}")
  return table.concat(lines, "\n")
end

function M.write(values)
  values = values or M.values
  local path = persist_path()
  local dir = dirname(path)
  if dir then
    vim.fn.mkdir(dir, "p")
  end
  local ok = vim.fn.writefile(vim.split(serialize_table(values), "\n"), path) == 0
  if ok then
    M.values = vim.tbl_deep_extend("force", {}, defaults, values)
  end
  return ok, path
end

function M.reset()
  local path = persist_path()
  if vim.uv.fs_stat(path) then
    vim.fn.delete(path)
  end
  M.values = vim.deepcopy(defaults)
  return M.values
end

return M
