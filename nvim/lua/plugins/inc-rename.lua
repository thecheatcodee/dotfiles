---@type NvPluginSpec
return {
  "smjonas/inc-rename.nvim",
  event = "BufEnter",
  config = function()
    require("inc_rename").setup() vim.keymap.set("n", "<leader>cr", ":IncRename ")
  end,
}
