---@type NvPluginSpec
return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  enabled = true,
  config = function()
     require("trouble").setup()
  end,
  opts = {
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  },
  keys = {
    -- { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
    -- { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "References/Definitions/..." },
    { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols Tree" },
    { "<leader>x", "", desc = "Quickfix/Diagnostics/Loclist" },
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Previous Trouble/Quickfix Item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Next Trouble/Quickfix Item",
    },
  },
}
