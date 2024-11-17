-- Super powerful color picker/colorizer plugin
return	{
		'uga-rosa/ccc.nvim',
		event = 'FileType',
		keys = {
			{ '<Leader><Leader>c', '<cmd>CccPick<CR>', desc = 'Color Picker' },
		},
		opts = {
			highlighter = {
				auto_enable = true,
				lsp = true,
				filetypes = {
					'html',
					'lua',
					'css',
					'scss',
					'sass',
					'less',
					'stylus',
					'javascript',
					'tmux',
					'typescript',
				},
				excludes = { 'lazy', 'mason', 'help', 'neo-tree' },
			},
		},
	}
