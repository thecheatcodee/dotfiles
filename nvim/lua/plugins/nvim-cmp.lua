-- load luasnips + cmp related in insert mode only
return {
  "hrsh7th/nvim-cmp",
  opts = function()
    return require "configs.cmp"

  --   local cmp = require "nvim-cmp"
  --   cmp.setup.cmdline(":", {
  --     mapping = cmp.mapping.preset.cmdline(),
  --     sources = cmp.config.sources({
  --       { name = "path" },
  --     }, {
  --       {
  --         name = "cmdline",
  --         option = {
  --           ignore_cmds = { "Man", "!", "IncRename" },
  --         },
  --       },
  --     }),
  --   })
  end,

  -- `:` cmdline setup.
  -- config = function()
  --   local cmp = require "nvim-cmp"
  --   cmp.setup.cmdline(":", {
  --     mapping = cmp.mapping.preset.cmdline(),
  --     sources = cmp.config.sources({
  --       { name = "path" },
  --     }, {
  --       {
  --         name = "cmdline",
  --         option = {
  --           ignore_cmds = { "Man", "!", "IncRename" },
  --         },
  --       },
  --     }),
  --   })
  -- end,
}
