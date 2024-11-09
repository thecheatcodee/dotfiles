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
    foldtext = "",
    foldlevel = 99,
    foldlevelstart = 5,
    foldnestmax = 5,
    fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "", lastline = " " },
    -- Prevent issues with some language servers
    -- backup = false,
    -- swapfile = false,
    -- Always show minimum n lines after/before current line
    scrolloff = 10,
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
    cursorlineopt = "both",
    inccommand = "split",
    ignorecase = true,
    updatetime = 100,
    lazyredraw = false,
    iskeyword = vim.opt.iskeyword:append { "_", "@", ".", "-" },
    path = vim.opt.path:append { "**", "lua", "src" },

    -- whichwrap = vim.opt.whichwrap
    -- whichwrap = {"[", "]", "<", ">"} -- 光标行尾时可以跳到下一行的按键
  },
}

for i, opts in pairs(custom) do
  for k, v in pairs(opts) do
    vim[i][k] = v
  end
end

