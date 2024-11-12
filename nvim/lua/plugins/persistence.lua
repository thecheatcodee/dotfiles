-- Lua
return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  enabled = false,
  opts = {
    -- add any custom options here

  },
  keys = {
    {
      "<leader>qs",
      function()
        require("persistence").load()
      end,
      desc = "Restore Session",
    },
    {
      "<leader>qS",
      function()
        require("persistence").select()
      end,
      desc = "Select Session",
    },
    {
      "<leader>ql",
      function()
        require("persistence").load { last = true }
      end,
      desc = "Restore Last Session",
    },
    {
      "<leader>qd",
      function()
        require("persistence").stop()
      end,
      desc = "Don't Save Current Session",
    },
  }

}

-- FIXME: 需要排除nvimtree
-- pre_save_cmds = {
--   function()
--     local nvim_tree = require "nvim-tree.api"
--     if nvim_tree ~= nil then
--       nvim_tree.tree.close()
--     end
--   end,
-- },
