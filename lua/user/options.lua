local M = {}

function M.setup()
  local opt = vim.opt

  opt.backup = false
  opt.clipboard = "unnamedplus"
  opt.completeopt = { "menu", "menuone", "noselect" }
  opt.conceallevel = 2
  opt.cursorline = true
  opt.expandtab = true
  opt.foldlevel = 99
  opt.foldlevelstart = 99
  opt.foldenable = true
  opt.ignorecase = true
  opt.smartcase = true
  opt.number = true
  opt.relativenumber = true
  opt.mouse = "a"
  opt.shiftwidth = 2
  opt.tabstop = 2
  opt.smartindent = true
  opt.splitbelow = true
  opt.splitright = true
  opt.termguicolors = true
  opt.timeoutlen = 300
  opt.updatetime = 200
  opt.signcolumn = "yes"
  opt.undofile = true
  opt.list = true
  opt.listchars = { tab = "» ", trail = "·", extends = "›", precedes = "‹", nbsp = "␣" }
  opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldclose = "", foldsep = " " }

  local prefs = require("user.prefs").values
  vim.diagnostic.config({
    virtual_text = prefs.diagnostics_virtual_text and {
      prefix = "●",
    } or false,
    float = { border = "rounded", source = "if_many" },
    severity_sort = true,
    signs = true,
  })

  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

return M
