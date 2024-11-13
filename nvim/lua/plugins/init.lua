return {
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension "frecency"
    end,
  }

  -- {
  --   "stevearc/conform.nvim",
  --   event = "BufWritePre", -- uncomment for format on save
  --   opts = require "configs.conform",
  -- },

  -- These are some examples, uncomment them if you want to see them work!

-- Git
	-- {
	-- 	"NeogitOrg/neogit",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("rc/pluginconfig/neogit")
	-- 	end,
	-- },
	-- {
	-- 	"akinsho/git-conflict.nvim",
	-- 	event = "VeryLazy",
	-- 	config = true,
	-- },
	-- { "yutkat/convert-git-url.nvim", cmd = { "ConvertGitUrl" } },
	-- {
	-- 	"lewis6991/gitsigns.nvim",
	-- 	event = "VimEnter",
	-- 	config = function()
	-- 		require("rc/pluginconfig/gitsigns")
	-- 	end,
	-- },
	-- {
	-- 	"sindrets/diffview.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("rc/pluginconfig/diffview")
	-- 	end,
	-- },
	--
	-- --------------------------------
	-- -- Git command assistant
	-- -- { "hotwatermorning/auto-git-diff", ft = { "gitrebase" } },
	-- {
	-- 	"yutkat/git-rebase-auto-diff.nvim",
	-- 	ft = { "gitrebase" },
	-- 	config = true,
	-- },
	--
	-- --------------------------------
	-- -- GitHub
	-- {
	-- 	"pwntester/octo.nvim",
	-- 	cmd = { "Octo" }
	-- },

}
