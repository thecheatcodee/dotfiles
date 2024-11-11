-- [document](https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki)
-- FIXME: heading 不能正确渲染

---@type NvPluginSpec
return {
  "MeanderingProgrammer/render-markdown.nvim",

  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---\@type render.md.UserConfig
  -- opts = {},
  ft = { "markdown", "quarto" },
  config = function()
    require("render-markdown").setup {
      render_mode = { "n", "c" },
      paragraph = {
        -- left_margin = 0.5,
        -- min_width = 30,
      },

      -- heading = {
      --     width = 'block',
      --     left_pad = 2,
      --     right_pad = 4,
      -- },

      checkbox = {
        position = "overlay",
      },

      code = {
          width = 'block',
          min_width = 45,
          left_pad = 2,
          language_pad = 2,
      },

      bullet = { left_pad = 1 },
    }
  end,
}
