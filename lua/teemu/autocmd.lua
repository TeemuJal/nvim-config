-- Auto command for setting cursor on leaving vim. Otherwise cursor stays nvim styled
vim.api.nvim_create_autocmd("VimLeave", { command = "set guicursor=a:ver100-blinkon1" })
