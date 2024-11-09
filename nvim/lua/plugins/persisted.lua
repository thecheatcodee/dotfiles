---@type NvPluginSpec
return {
  enabled = false,
  "olimorris/persisted.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  -- lazy = false, -- make sure the plugin is always loaded at startup
  -- keys = {},
  -- config = function()
  --   require("telescope").load_extension "persisted"
  -- end,
  keys = {
    {
      "<leader>qs",
      function()
        require("persisted").load()
      end,
      desc = "Restore Session",
    },
    {
      "<leader>qS",
      function()
        require("persisted").select()
      end,
      desc = "Select Session",
    },
    {
      "<leader>ql",
      function()
        require("persisted").load { last = true }
      end,
      desc = "Restore Last Session",
    },
    {
      "<leader>qd",
      function()
        require("persisted").stop()
      end,
      desc = "Don't Save Current Session",
    },
  },
}
