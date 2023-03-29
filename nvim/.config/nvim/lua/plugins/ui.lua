return {
  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    -- keys = {
    --   {
    --     "<leader>un",
    --     function()
    --       require("notify").dismiss({ silent = true, pending = true })
    --     end,
    --     desc = "Delete all Notifications",
    --   },
    -- },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require("core.util")
      if not Util.has_plugin("noice.nvim") then
        Util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    -- keys = {
    --   { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    --   { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    -- },
    opts = {
      options = {
        show_close_icon = false, --default: true
        separator_style = "slant", -- | "thick" | "slant" | default: "thin" | "padded_slant"  | { 'any', 'any' }
        -- enforce_regular_tabs = true, -- default: false
        max_name_length = 30, -- default 18
        max_prefix_length = 30, -- prefix used when a buffer is de-duplicated, default 15
        tab_size = 21, -- default 18
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-Tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(plugin)
      -- TODO:
      -- -- Show shiftwidth length
      -- local spaces = function()
      --     return " " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
      -- end
      --
      -- -- Show if formatting on save is enabled
      -- local autoformat = function()
      --     return vim.g.autoformat_status
      -- end
      --
      -- local hide_in_width = function()
      --     return vim.o.columns > 80
      -- end
      --
      -- -- thnaks chris@machine
      -- local language_server = {
      --     function()
      --         local buf_ft = vim.bo.filetype
      --         local ui_filetypes = {
      --             "help",
      --             "packer",
      --             "neogitstatus",
      --             "NvimTree",
      --             "Trouble",
      --             "lir",
      --             "Outline",
      --             "spectre_panel",
      --             "toggleterm",
      --             "DressingSelect",
      --             "TelescopePrompt",
      --             "lspinfo",
      --             "lsp-installer",
      --             "",
      --         }
      --
      --         if vim.tbl_contains(ui_filetypes, buf_ft) then
      --             if M.language_servers == nil then
      --                 return ""
      --             else
      --                 -- NEED M
      --                 return M.language_servers
      --             end
      --         end
      --
      --         local clients = vim.lsp.buf_get_clients()
      --         local client_names = {}
      --
      --         -- add client
      --         for _, client in pairs(clients) do
      --             if client.name ~= "null-ls" then
      --                 table.insert(client_names, client.name)
      --             end
      --         end
      --
      --         -- add formatter
      --         local s = require "null-ls.sources"
      --         local available_sources = s.get_available(buf_ft)
      --         local registered = {}
      --         for _, source in ipairs(available_sources) do
      --             for method in pairs(source.methods) do
      --                 registered[method] = registered[method] or {}
      --                 table.insert(registered[method], source.name)
      --             end
      --         end
      --
      --         local formatter = registered["NULL_LS_FORMATTING"]
      --         local linter = registered["NULL_LS_DIAGNOSTICS"]
      --         if formatter ~= nil then
      --             vim.list_extend(client_names, formatter)
      --         end
      --         if linter ~= nil then
      --             vim.list_extend(client_names, linter)
      --         end
      --
      --         -- join client names with commas
      --         local client_names_str = table.concat(client_names, ", ")
      --
      --         -- check client_names_str if empty
      --         local language_servers = ""
      --         local client_names_str_len = #client_names_str
      --         if client_names_str_len ~= 0 then
      --             language_servers = "LSP: " .. client_names_str .. ""
      --         end
      --
      --         if client_names_str_len == 0 then
      --             return ""
      --         else
      --             M.language_servers = language_servers
      --             return language_servers:gsub(", anonymous source", "")
      --         end
      --     end,
      --     -- padding = 0,
      --     cond = hide_in_width,
      --     component_separators = "",
      -- }
      --
      -- local move_to_the_middle = {
      --     function()
      --         return "%="
      --     end,
      --     component_separators = "",
      -- }

      -------------------------------------------------------------------------

      -- local icons = require("lazyvim.config").icons
      -- local function fg(name)
      --   return function()
      --     ---@type {foreground?:number}?
      --     local hl = vim.api.nvim_get_hl_by_name(name, true)
      --     return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
      --   end
      -- end

      return {
        options = {
          theme = "auto",
          -- component_separators = { left = "", right = "" },
          -- section_separators = { left = "", right = "" },
          -- component_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          -- component_separators = { " ", " " },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
          disabled_filetypes = { statusline = { "lazy" } },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            -- TODO:
            -- lualine_c = { move_to_the_middle, language_server },
            -- lualine_c = {},
            -- lualine_x = { "encoding", spaces, "fileformat", "filetype", autoformat },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        -- sections = {
        --   lualine_a = { "mode" },
        --   lualine_b = { "branch" },
        --   lualine_c = {
        --     {
        --       "diagnostics",
        --       symbols = {
        --         error = icons.diagnostics.Error,
        --         warn = icons.diagnostics.Warn,
        --         info = icons.diagnostics.Info,
        --         hint = icons.diagnostics.Hint,
        --       },
        --     },
        --     { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        --     { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        --     -- stylua: ignore
        --     {
        --       function() return require("nvim-navic").get_location() end,
        --       cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
        --     },
        --   },
        --   lualine_x = {
        --     -- stylua: ignore
        --     {
        --       function() return require("noice").api.status.command.get() end,
        --       cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
        --       color = fg("Statement")
        --     },
        --     -- stylua: ignore
        --     {
        --       function() return require("noice").api.status.mode.get() end,
        --       cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
        --       color = fg("Constant") ,
        --     },
        --     { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
        --     {
        --       "diff",
        --       symbols = {
        --         added = icons.git.added,
        --         modified = icons.git.modified,
        --         removed = icons.git.removed,
        --       },
        --     },
        --   },
        --   lualine_y = {
        --     { "progress", separator = " ", padding = { left = 1, right = 0 } },
        --     { "location", padding = { left = 0, right = 1 } },
        --   },
        --   lualine_z = {
        --     function()
        --       return " " .. os.date("%R")
        --     end,
        --   },
        -- },
        extensions = { "neo-tree", "quickfix", "toggleterm" },
      }
    end,
  },

  -- indent guides for Neovim
  {
      "lukas-reineke/indent-blankline.nvim",
      event = { "BufReadPost", "BufNewFile" },
      opts = function(plugin)
          -- Next lines add the ↲ sign at the EOL
          vim.opt.list = true
          -- vim.opt.listchars:append "space:⋅"
          -- vim.opt.listchars:append "space:"
          -- vim.opt.listchars:append ("eol:↴")
          -- vim.opt.listchars:append ("eol:﬋")
          -- vim.opt.listchars:append ("eol:⤶")
          vim.opt.listchars:append "eol:↲"
          -- To set or unset the char for a trailing space (default is "trail:-")
          vim.opt.listchars:append "trail: " -- currently it's unset
          return {
              char = "▏",
              -- char = "│",
              filetype_exclude = {
                  "help",
                  "man",
                  "checkhealth",
                  "lazy",
                  "lspinfo",
                  "neo-tree",
                  "neogitstatus",
                  "undotree",
                  "Trouble",
                  "alpha",
                  "dashboard",
                  "mason",
              },
              show_trailing_blankline_indent = false,
              show_current_context = false,
              show_end_of_line = true,
          }
      end,
  },

  -- active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "▏",
      -- symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },

  -- SOMEDAY: in case I want to replace the command line with a ui
  -- noicer ui
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     lsp = {
  --       override = {
  --         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --         ["vim.lsp.util.stylize_markdown"] = true,
  --       },
  --     },
  --     presets = {
  --       bottom_search = true,
  --       command_palette = true,
  --       long_message_to_split = true,
  --     },
  --   },
  --   -- stylua: ignore
  --   keys = {
  --     { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
  --     { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
  --     { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
  --     { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
  --     { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
  --     { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
  --   },
  -- },

  -- SOMEDAY: ?
  -- dashboard
  -- {
  --   "goolord/alpha-nvim",
  --   event = "VimEnter",
  --   opts = function()
  --     local dashboard = require("alpha.themes.dashboard")
  --     local logo = [[
  --     ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
  --     ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z
  --     ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z
  --     ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z
  --     ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
  --     ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
  --     ]]
  --
  --     dashboard.section.header.val = vim.split(logo, "\n")
  --     dashboard.section.buttons.val = {
  --       dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
  --       dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
  --       dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
  --       dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
  --       dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
  --       dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
  --       dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
  --       dashboard.button("q", " " .. " Quit", ":qa<CR>"),
  --     }
  --     for _, button in ipairs(dashboard.section.buttons.val) do
  --       button.opts.hl = "AlphaButtons"
  --       button.opts.hl_shortcut = "AlphaShortcut"
  --     end
  --     dashboard.section.header.opts.hl = "AlphaHeader"
  --     dashboard.section.buttons.opts.hl = "AlphaButtons"
  --     dashboard.section.footer.opts.hl = "AlphaFooter"
  --     dashboard.opts.layout[1].val = 8
  --     return dashboard
  --   end,
  --   config = function(_, dashboard)
  --     -- close Lazy and re-open when the dashboard is ready
  --     if vim.o.filetype == "lazy" then
  --       vim.cmd.close()
  --       vim.api.nvim_create_autocmd("User", {
  --         pattern = "AlphaReady",
  --         callback = function()
  --           require("lazy").show()
  --         end,
  --       })
  --     end
  --
  --     require("alpha").setup(dashboard.opts)
  --
  --     vim.api.nvim_create_autocmd("User", {
  --       pattern = "LazyVimStarted",
  --       callback = function()
  --         local stats = require("lazy").stats()
  --         local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  --         dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
  --         pcall(vim.cmd.AlphaRedraw)
  --       end,
  --     })
  --   end,
  -- },

  -- TODO: setup navic
  -- lsp symbol navigation for lualine
  -- {
  --   "SmiteshP/nvim-navic",
  --   lazy = true,
  --   init = function()
  --     vim.g.navic_silence = true
  --     require("lazyvim.util").on_attach(function(client, buffer)
  --       if client.server_capabilities.documentSymbolProvider then
  --         require("nvim-navic").attach(client, buffer)
  --       end
  --     end)
  --   end,
  --   opts = function()
  --     return {
  --       separator = " ",
  --       highlight = true,
  --       depth_limit = 5,
  --       icons = require("lazyvim.config").icons.kinds,
  --     }
  --   end,
  -- },


  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
}
