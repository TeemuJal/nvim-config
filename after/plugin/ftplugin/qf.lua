local options = { noremap = true, silent = true, expr = true }

-- J and K in quickfix list open the file automatically while staying in quickfix list
vim.keymap.set("n", "J", function()
    local buftype = vim.fn.win_gettype()
    if buftype == "quickfix" then
        return "j <CR><C-w>p"
    end
end, options)

vim.keymap.set("n", "K", function()
    local buftype = vim.fn.win_gettype()
    if buftype == "quickfix" then
        return "k <CR><C-w>p"
    end
end, options)
