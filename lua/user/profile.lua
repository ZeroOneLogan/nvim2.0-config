local prefs = require("user.prefs")

local M = {}

M.presets = {
  ["Minimal"] = {
    profile = "Minimal",
    tests = false,
    outline = false,
    project = false,
    ufo = false,
    alpha = false,
    statuscol = false,
  },
  ["Full-IDE"] = {
    profile = "Full-IDE",
    tests = true,
    outline = true,
    project = true,
    ufo = true,
    alpha = false,
    statuscol = false,
  },
  ["Writing"] = {
    profile = "Writing",
    tests = false,
    outline = true,
    project = false,
    ufo = false,
    alpha = false,
    explorer = "neo-tree",
  },
}

function M.apply_startup(profile)
  local preset = M.presets[profile]
  if not preset then
    return
  end
  prefs.update(vim.tbl_deep_extend("force", {}, preset))
end

function M.set_profile(profile)
  local preset = M.presets[profile]
  if not preset then
    vim.notify("Unknown profile: " .. profile, vim.log.levels.ERROR)
    return
  end
  local new_values = vim.tbl_deep_extend("force", {}, prefs.values, preset, { profile = profile })
  prefs.update(new_values)
  local ok, path = prefs.write(new_values)
  if not ok then
    vim.notify("Failed to persist prefs to " .. path, vim.log.levels.ERROR)
    return
  end
  vim.notify("Profile switched to " .. profile .. ". Refreshing plugins…", vim.log.levels.INFO)
  require("lazy").sync()
  vim.defer_fn(function()
    require("ui.theme").load()
  end, 100)
end

function M.available()
  local keys = {}
  for name in pairs(M.presets) do
    table.insert(keys, name)
  end
  table.sort(keys)
  return keys
end

return M
