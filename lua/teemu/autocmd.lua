-- Auto command for setting cursor on leaving vim. Otherwise cursor stays nvim styled
vim.api.nvim_create_autocmd("VimLeave", { command = "set guicursor=a:ver100-blinkon1" })

-- Wrap filetypes
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.md", "*.txt" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
