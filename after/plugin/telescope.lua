require('telescope').setup {
    defaults = {
        wrap_results = true
    }
}
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', telescope.find_files, {})
vim.keymap.set('n', '<C-p>', telescope.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    telescope.grep_string({ search = vim.fn.input("Grep > ") });
end)
