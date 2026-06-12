-- Native Neovim LSP setup (Neovim 0.11+ vim.lsp.config / vim.lsp.enable API).
-- Mason installs the server binaries; servers are configured
-- and enabled directly through the built-in vim.lsp interface. nvim-lspconfig is kept only for
-- the default server configs it ships in its `lsp/` directory (cmd, filetypes,
-- root markers). nvim-cmp provides completion.

return {
  -- Mason: installs LSP servers / tools
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  -- Completion engine + sources + snippets
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-l>"] = cmp.mapping.complete(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lua" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- LSP configuration via the native vim.lsp API
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Diagnostics
      vim.diagnostic.config({
        virtual_text = true,
      })

      -- Filter out react/index.d.ts and node_modules entries when jumping to
      -- a definition that resolves to multiple locations.
      local function filter(arr, fn)
        if type(arr) ~= "table" then
          return arr
        end

        local filtered = {}
        for k, v in pairs(arr) do
          if fn(v, k, arr) then
            table.insert(filtered, v)
          end
        end

        return filtered
      end

      local function filterReactDTS(value)
        return string.match(value.filename, "react/index.d.ts") == nil
      end

      local function filterNodeModules(value)
        return string.match(value.filename, "node_modules") == nil
      end

      local function on_list(options)
        local filteredItems = options.items
        if #filteredItems > 1 then
          filteredItems = filter(filteredItems, filterReactDTS)
          filteredItems = filter(filteredItems, filterNodeModules)
        end

        if #filteredItems > 0 then
          vim.fn.setloclist(0, {}, " ", { title = options.title, items = filteredItems, context = options.context })
        else
          vim.fn.setloclist(0, {}, " ", { title = options.title, items = options.items, context = options.context })
        end
        vim.api.nvim_command("lfirst")
      end

      -- Buffer-local keymaps, set when a language server attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf, remap = false }

          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition({ on_list = on_list }) end, opts)
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
          vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
          vim.keymap.set("n", "<leader>gn", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
          vim.keymap.set("n", "<leader>gp", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
          vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
          vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
          vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
          vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end,
      })

      -- Default capabilities (advertise nvim-cmp completion support) for all servers.
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Per-server overrides. These merge on top of nvim-lspconfig's bundled
      -- defaults (shipped in its `lsp/` directory).
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("ts_ls", {
        root_markers = { ".git" },
      })

      -- Enable the language servers. Their binaries are installed via Mason
      -- (:Mason). eslint and oxlint both target JS/TS but only attach when their
      -- respective config files are present, so they coexist without conflict.
      vim.lsp.enable({
        "ts_ls",
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "oxlint",
        "eslint",
      })

      -- LSP format on save
      -- vim.api.nvim_create_autocmd("BufWritePre", { callback = function() vim.lsp.buf.format() end })
    end,
  },
}
