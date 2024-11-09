require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

--- Buffer commands
map("n", "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", { desc = " Switch Buffer" })

-- 折叠文本中移动
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "$", "g$")
map("n", "^", "g^")
map("n", "0", "g0")

map("i", "<C-n>", "")
map("i", "<C-p>", "")

map({"i", "s"}, "<C-E>", function()
  if require("luasnip").choice_active() then
    require("luasnip").change_choice(1)
  end
end, {silent = true})

-- visual mode 下更易用的缩进
map("v", ">", ">gv")
map("v", "<", "<gv")

-- 复制后光标保持在原来的位置
map("v", "y", "ygv<ESC>")


-- map("n", "<leader>`", "<cmd>e#<cr>", { desc = "🔙 Last Buffer" })
-- map("n", "<leader>b1", "<cmd>bfirst<cr>", { desc = "First buffer" })
-- map("n", "<leader>bn", function()
--   require("nvchad.tabufline").next()
-- end, { desc = "Next buffer" })
-- map("n", "<leader>bp", function()
--   require("nvchad.tabufline").prev()
-- end, { desc = "Previous buffer" })
-- map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close current buffer" })
-- map("n", "<leader>bD", "<cmd>%bd|e#<cr>", { desc = "Close other buffers" })
