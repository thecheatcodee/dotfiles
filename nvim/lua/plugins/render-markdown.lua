-- [document](https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki)

---@type NvPluginSpec
return {
  enabled = true,
  "MeanderingProgrammer/render-markdown.nvim",

  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---\@type render.md.UserConfig
  -- opts = {},
  ft = { "markdown", "quarto" },
  config = function()
    local highlights= require("utils.markview-highlights")
    -- 初次加载时应用动态高亮组
    highlights.create(highlights.dynamic)

    -- 主题更改时自动更新高亮组
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        highlights.remove()  -- 移除旧的高亮
        highlights.create(highlights.dynamic)  -- 重新计算并应用高亮
      end
    })
    require("render-markdown").setup {
      render_mode = { "n", "c" },
      paragraph = {
        -- left_margin = 0.5,
        -- min_width = 30,
      },

      heading = {
          width = 'block',
          left_pad = 2,
          right_pad = 4,
          border = true,
          border_virtual = true,
          backgrounds = {
              'MarkviewHeading1',
              'MarkviewHeading2',
              'MarkviewHeading3',
              'MarkviewHeading4',
              'MarkviewHeading5',
              'MarkviewHeading6',
          },
          foregrounds = {
              'MarkviewHeading1',
              'MarkviewHeading2',
              'MarkviewHeading3',
              'MarkviewHeading4',
              'MarkviewHeading5',
              'MarkviewHeading6',
          },
      },


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
