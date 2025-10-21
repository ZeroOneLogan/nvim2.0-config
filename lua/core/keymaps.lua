-- Global keymaps
local map = require("core.util").map

map({ "n", "v" }, "<Space>", "<Nop>", { desc = "Leader noop" })

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to alternate file" })

map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]])

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>do", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>dl", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)", silent = true })

map("n", "<leader>fn", function()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then return end
  vim.fn.setreg("+", path)
  vim.notify("Copied file path to clipboard", vim.log.levels.INFO, { title = "nvim2.0" })
end, { desc = "Copy current file path" })
