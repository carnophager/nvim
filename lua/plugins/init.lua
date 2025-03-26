return {
-- In your lazy.nvim config file
-- tailwind-tools.lua
{
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
},
{
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").load_extension("file_browser")
  end,
},
{
  "eero-lehtinen/oklch-color-picker.nvim",
  event = "VeryLazy",
  version = "*",
  keys = {
    -- One handed keymap recommended, you will be using the mouse
    {
      "<leader>v",
      function() require("oklch-color-picker").pick_under_cursor() end,
      desc = "Color pick under cursor",
    },
  },
  ---@type oklch.Opts
  opts = {},
},
{
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
    "neovim/nvim-lspconfig", -- optional
  },
  opts = {} -- your configuration
},{
  "mattn/emmet-vim",
  ft = { "html", "css", "javascript", "typescript", "typescriptreact", "jsx", "tsx" },
  config = function()
    vim.g.user_emmet_install_global = 0
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "html", "css", "javascript", "typescript", "jsx", "tsx", "typescriptreact" },
      callback = function()
        vim.cmd("EmmetInstall")
      end,
    })
  end,
},
{
  "dcampos/cmp-emmet-vim",
  ft = { "html", "css", "javascript", "typescript", "jsx", "tsx", "typescriptreact" },
},

{
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip", -- Snippet engine
    "dcampos/cmp-emmet-vim", -- Updated Emmet integration plugin
    "tailwind-tools",
    "onsails/lspkind-nvim"
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        {
          name = "emmet_vim",
          option = { filetypes = { "html", "css", "javascript", "typescript", "jsx", "tsx", "typescriptreact" } },
        },
      }, {
        { name = "buffer" },
      }),
      formatting = {
        format = lspkind.cmp_format({
          before = require("tailwind-tools.cmp").lskind_format,
        })
      }
    })
  end,
}
, {
    "aaronhallaert/advanced-git-search.nvim",
    cmd = { "AdvancedGitSearch" },
    config = function()
        -- optional: setup telescope before loading the extension
        require("telescope").setup{
            -- move this to the place where you call the telescope setup function
            extensions = {
                advanced_git_search = {
                        -- See Config
                    }
            }
        }

        require("telescope").load_extension("advanced_git_search")
    end,
    dependencies = {
        --- See dependencies
    },
},  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency
    lazy = false,
    config = function()
      -- Optional: Add any custom Diffview settings here
      require("diffview").setup({})
    end,
  },
-- nvim v0.8.0
{
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").load_extension("lazygit")
    end,
},

{
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      event = 'InsertEnter',
      build = ':Copilot auth',
      opts = {
        suggestion = {enabled = false},
        panel = { enabled = false},
        filetypes = {
          markdown = true,
          help = true
        }
      },
      config = function()
        -- require("copilot").setup({})
      end,
   },
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Basic Treesitter setup
      ensure_installed = { "lua", "typescript", "javascript" }, -- Add your preferred languages
      highlight = { enable = true },
      -- Textobjects configuration
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["at"] = "@tag.outer",
            ["it"] = "@tag.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
          },
          goto_next_tag_end = {
            ["]t"] = "@tag.open_end",
          }
        },
      },
    })
  end,
},
{
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter" },
  lazy = false
},
{"nvim-lua/plenary.nvim"},

