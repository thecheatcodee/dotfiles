---@type NvPluginSpec
return {
  "olimorris/persisted.nvim",
  enabled = false,
  lazy = false, -- make sure the plugin is always loaded at startup
  -- keys = {},
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
