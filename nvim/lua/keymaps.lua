require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local del = vim.keymap.del

-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

--- Buffer commands
map("n", "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", { desc = " Switch Buffer" })
map("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = " Switch Files" })

-- 折叠文本中移动
-- TODO: 添加autocmd，在映射只在折叠开启的情况下生效
map("n", "j", "gj")
map("n", "k", "gk")
-- map("n", "$", "g$")
-- map("n", "^", "g^")
-- map("n", "0", "g0")

-- -- better up/down
-- map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
-- map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- disable

map("i", "<C-n>", "<nop>")
map("i", "<C-p>", "<nop>")
map("n","<Leader>pt", "<nop>") -- TODO: 在WhichKey上禁用

-- map("n", "<Leader>ft", "", { expr = true, desc = "" })

-- map({ "i", "s" }, "<C-E>", function()
--   if require("luasnip").choice_active() then
--     require("luasnip").change_choice(1)
--   end
-- end, { silent = true })

-- Better indenting
map("v", ">", ">gv")
map("v", "<", "<gv")

-- 复制后光标保持在原来的位置
map("v", "y", "ygv<ESC>")

map("n", "<leader>`", "<cmd>e#<cr>", { desc = "🔙 Last Buffer" })
-- map("n", "<leader>b1", "<cmd>bfirst<cr>", { desc = "First buffer" })
-- map("n", "<leader>bn", function()
--   require("nvchad.tabufline").next()
-- end, { desc = "Next buffer" })
-- map("n", "<leader>bp", function()
--   require("nvchad.tabufline").prev()
-- end, { desc = "Previous buffer" })
-- map("n", "<leader>bd", function()
--   -- require("nvchad.tabufline").
-- end, { desc = "Close current buffer" })
-- map("n", "<leader>bD", "<cmd>%bd|e#<cr>", { desc = "Close other buffers" })

-- map("n", "\\t", function ()
--   vim.ui.select({'apple', 'banana', 'mango'}, {
--   prompt = "Title",
--   telescope = require("telescope.themes").get_cursor(),
-- }, function(selected) end)
-- end, { desc = "Test" })
