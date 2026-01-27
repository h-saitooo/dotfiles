local keymap = vim.keymap.set

keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })

keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

keymap("v", "<", "<gv", { desc = "Unindent" })
keymap("v", ">", ">gv", { desc = "Indent" })

keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

keymap("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Japanese input method toggle
keymap("i", "<C-j>", "<C-^>", { desc = "Toggle Japanese input method" })
keymap("n", "<leader>ji", ":set iminsert=1<CR>", { desc = "Enable Japanese input" })
keymap("n", "<leader>je", ":set iminsert=0<CR>", { desc = "Disable Japanese input" })