local util = require("user.util")

local M = {}

function M.setup()
  local augroup = util.create_augroup

  util.autocmd("TextYankPost", {
    group = augroup("HighlightYank"),
    callback = function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
  })

  util.autocmd({ "BufReadPost", "BufNewFile" }, {
    group = augroup("RestoreCursor"),
    callback = function(event)
      local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
      local lcount = vim.api.nvim_buf_line_count(event.buf)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })

  util.autocmd("VimResized", {
    group = augroup("ResizeSplits"),
    callback = function()
      vim.cmd("tabdo wincmd =")
    end,
  })

  util.autocmd("FileType", {
    group = augroup("CloseWithQ"),
    pattern = {
      "help",
      "lspinfo",
      "man",
      "qf",
      "checkhealth",
      "spectre_panel",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", function()
        vim.cmd.close()
      end, { buffer = event.buf, silent = true })
    end,
  })
end

return M
