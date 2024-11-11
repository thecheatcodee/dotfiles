-- 生成漂亮的代码截图

---@type NvPluginSpec
return {
  "mistricky/codesnap.nvim",
  build = "make",
  keys = {
    { "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
    { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
  },
  opts = {
    save_path = "~/Pictures",
    has_breadcrumbs = true,
    ---@type "bamboo"|"sea"|"peach"|"grape"|"dusk"|"summer"
    bg_theme = "dusk",
  },
}
