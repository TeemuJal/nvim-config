vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- When solving merge conflicts in diffsplit view, select left or right window
vim.keymap.set("n", "gf", "<cmd>diffget //2<CR>")
vim.keymap.set("n", "gj", "<cmd>diffget //3<CR>")
