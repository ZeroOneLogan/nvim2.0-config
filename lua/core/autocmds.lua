-- Autocommands for nvim2.0
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("nvim2_highlight_yank", { clear = true })
autocmd("TextYankPost", {
  group = "nvim2_highlight_yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

augroup("nvim2_resize_splits", { clear = true })
autocmd("VimResized", {
  group = "nvim2_resize_splits",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

augroup("nvim2_last_loc", { clear = true })
autocmd("BufReadPost", {
  group = "nvim2_last_loc",
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close certain buffers with q
augroup("nvim2_close_with_q", { clear = true })
autocmd("FileType", {
  group = "nvim2_close_with_q",
  pattern = {
    "help",
    "lspinfo",
    "man",
    "spectre_panel",
    "git",
    "checkhealth",
    "qf",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

augroup("nvim2_wrap_spell", { clear = true })
autocmd("FileType", {
  group = "nvim2_wrap_spell",
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
