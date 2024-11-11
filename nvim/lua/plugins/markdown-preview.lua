
local build_cmd = (function()
  if vim.fn.executable("bun") then
    return string.format("bun install")
  end
  if  vim.fn.executable("yarn") then
    return string.format("cd app && yarn install")
  end
  if vim.fn.executable("npm") then
    return string.format("npm install")
  end
end)()

---@type NvPluginSpec
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = build_cmd,
  init = function()
    vim.g.mkdp_filetypes = { "markdown", "Avante" }
  end,
  ft = { "markdown" },
}
