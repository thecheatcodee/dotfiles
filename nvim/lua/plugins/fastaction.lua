return {
  "Chaitanyabsprip/fastaction.nvim",
  enabled = false,
  ---@type FastActionConfig
  opts = {},
  config = function ()
      vim.keymap.set(
        'n',
        '<leader>a',
        '<cmd>lua require("fastaction").code_action()<CR>',
        { buffer = bufnr }
    )
    vim.keymap.set(
        'v',
        '<leader>a',
        "<esc><cmd>lua require('fastaction').range_code_action()<CR>",
        { buffer = bufnr }
    )
  end
}
