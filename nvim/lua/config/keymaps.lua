-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- add blank line above and below with alt o and alt O
vim.api.nvim_set_keymap("n", "<A-h>", "O<ESC>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-l>", "o<ESC>k", { noremap = true, silent = true })
