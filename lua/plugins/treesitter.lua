return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.setup()

      local ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "javascript",
        "typescript",
        "tsx",
        "rust",
      }
      ts.install(ensure_installed)

      -- On the `main` branch, highlighting is not enabled by config; it is
      -- started per-buffer via `vim.treesitter.start()`. This FileType autocmd
      -- starts highlighting for any buffer whose language has a parser, and
      -- auto-installs the parser first if it is missing but available
      -- (replaces the old `auto_install = true`).
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then
            return
          end

          local function start()
            if vim.api.nvim_buf_is_valid(buf) then
              pcall(vim.treesitter.start, buf, lang)
            end
          end

          if vim.tbl_contains(ts.get_installed(), lang) then
            start()
          elseif vim.tbl_contains(ts.get_available(), lang) then
            -- Parser available but not installed: install asynchronously,
            -- then start highlighting once it finishes.
            ts.install({ lang }):await(function(err)
              if not err then
                vim.schedule(start)
              end
            end)
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        multiline_threshold = 10,
      })
    end,
  },
}
