return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
  },
  config = function()
    local telescope = require('telescope')
    local lga_actions = require("telescope-live-grep-args.actions")
    telescope.setup {
      defaults = {
        wrap_results = true
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = {     -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              -- freeze the current list and start a fuzzy search in the frozen list
              ["<C-space>"] = lga_actions.to_fuzzy_refine,
            },
          },
        }
      }
    }
    local telescope_builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', telescope_builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', telescope_builtin.git_files, {})
    vim.keymap.set("n", "<leader>lg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
    vim.keymap.set('n', '<leader>ps', function()
      telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") });
    end)

    telescope.load_extension("live_grep_args")
  end
}
