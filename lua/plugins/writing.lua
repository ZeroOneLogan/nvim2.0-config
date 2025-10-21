local util = require("user.util")

if not util.profile_is("Writing") then
  return {}
end

return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = { backdrop = 0.9, width = 0.7 },
    },
  },
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    opts = {},
  },
  {
    "preservim/vim-markdown",
    ft = { "markdown" },
  },
}