{
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  name = "harpoon",
  module = "harpoon",
  dependencies = { {"nvim-lua/plenary.nvim"}},
  keys = {
    { "<C-a>", mode = "n", desc = "Add file to harpoon" },
    { "<leader>h", mode = "n", desc = "Toggle harpoon menu" },
  },
  config = function()
  local harpoon = require("harpoon")

  -- REQUIRED
  harpoon:setup()

  vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
  vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  vim.keymap.set("n", "<C-n>", function() harpoon:list():next({ui_nav_wrap = true}) end)

  end,
}
,
  {
  "nvim-cmp",
  dependencies = {
    {
      "zbirenbaum/copilot-cmp",
      dependencies = "copilot.lua",
      opts = {},
      config = function(_, opts)
        local copilot_cmp = require("copilot_cmp")
        copilot_cmp.setup(opts)
        -- attach cmp source whenever copilot attaches
        -- fixes lazy-loading issues with the copilot cmp source
        -- LazyVim.lsp.on_attach(function(client)
          -- copilot_cmp._on_insert_enter({})
        -- end, "copilot")
      end,
    },
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(opts.sources, 1, {
      name = "copilot",
      group_index = 1,
      priority = 100,
    })
  end,
},
---@module "neominimap.config.meta"
{
    "Isrothy/neominimap.nvim",
    version = "v3.*.*",
    enabled = true,
    lazy = false, -- NOTE: NO NEED to Lazy load
    -- Optional
    keys = {
        -- Global Minimap Controls
        { "<leader>nm", "<cmd>Neominimap toggle<cr>", desc = "Toggle global minimap" },
        { "<leader>no", "<cmd>Neominimap on<cr>", desc = "Enable global minimap" },
        { "<leader>nc", "<cmd>Neominimap off<cr>", desc = "Disable global minimap" },
        { "<leader>nr", "<cmd>Neominimap refresh<cr>", desc = "Refresh global minimap" },

        -- Window-Specific Minimap Controls
        { "<leader>nwt", "<cmd>Neominimap winToggle<cr>", desc = "Toggle minimap for current window" },
        { "<leader>nwr", "<cmd>Neominimap winRefresh<cr>", desc = "Refresh minimap for current window" },
        { "<leader>nwo", "<cmd>Neominimap winOn<cr>", desc = "Enable minimap for current window" },
        { "<leader>nwc", "<cmd>Neominimap winOff<cr>", desc = "Disable minimap for current window" },

        -- Tab-Specific Minimap Controls
        { "<leader>ntt", "<cmd>Neominimap tabToggle<cr>", desc = "Toggle minimap for current tab" },
        { "<leader>ntr", "<cmd>Neominimap tabRefresh<cr>", desc = "Refresh minimap for current tab" },
        { "<leader>nto", "<cmd>Neominimap tabOn<cr>", desc = "Enable minimap for current tab" },
        { "<leader>ntc", "<cmd>Neominimap tabOff<cr>", desc = "Disable minimap for current tab" },

        -- Buffer-Specific Minimap Controls
        { "<leader>nbt", "<cmd>Neominimap bufToggle<cr>", desc = "Toggle minimap for current buffer" },
        { "<leader>nbr", "<cmd>Neominimap bufRefresh<cr>", desc = "Refresh minimap for current buffer" },
        { "<leader>nbo", "<cmd>Neominimap bufOn<cr>", desc = "Enable minimap for current buffer" },
        { "<leader>nbc", "<cmd>Neominimap bufOff<cr>", desc = "Disable minimap for current buffer" },

        ---Focus Controls
        { "<leader>nf", "<cmd>Neominimap focus<cr>", desc = "Focus on minimap" },
        { "<leader>nu", "<cmd>Neominimap unfocus<cr>", desc = "Unfocus minimap" },
        { "<leader>ns", "<cmd>Neominimap toggleFocus<cr>", desc = "Switch focus on minimap" },
    },
    init = function()
        -- The following options are recommended when layout == "float"
        vim.opt.wrap = false
        vim.opt.sidescrolloff = 36 -- Set a large value

        --- Put your configuration here
        vim.g.neominimap = {
            auto_enable = true,
        }
    end,
},
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
-- lazy.nvim:
{
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
        'nvimtools/hydra.nvim',
    },
    opts = {
    DEBUG_MODE = false,
    create_commands = true, -- create Multicursor user commands
    updatetime = 50, -- selections get updated if this many milliseconds nothing is typed in the insert mode see :help updatetime
    nowait = true, -- see :help :map-nowait
    mode_keys = {
        append = 'a',
        change = 'c',
        extend = 'e',
        insert = 'i',
    }, -- set bindings to start these modes
    normal_keys = normal_keys,
    insert_keys = insert_keys,
    extend_keys = extend_keys,
    -- see :help hydra-config.hint
    hint_config = {
        float_opts = {
            border = 'none',
        },
        position = 'bottom',
    },
    -- accepted values:
    -- -1 true: generate hints
    -- -2 false: don't generate hints
    -- -3 [[multi line string]] provide your own hints
    -- -4 fun(heads: Head[]): string - provide your own hints
    generate_hints = {
        normal = true,
        insert = true,
        extend = true,
        config = {
             -- determines how many columns are used to display the hints. If you leave this option nil, the number of columns will depend on the size of your window.
            column_count = nil,
            -- maximum width of a column.
            max_hint_length = 25,
        }
    },
},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
            {
                mode = { 'v', 'n' },
                '<Leader>m',
                '<cmd>MCstart<cr>',
                desc = 'Create a selection for selected text or word under the cursor',
            },
        },
}
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "?tml", "css"
  -- 		},
  -- 	},
  -- },
}
