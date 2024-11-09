-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General Settings
local general = augroup("General", { clear = true })

-- Add autocmd for macOS to switch input method to ABC when entering normal mode
autocmd("VimEnter", {
  callback = function()
    if vim.fn.has("mac") and vim.env.SSH_CONNECTION == nil then
      local imselect_bin = "/usr/local/bin/im-select"
      if not vim.fn.executable(imselect_bin) then
        return
      end
      vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        pattern = "*",
        callback = function()
          -- 只有在需要时才切换
          if vim.fn.system(imselect_bin):match "com.apple.keylayout.ABC" ~= nil then
            return
          end
          vim.fn.system(imselect_bin .. " com.apple.keylayout.ABC")
        end,
      })
    end
  end,
  group = general,
  desc = "Switch input method to ABC when leaving insert mode",
})

-- FIXME: 有时不起作用，怀疑是事件顺序问题
autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
  group = general,
  desc = "Prevent auto comment new line",
})

autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = false
  end,

  desc = "Disable spell checking for markdown and txt files",
})

autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "silent quitall"
    end
  end,
  group = general,
  desc = "Close nvim if NvimTree is only running buffer",
})

-- FIXME: 不起作用
-- autocmd("TextYankPost", {
--   desc = "Highlight on yank",
--   command = "silent! lua vim.highlight.on_yank({higroup='YankVisual', timeout=200})",
--   -- group = augroup("YankHighlight", { clear = true }),
-- })

-- FIXME: 报错
-- autocmd("VimEnter", {
--   callback = function()
--     require("nvim-tree.api").events.subscribe("FileCreated", function(file)
--       vim.cmd("edit " .. file.name)
--     end)
--   end,
-- })

-- prevent weird snippet jumping behavior
-- https://github.com/L3MON4D3/LuaSnip/issues/258
autocmd({ "ModeChanged" }, {
  pattern = { "s:n", "i:*" },
  callback = function()
    if
      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end,
})


-- Delete [No Name] buffers,
autocmd("BufHidden", {
  callback = function(event)
    if event.file == "" and vim.bo[event.buf].buftype == "" and not vim.bo[event.buf].modified then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, event.buf, {})
      end)
    end
  end,
})

-- -- Hide cursorline in insert mode
-- autocmd({ "InsertLeave", "WinEnter" }, {
--   command = "set cursorline",
-- })

-- Automatically update changed file in Vim
-- Triger `autoread` when files changes on disk
-- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = [[silent! if mode() != 'c' && !bufexists("[Command Line]") | checktime | endif]],
})

-- Notification after file change
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd("FileChangedShellPost", {
  command = [[echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]],
})

-- 在 markdown 和 txt 文件中启用 wrap
autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true  -- 为更好地换行，避免单词被截断
  end,
})


-- 将打开的目录设为工作目录
autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)  -- 获取第一个参数
    if arg and vim.fn.isdirectory(arg) == 1 then
      vim.cmd("cd " .. arg)
    end
  end,
})

-- FIXME: 和auto-session冲突
-- -- 识别 git 工作目录
-- autocmd("BufEnter", {
--   callback = function()
--     -- 获取当前文件的 Git 根目录（如果存在）
--     local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
--     -- 检查 git 命令是否成功执行（返回非空字符串）
--     if git_root and git_root ~= "" and vim.fn.isdirectory(git_root) == 1 then
--       vim.cmd("cd " .. git_root)
--       print("Changed working directory to Git root: " .. git_root)
--     end
--   end,
-- })
