
dofile(vim.g.base46_cache .. "lsp")
require("nvchad.lsp").diagnostic_config()

local lspconfig = require "lspconfig"

  -- TODO: 需要优化代码

local on_attach = function(client, bufnr)
  -- 定义支持检查的函数
  local function map(mode, key, func, desc ,cap)
    if cap and not client.server_capabilities[cap] then desc = desc ..  " (❌Not Supported)" end

    vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
  end

  -- 判断并映射支持的按键
  map("n",          "gd",         vim.lsp.buf.definition,        "Goto Definition",        "definitionProvider")
  map("n",          "gr",         vim.lsp.buf.references,        "References",             "referencesProvider")
  map("n",          "gI",         vim.lsp.buf.implementation,    "Goto Implementation",    "implementationProvider")
  map("n",          "gy",         vim.lsp.buf.type_definition,   "Goto T[y]pe Definition", "typeDefinitionProvider")
  map("n",          "gD",         vim.lsp.buf.declaration,       "Goto Declaration",       "declarationProvider")
  map("n",          "K",          vim.lsp.buf.hover,             "Hover")
  map("n",          "gK",         vim.lsp.buf.signature_help,    "Signature Help",         "signatureHelpProvider")
  map("i",          "<C-k>",      vim.lsp.buf.signature_help,    "Signature Help",         "signatureHelpProvider")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,       "Code Action",            "codeActionProvider")
  -- map("n",          "<leader>cr", require("nvchad.lsp.renamer"), "Rename")
  map("n",          "<leader>cr", vim.lsp.buf.rename, "Rename", "renameProvider")
  map("n",          "<Leader>cc", vim.lsp.codelens.run,          "CodeLens",               "codeLensProvider")
  map("n",          "<Leader>cC", vim.lsp.codelens.refresh,      "CodeLens Refresh",       "codeActionProvider")
  -- map("n", "<Leader>cr", vim.lsp.buf.rename, opts "rename" )

  vim.keymap.set("n" , "<Leader>uh", function ()
    local enabled = vim.lsp.inlay_hint.is_enabled()
    vim.lsp.inlay_hint.enable(not enabled)
  end , { buffer = bufnr, desc = "Toggle InlayHint" })
end

-- TODO: 暂时放在这里
vim.lsp.inlay_hint.enable(true)

--------------------------- lsp specs -----------------------------


-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "clangd",
  "basedpyright",
  "bashls",
  -- "gopls",

  "zls",
  -- "ruff",
  -- "ts_ls",
  "jsonls",
  "dockerls",
  "kulala_ls",
  -- "vuels",
  "yamlls",
  -- "lua_ls"
}

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

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- Lua

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


-- Python

lspconfig.ruff.setup {

  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,

  cmd_env = { RUFF_TRACE = "messages" },

  settings = {
    logLevel = "error",
  },
  -- keys = {
  --   {
  --     "<leader>co",
  --     LazyVim.lsp.action["source.organizeImports"],
  --     desc = "Organize Imports",
  --   },
  -- },
}


-- Go

lspconfig.gopls.setup {

  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        fieldalignment = true,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
}


-- Typescript

-- lspconfig.eslint.setup({
--   settings = {
--     packageManager = 'bun'
--   },
--   ---@diagnostic disable-next-line: unused-local
--   on_attach = function(client, bufnr)
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       buffer = bufnr,
--       command = "EslintFixAll",
--     })
--   end,
-- })


--- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
    --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
-- lspconfig.tsserver.setup {
--       enabled = false,
--     }
-- lspconfig.ts_ls.setup {
--       enabled = false,
--     }

-- Vue

-- lspconfig.volar.setup {
--   on_attach = on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
--   filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
--   init_options = {
--     vue = {
--       hybridMode = true,
--     },
--   },
-- }

lspconfig.volar.setup({
  on_attach = on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  init_options = {
    typescript = {
      tsdk = vim.fn.expand '~/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib',
    },
    vue = {
      hybridMode = false,
    },
  },
})


-- lspconfig.vtsls.setup {
--
--   on_attach = on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
--   -- explicitly add default filetypes, so that we can extend
--   -- them in related extras
--   filetypes = {
--     "javascript",
--     "javascriptreact",
--     "javascript.jsx",
--     "typescript",
--     "typescriptreact",
--     "typescript.tsx",
--   },
--   settings = {
--     complete_function_calls = true,
--     vtsls = {
--       enableMoveToFileCodeAction = true,
--       autoUseWorkspaceTsdk = true,
--       experimental = {
--         completion = {
--           enableServerSideFuzzyMatch = true,
--         },
--       },
--     },
--     typescript = {
--       updateImportsOnFileMove = { enabled = "always" },
--       suggest = {
--         completeFunctionCalls = true,
--       },
--       inlayHints = {
--         enumMemberValues = { enabled = true },
--         functionLikeReturnTypes = { enabled = true },
--         parameterNames = { enabled = "literals" },
--         parameterTypes = { enabled = true },
--         propertyDeclarationTypes = { enabled = true },
--         variableTypes = { enabled = false },
--       },
--     },
--   },
--
--     vue = {
--       hybridMode = true,
--     },
--
--   -- keys = {
--   --   {
--   --     "gD",
--   --     function()
--   --       local params = vim.lsp.util.make_position_params()
--   --       LazyVim.lsp.execute({
--   --         command = "typescript.goToSourceDefinition",
--   --         arguments = { params.textDocument.uri, params.position },
--   --         open = true,
--   --       })
--   --     end,
--   --     desc = "Goto Source Definition",
--   --   },
--   --   {
--   --     "gR",
--   --     function()
--   --       LazyVim.lsp.execute({
--   --         command = "typescript.findAllFileReferences",
--   --         arguments = { vim.uri_from_bufnr(0) },
--   --         open = true,
--   --       })
--   --     end,
--   --     desc = "File References",
--   --   },
--   --   {
--   --     "<leader>co",
--   --     LazyVim.lsp.action["source.organizeImports"],
--   --     desc = "Organize Imports",
--   --   },
--   --   {
--   --     "<leader>cM",
--   --     LazyVim.lsp.action["source.addMissingImports.ts"],
--   --     desc = "Add missing imports",
--   --   },
--   --   {
--   --     "<leader>cu",
--   --     LazyVim.lsp.action["source.removeUnused.ts"],
--   --     desc = "Remove unused imports",
--   --   },
--   --   {
--   --     "<leader>cD",
--   --     LazyVim.lsp.action["source.fixAll.ts"],
--   --     desc = "Fix all diagnostics",
--   --   },
--   --   {
--   --     "<leader>cV",
--   --     function()
--   --       LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
--   --     end,
--   --     desc = "Select TS workspace version",
--   --   },
--   -- },
-- }


