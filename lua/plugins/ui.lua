local prefs = require("user.prefs")

return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = {
        telescope = true,
        which_key = true,
        neotree = true,
        cmp = true,
        lsp_trouble = true,
        dap = true,
        gitsigns = true,
        neotest = true,
        mini = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = { style = "night" },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return {
        options = {
          theme = prefs.values.theme,
          globalstatus = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "|", right = "|" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "diagnostics", "diff", "encoding", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "PanelHeading",
            separator = true,
          },
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      stages = "fade",
      timeout = 3000,
      render = "compact",
    },
    init = function()
      vim.notify = require("notify")
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      lsp = {
        progress = { enabled = true },
        signature = { enabled = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "goolord/alpha-nvim",
    enabled = prefs.values.alpha,
    event = "VimEnter",
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        " ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        " ████╗  ██║██║   ██║██║████╗ ████║",
        " ██╔██╗ ██║██║   ██║██║██╔████╔██║",
        " ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        " ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "󰄉  Recent", ":Telescope oldfiles<CR>"),
        dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      require("alpha").setup(dashboard.config)
    end,
  },
  {
    "szw/vim-maximizer",
    cmd = "MaximizerToggle",
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VeryLazy",
    opts = {
      theme = "doom",
      config = {
        header = {
          "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
          "████╗  ██║██║   ██║██║████╗ ████║",
          "██╔██╗ ██║██║   ██║██║██╔████╔██║",
          "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
          "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
        },
        center = {
          { action = "Telescope find_files", desc = "Find files", icon = " " },
          { action = "Telescope live_grep", desc = "Live grep", icon = "󰱼 " },
          { action = "ene | startinsert", desc = "New file", icon = " " },
        },
        footer = function()
          return { "Welcome back to Nvim2" }
        end,
      },
    },
  },
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = {
      cursor = { enable = true },
      resize = { enable = true },
      scroll = { enable = false },
    },
  },
  {
    "echasnovski/mini.starter",
    event = "VeryLazy",
    opts = {
      autoopen = false,
      header = [[   _   _       _            
  | \ | | ___ | |_ ___ _ __ 
  |  \| |/ _ \| __/ _ \ '__|
  | |\  | (_) | ||  __/ |   
  |_| \_|\___/ \__\___|_|   
]],
    },
    config = function(_, opts)
      local starter = require("mini.starter")
      starter.setup(opts)
    end,
  },
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      cursor_color = "auto",
      stiffness = 0.8,
      trail_length = 0.1,
    },
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      animate = {
        enabled = false,
      },
      bottom = {
        { ft = "toggleterm", title = "Terminal", size = { height = 0.35 } },
        { ft = "qf", title = "QuickFix", size = { height = 0.25 } },
      },
      left = {
        { ft = "neo-tree", title = "Explorer", size = { width = 30 } },
      },
      right = {
        { ft = "aerial", title = "Outline", size = { width = 32 } },
      },
    },
  },
}
