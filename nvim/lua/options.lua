require "nvchad.options"

-- add yours here!

local custom = {
  g = {
    dap_virtual_text = true,
    bookmark_sign = "",
    skip_ts_context_commentstring_module = true,
  },
  opt = {
    encoding = "utf-8",
    fileencoding = "utf-8",
    clipboard = "unnamedplus",
    -- clipboard = "", -- 默认禁用系统剪贴板
    -- Folds
    foldmethod = "expr",
    foldexpr = "v:lua.vim.treesitter.foldexpr()",
    -- foldcolumn = "1",
    -- foldtext = "",
    foldlevel = 99,
    foldlevelstart = 5,
    foldnestmax = 5,
    fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "", lastline = " " },
    -- Prevent issues with some language servers
    backup = false,
    swapfile = false,
    -- Always show minimum n lines after/before current line
    scrolloff = 10,
    sidescrolloff = 15,
    -- True color support
    termguicolors = true,
    emoji = false,
    relativenumber = true,
    -- Line break/wrap behaviours
    wrap = false,
    linebreak = true,
    textwidth = 0,
    wrapmargin = 0,
    -- Indentation values
    tabstop = 2,
    shiftwidth = 0, -- 0 forces same value as tabstop
    expandtab = true,
    autoindent = true,
    cursorline = true,
    guicursor = {
        "n-v-c:block-Cursor/lCursor",   -- 普通、可视和命令模式下使用块状光标
        "i:ver25-Cursor",               -- 插入模式下使用垂直条状光标，宽度为 25%
        "r:hor20",                      -- 替换模式下使用水平条状光标，厚度为 20%
    },
    cursorlineopt = "both",
    inccommand = "split",
    ignorecase = true,
    updatetime = 100,
    lazyredraw = false,
    iskeyword = vim.opt.iskeyword:append { "_", "@", ".", "-" },
    path = vim.opt.path:append { "**", "lua", "src" },
    sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
    grepprg = "rg --vimgrep",
    -- whichwrap = vim.opt.whichwrap
    -- whichwrap = {"[", "]", "<", ">"} -- 光标行尾时可以跳到下一行的按键

    -- Undo
    undofile = true,
    undolevels = 10000,
  },
}

for i, opts in pairs(custom) do
  for k, v in pairs(opts) do
    vim[i][k] = v
  end
end

