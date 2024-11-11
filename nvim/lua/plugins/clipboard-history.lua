
---@type NvPluginSpec
return {
  'royanirudd/clipboard-history.nvim',
  event = "BufEnter",
  opts = {
      max_history = 200,  -- Optional: set max history (default 100)
      enable_wsl_features = false,  -- Set to true if you're using WSL and want Windows clipboard integration
  },
  keys = {
    { "<leader>p", "<cmd>ClipboardHistory<cr>", desc = "paste from clipboard history" },
  },
  cmd = {
    "ClipboardHistory",
    "ClipboardClear",
    "ClipboardYankToWindows",
  }
}

