
dofile(vim.g.base46_cache .. "lsp")
require("nvchad.lsp").diagnostic_config()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "clangd",
  "basedpyright",
  "gopls",
  "ruff",
  "ts_ls",
  "jsonls",
  "dockerls",
  "kulala_ls",
  "vuels",
  "yamlls",
  "lua_ls"
}


-- export on_attach & capabilities
-- local on_attach = function(client, bufnr)
--   vim.print(vim.json.encode(client.server_capabilities))
--   local function opts(desc)
--     return { buffer = bufnr, desc = "LSP " .. desc }
--   end
--
--   map("n", "gd", vim.lsp.buf.definition, opts "Goto Definition")
--   map("n", "gr", vim.lsp.buf.references, opts "References")
--   map("n", "gI", vim.lsp.buf.implementation, opts "Goto Implementation")
--   map("n", "gy", vim.lsp.buf.type_definition, opts "Goto T[y]pe Definition")
--   map("n", "gD", vim.lsp.buf.declaration, opts "Goto Declaration")
--   map("n", "K", vim.lsp.buf.hover, opts "Hover")
--   map("n", "gK", vim.lsp.buf.signature_help, opts "Signature Help")
--   map("i", "<C-k>", vim.lsp.buf.signature_help, opts "Signature Help")
--   map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
--   -- map("n", "<Leader>cr", vim.lsp.buf.rename, opts "rename" )
--   map("n", "<leader>cr", require "nvchad.lsp.renamer", opts "NvRenamer")
--   map("n" , "<Leader>cc", vim.lsp.codelens.run, { expr = true, desc = "LSP codeLens" })
--   map("n" , "<Leader>cC", vim.lsp.codelens.refresh, { expr = true, desc = "LSP codeLens" })
--   -- map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
--   -- map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
--   -- map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
--
--   -- map("n", "<leader>wl", function()
--   --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--   -- end, opts "List workspace folders")
--   --
--   -- map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
--   -- map("n", "<leader>ra", require "nvchad.lsp.renamer", opts "NvRenamer")
--
-- end

  -- TODO: 优化代码

local on_attach = function(client, bufnr)
  -- 定义支持检查的函数
  local function map(mode, key, func, desc ,cap)
    if not client.server_capabilities[cap] then
      desc = desc ..  " (Not Supported)"
    end
    vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
  end

  -- 判断并映射支持的按键
  map("n", "gd", vim.lsp.buf.definition, "Goto Definition", "definitionProvider")
  map("n", "gr", vim.lsp.buf.references, "References", "referencesProvider")
  map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation", "implementationProvider")
  map("n", "gy", vim.lsp.buf.type_definition, "Goto T[y]pe Definition", "typeDefinitionProvider")
  map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration", "declarationProvider")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "gK", vim.lsp.buf.signature_help, "Signature Help", "signatureHelpProvider")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help", "signatureHelpProvider")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action", "codeActionProvider")
  -- map("n", "<Leader>cr", vim.lsp.buf.rename, opts "rename" )
  vim.keymap.set("n", "<leader>cr", require "nvchad.lsp.renamer", { buffer = bufnr, desc = "Rename" })
  vim.keymap.set("n" , "<Leader>cc", vim.lsp.codelens.run, { buffer = bufnr, desc = "CodeLens" })
  vim.keymap.set("n" , "<Leader>cC", vim.lsp.codelens.refresh, { buffer = bufnr, desc = "CodeLens Refresh" })
end

local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = nvlsp.on_attach,
    on_attach = on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end


lspconfig.lua_ls.setup {
  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}
-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
