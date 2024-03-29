vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`<")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set({ "n", "v" }, "<C-z>", "<nop>")
-- Alternate file. <C-]> the same as nordic <C-¨>
vim.keymap.set("n", "<C-]>", "<C-^>")
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

-- Replace word on cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Paragraph moving
vim.keymap.set({ "n", "v" }, "å", "}")
vim.keymap.set({ "n", "v" }, "¨", "{")

-- TODO: make this work in WSL
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- These don't work in WSL
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")

-- TODO: make this work somehow in WSL
--vim.keymap.set("v", "<leader>y", function()
--    vim.cmd(":normal! y")
--   vim.cmd("y")
-- print(vim.fn.getreg('"'))
--    vim.fn.system('clip.exe', "test print")
--end)
--vim.keymap.set("v", "<leader>y", "\"+y")
--vim.keymap.set("n", "<leader>Y", "\"+Y")

--function dump(o)
--   if type(o) == 'table' then
--      local s = '{ '
--      for k,v in pairs(o) do
--         if type(k) ~= 'number' then k = '"'..k..'"' end
--         s = s .. '['..k..'] = ' .. dump(v) .. ','
--      end
--      return s .. '} '
--   else
--      return tostring(o)
--   end
--end

-- Copy from WSL Neovim to Windows:
-- https://www.reddit.com/r/neovim/comments/vxdjyb/neovim_in_wsl2_cant_copypaste_tofrom_system/itiyb3p/
--vim.opt.clipboard = "unnamedplus"
--if vim.fn.has('wsl') == 1 then
--    vim.api.nvim_create_autocmd('TextYankPost', {
--        group = vim.api.nvim_create_augroup('Yank', { clear = true }),
--        callback = function(params)
--            print(dump(params))
--            vim.fn.system('clip.exe', vim.fn.getreg('"'))
--        end,
--    })
--end
