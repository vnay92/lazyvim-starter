-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  { "folke/trouble.nvim", enabled = false },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "vim",
        "yaml",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "gopls",
      },
    },
  },

  -- install minimap. Really cool stuff
  {
    "wfxr/minimap.vim",
    cmd = { "MinimapToggle", "MinimapRefresh", "MinimapClose" },
    config = function()
      vim.g.minimap_width = 10
      vim.g.minimap_auto_start = 1 -- Start automatically
      vim.g.minimap_auto_start_win_enter = 1
      vim.g.minimap_highlight_range = 1
      vim.g.minimap_git_colors = 1
      vim.g.minimap_base_highlight = "Normal"
      vim.g.minimap_block_filetypes = { "packer", "qf", "help", "nerdtree", "lazy" }

      -- Keybinding for Minimap Toggle
      vim.api.nvim_set_keymap("n", "<Leader>m", ":MinimapToggle<CR>", { noremap = true, silent = true })
    end,
  },

  -- git lens
  {
    "cosmicthemethhead/gitlens.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency
    event = "BufReadPre", -- Load when a file is opened
    config = function()
      require("gitlens").setup({
        ui = {
          logo = "",
        },
        disabled_filetypes = {},
        blame = {
          enabled = true,
          virtual_text = true, -- Show Git blame as virtual text
          hl_group = "Comment", -- Highlight as comments
        },
        hunk = {
          enabled = true,
          show_count = true,
        },
        current_line_blame = {
          enabled = true,
          delay = 500, -- 500ms delay before showing blame
        },
        signs = {
          add = "│",
          change = "│",
          delete = "󰍵",
        },
        mappings = {
          toggle_blame = "<Leader>gb",
          toggle_hunk = "<Leader>gh",
        },
      })

      -- Keybindings
      vim.api.nvim_set_keymap("n", "<Leader>gb", ":GitLensToggleBlame<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<Leader>gh", ":GitLensToggleHunk<CR>", { noremap = true, silent = true })
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapgo = require("dap-go")

      -- Setup dap-go
      dapgo.setup()

      -- Project-specific debug configurations
      dap.configurations.go = {
        {
          name = "Launch main.go",
          type = "go",
          request = "launch",
          mode = "auto",
          program = vim.fn.getcwd() .. "/main.go",
          args = {},
        },
        {
          name = "Start Server",
          type = "go",
          request = "launch",
          mode = "auto",
          program = vim.fn.getcwd() .. "/main.go",
          args = { "run" },
        },
        {
          name = "Start Jobs",
          type = "go",
          request = "launch",
          mode = "auto",
          program = vim.fn.getcwd() .. "/main.go",
          args = { "start-jobs" },
        },
        {
          name = "Run Migrations",
          type = "go",
          request = "launch",
          mode = "auto",
          program = vim.fn.getcwd() .. "/main.go",
          args = { "migrate", "up" },
        },
      }

      -- Setup UI
      require("dapui").setup()

      -- Virtual text for variables
      require("nvim-dap-virtual-text").setup({
        enabled = true, -- Show virtual text for variables
        highlight_changed_variables = true,
        show_stop_reason = true,
      })

      -- Automatically open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        require("dapui").close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
      end

      -- 🔥 Keybindings for Debugging
      vim.api.nvim_set_keymap("n", "<F5>", ":DapContinue<CR>", { noremap = true, silent = true }) -- Start debugging
      vim.api.nvim_set_keymap("n", "<F10>", ":DapStepOver<CR>", { noremap = true, silent = true }) -- Step over
      vim.api.nvim_set_keymap("n", "<F11>", ":DapStepInto<CR>", { noremap = true, silent = true }) -- Step into
      vim.api.nvim_set_keymap("n", "<F12>", ":DapStepOut<CR>", { noremap = true, silent = true }) -- Step out
      vim.api.nvim_set_keymap("n", "<Leader>b", ":DapToggleBreakpoint<CR>", { noremap = true, silent = true }) -- Toggle breakpoint
      vim.api.nvim_set_keymap(
        "n",
        "<Leader>B",
        ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
        { noremap = true, silent = true }
      ) -- Conditional breakpoint
      vim.api.nvim_set_keymap("n", "<Leader>dx", ":DapTerminate<CR>", { noremap = true, silent = true }) -- Stop debugging

      -- 🔥 KEYBINDING: Select & Start Debugging
      vim.api.nvim_set_keymap("n", "<Leader>dc", ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
    end,
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
