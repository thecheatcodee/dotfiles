---@type NvPluginSpec
return {
  "rmagatti/auto-session",
  enabled = false,
  event = "VimEnter",
  lazy = false,
  keys = {
    { "<leader>qs", "<cmd>SessionSave<cr>", desc = "Save session" },
    { "<leader>qd", "<cmd>SessionDelete<cr>", desc = "Delete current session" },
  },
  config = function()
    require("auto-session").setup {
      log_level = vim.log.levels.ERROR,
      auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions/",
      auto_session_enable_last_session = false,
      auto_session_enabled = true,
      auto_session_create_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_session_name = "Session.vim", -- Set the session file name (optional)

      -- Disable session lens
      session_lens = {
        load_on_setup = false,
        theme_conf = { border = true },
        previewer = false,
      },
      pre_save_cmds = {
        function()
          local nvim_tree = require "nvim-tree.api"
          if nvim_tree ~= nil then
            nvim_tree.tree.close()
          end
        end,
      },
    }
  end,
}
