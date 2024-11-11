return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    -- Lazy
    { "typicode/bg.nvim", lazy = false }
  }

  -- These are some examples, uncomment them if you want to see them work!
}
