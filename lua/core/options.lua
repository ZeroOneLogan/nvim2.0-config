-- Core editor options
local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

opt.backup = false
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = {
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 300
opt.undofile = true
opt.updatetime = 200
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.laststatus = 3
opt.mouse = "a"
opt.showmode = false
opt.pumheight = 10
opt.swapfile = false

-- Providers: disable unused ones for performance
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
  g["loaded_" .. provider .. "_provider"] = 0
end

-- Ensure proper file encodings
opt.fileencoding = "utf-8"

-- Reduce command history noise
opt.shortmess:append({ W = true, I = true, c = true })

-- Automatically detect terminal background for catppuccin/tokyonight
if vim.env.TERM_PROGRAM == "Apple_Terminal" then
  opt.background = "dark"
end
