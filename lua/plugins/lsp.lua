return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v1.x",
  dependencies = {
		  -- LSP Support
		  "neovim/nvim-lspconfig",             -- Required
		  "williamboman/mason.nvim",           -- Optional
		  "williamboman/mason-lspconfig.nvim", -- Optional

		  -- Autocompletion
		  "hrsh7th/nvim-cmp",         -- Required
		  "hrsh7th/cmp-nvim-lsp",     -- Required
		  "hrsh7th/cmp-buffer",       -- Optional
		  "hrsh7th/cmp-path",         -- Optional
		  "saadparwaiz1/cmp_luasnip", -- Optional
		  "hrsh7th/cmp-nvim-lua",     -- Optional

		  -- Snippets
		  "L3MON4D3/LuaSnip",             -- Required
		  "rafamadriz/friendly-snippets", -- Optional
  },
  config = function()
    local lsp = require('lsp-zero')

    lsp.preset("recommended")

    -- (Optional) Configure lua language server for neovim
    lsp.nvim_workspace()

    lsp.ensure_installed({
        'ts_ls',
        'eslint@4.8.0',
        'lua_ls',
        'rust_analyzer',
        'gopls',
    })

    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-l>'] = cmp.mapping.complete(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
    })

    lsp.set_preferences({
        sign_icons = false
    })

    lsp.setup_nvim_cmp({
        mapping = cmp_mappings
    })

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
      return string.match(value.filename, 'react/index.d.ts') == nil
    end

    local function filterNodeModules(value)
      return string.match(value.filename, 'node_modules') == nil
    end

    local function on_list(options)
      local filteredItems = options.items
      if #filteredItems > 1 then
        filteredItems = filter(filteredItems, filterReactDTS)
        filteredItems = filter(filteredItems, filterNodeModules)
      end

      if #filteredItems > 0 then
        vim.fn.setloclist(0, {}, ' ', { title = options.title, items = filteredItems, context = options.context })
      else
        vim.fn.setloclist(0, {}, ' ', { title = options.title, items = options.items, context = options.context })
      end
      vim.api.nvim_command('lfirst') -- or maybe you want 'copen' instead of 'cfirst'
    end

    lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition{on_list=on_list} end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>gn", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "<leader>gp", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end)

    lsp.setup()

    vim.diagnostic.config({
        virtual_text = true,
    })

    local lspconfig = require("lspconfig")

    lspconfig.ts_ls.setup({
      root_dir = lspconfig.util.root_pattern(".git")
    })

    -- LSP format on save
    -- vim.api.nvim_create_autocmd("BufWritePre", { callback = function() vim.lsp.buf.format() end })
  end
}
