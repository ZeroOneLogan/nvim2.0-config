return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = false,
        treesitter = true,
        telescope = true,
        notify = true,
        noice = true,
        which_key = true,
        indent_blankline = {
          enabled = true,
          scope_color = "lavender",
          colored_indent_levels = false,
        },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    priority = 999,
    opts = {
      style = "night",
      transparent = false,
      styles = { sidebars = "dark", floats = "dark" },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override_by_extension = {
        astro = { icon = "", color = "#FF7E33", name = "Astro" },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local theme = require("ui.theme").current()
      local ok, lualine_theme = pcall(require, "lualine.themes." .. theme)
      if not ok then lualine_theme = "auto" end
      return {
        options = {
          theme = lualine_theme,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            { "diagnostics", sources = { "nvim_diagnostic" } },
            { "filename", path = 1, newfile_status = true },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "neo-tree", "quickfix", "trouble" },
      }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = false,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        operators = false,
        motions = false,
      },
      icons = {
        separator = "➜",
      },
      win = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>t"] = { name = "+toggle" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>d"] = { name = "+diagnostics" },
        ["<leader>l"] = { name = "+lsp" },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { show_start = false, show_end = false },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "stevearc/dressing.nvim",
    },
    opts = {
      cmdline = {
        view = "cmdline_popup",
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      lsp = {
        progress = { enabled = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      background_colour = "#000000",
      fps = 60,
      render = "compact",
      timeout = 3000,
      stages = "fade_in_slide_out",
    },
    init = function()
      if #vim.api.nvim_list_uis() == 0 then
        return
      end
      vim.notify = require("notify")
    end,
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {},
  },
}
