-- 批量重命名

---@type NvPluginSpec
return {
  "smjonas/inc-rename.nvim",
  event = "BufEnter",
  config = function()
    -- vim.keymap.set("n", "<leader>cr", ":IncRename ")
    vim.keymap.set("n", "<leader>cr", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = "Rename" })
    require("inc_rename").setup({
      input_buffer_type = "dressing",
    })
  end,
}
