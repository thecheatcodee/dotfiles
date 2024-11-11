-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "ayu_light",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },

    -- hl_override = {
    --   DiffAdd = {
    --     bg = "one_bg",
    --     fg = "orange",
    --   },
    --   DiffChange = {
    --     bg = "one_bg2",
    --     fg = "blue",
    --   },
    --   DiffDelete = {
    --     bg = "one_bg3",
    --     fg = "cyan",
    --   },
    -- },
  },
}

return M
