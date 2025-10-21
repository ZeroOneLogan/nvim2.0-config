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
    event = { "ColorScheme", "VeryLazy" },
    enabled = function()
      if not vim.go.termguicolors then
        return false
      end
      local prefs = require("user.prefs").values
      local ui = prefs.ui or {}
      return ui.smear_cursor ~= false
    end,
    opts = {
      cursor_color = "auto",
      stiffness = 0.8,
      trail_length = 0.1,
    },
    config = function(_, opts)
      local configured = false

      local function normalize_hex(value)
        if type(value) == "number" then
          if value < 0 then
            return nil
          end
          return string.format("#%06X", value % 0x1000000)
        elseif type(value) == "string" then
          local trimmed = value:gsub("^#", "")
          if trimmed == "" then
            return nil
          end
          local upper = trimmed:upper()
          if upper == "NONE" then
            return nil
          end
          if #trimmed == 3 and trimmed:match("^[0-9A-Fa-f]+$") then
            local r, g, b = trimmed:sub(1, 1), trimmed:sub(2, 2), trimmed:sub(3, 3)
            return ("#%s%s%s"):format((r .. r):upper(), (g .. g):upper(), (b .. b):upper())
          end
          if #trimmed >= 6 and trimmed:match("^[0-9A-Fa-f]+$") then
            return "#" .. upper:sub(1, 6)
          end
        end
        return nil
      end

      local function extract_color(group, attr)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if not ok or type(hl) ~= "table" then
          return nil, false
        end
        local value = hl[attr]
        if value == nil then
          return nil, false
        end
        if type(value) == "string" then
          local upper = value:upper()
          if upper == "NONE" then
            return nil, true
          end
        end
        local hex = normalize_hex(value)
        if hex then
          return hex, false
        end
        return nil, false
      end

      local function pick_color(group, attr)
        local color, explicit_none = extract_color(group, attr)
        if color then
          return color, false
        end
        if group ~= "Normal" then
          local fallback_color, fallback_none = pick_color("Normal", attr)
          if fallback_color then
            return fallback_color, false
          end
          if fallback_none and attr == "bg" then
            return nil, true
          end
          return "#FFFFFF", false
        end
        if explicit_none and attr == "bg" then
          return nil, true
        end
        return "#FFFFFF", false
      end

      local function safe_get_hl_color(group, attr)
        local color, explicit_none = pick_color(group, attr)
        if explicit_none and attr ~= "bg" then
          return "#FFFFFF"
        end
        return color
      end

      local function safe_hex_to_rgb(hex)
        local normalized = normalize_hex(hex)
        if not normalized then
          return 255, 255, 255
        end
        local clean = normalized:sub(2)
        local r = tonumber(clean:sub(1, 2), 16) or 255
        local g = tonumber(clean:sub(3, 4), 16) or 255
        local b = tonumber(clean:sub(5, 6), 16) or 255
        return r, g, b
      end

      local function replace_upvalue(fn, name, new_fn)
        if type(fn) ~= "function" then
          return
        end
        local i = 1
        while true do
          local up_name = debug.getupvalue(fn, i)
          if up_name == nil then
            break
          end
          if up_name == name then
            debug.setupvalue(fn, i, new_fn)
            break
          end
          i = i + 1
        end
      end

      local function patch_plugin_modules()
        local ok_color, color = pcall(require, "smear_cursor.color")
        if ok_color and type(color) == "table" and not color._nvim2_safe_colors then
          color._nvim2_safe_colors = true
          replace_upvalue(color.get_hl_group, "get_hl_color", safe_get_hl_color)
          replace_upvalue(color.get_color_at_cursor, "get_hl_color", safe_get_hl_color)
          replace_upvalue(color.update_color_at_cursor, "get_hl_color", safe_get_hl_color)
          replace_upvalue(color.get_hl_group, "hex_to_rgb", safe_hex_to_rgb)
        end

        local ok_events, events = pcall(require, "smear_cursor.events")
        if ok_events and type(events) == "table" and not events._nvim2_safe_wrapped then
          events._nvim2_safe_wrapped = true
          local function wrap(name)
            local fn = events[name]
            if type(fn) ~= "function" then
              return
            end
            events[name] = function(...)
              local ok = pcall(fn, ...)
              if not ok then
                return
              end
            end
          end
          wrap("move_cursor")
          wrap("update_color_at_cursor")
        end
      end

      local function configure()
        if configured then
          return
        end
        configured = true
        patch_plugin_modules()
        local ok, smear = pcall(require, "smear_cursor")
        if not ok or type(smear) ~= "table" or type(smear.setup) ~= "function" then
          return
        end
        smear.setup(opts)
      end

      if vim.g.colors_name == nil then
        vim.api.nvim_create_autocmd("ColorScheme", {
          once = true,
          callback = function()
            vim.schedule(configure)
          end,
        })
      else
        vim.schedule(configure)
      end
    end,
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
