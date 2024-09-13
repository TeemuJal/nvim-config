return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

    -- When solving merge conflicts in diffsplit view, select left or right window
    vim.keymap.set("x", "gh", "<cmd>diffget //2<CR>")
    vim.keymap.set("x", "gl", "<cmd>diffget //3<CR>")
  end
}
