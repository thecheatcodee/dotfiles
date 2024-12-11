-- Super powerful color picker/colorizer plugin
return	{
  'uga-rosa/ccc.nvim',
  -- enabled = false,
  event = 'FileType',
  keys = {
    { '<Leader><Leader>c', '<cmd>CccPick<CR>', desc = 'Color Picker' },
  },
  opts = {
    highlighter = {
      auto_enable = false, -- TODO: 判断是否使用内置
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
