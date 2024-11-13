My Neovim config
=================

我的个人neovim配置，初始模版来自[Nvchad](https://nvchad.com)

![预览](example.png)


[[toc]]

## 配置参考

- [BrunoKrugel/dotfiles](https://github.com/BrunoKrugel/dotfiles/blob/master/lua/)
- [kickstart](https://github.com/nvim-lua/kickstart.nvim/tree/master/lua/kickstart)
- [Lazyvim](http://www.lazyvim.org/plugins) 
- [corintho/nvchad-custom](https://github.com/corintho/nvchad-custom/tree/main/lua)
- [mgastonportillo/nvchad-config](https://github.com/mgastonportillo/nvchad-config/blob/main/lua/)
- [kiyoon/dotfiles](https://github.com/kiyoon/dotfiles/tree/master/nvim)
- [nvchad](https://github.com/NvChad/NvChad)
- Reddit社区
- Stackoverflow

## 目录结构

```text


```

## 平台支持

- Neovide
- WSL环境

## 插件列表


### Markdown

- markdown-preview.nvim
- markdown-render.nvim
- ~~markview.nvim~~

### 快速跳转

- flash.nvim

### Session 管理

- auto-session 保存和回复会话

### UI 优化相关

- action-preview 使用telescope选择code actions  

### 其他


- winresize.nvim 窗口resize逻辑优化
- codesnap.nvim 代码截图 
- clipboard-history 非常轻量级的剪贴板历史


## ✅ Todo

- [ ] 添加Markdown局部快捷键（render，preview，生成语法等）
- [ ] 完善插件lazyload配置
- [x] 优化按键映射，使用Lazyvim风格
- [ ] 更详尽的 LSP 配置
- [x] Debug 功能
- [ ] 更多 UI 优化
- [ ] 集成 Copilot
- [ ] ~~命令行补全替换成nvim-cmp~~
- [ ] Jupyter 支持
- [ ] 优化Avante配置
- [ ] 添加更多git功能
- [ ] 添加数据库功能
- [ ] 配置Neotest
- [ ] 为常用语言配置Debug
- [x] 默认打开dashboard
- [ ] 完善Which key配置
  - [ ] Icon
  - [ ] 启动时的延迟问题
- [ ] Nvcheatsheet
- [ ] Latex
- [ ] 尝试yanky
- [ ] Obsidian支持
- [ ] 图片支持

## 🐞FIXME

- [x] 复制高亮的autocmd不起作用
- [x] markdown-render 的标题不能正确渲染
- [x] http treesitter 高亮不工作
- [ ] kulala创建response结果窗口后，如果想关闭它，会导致bufline的错误
- [x] 有未保存的buffer时，自动关闭nvim-tree的autocmd会报错
- [ ] neovim刚进入时如果lazy.nvim自动打开安装插件的窗口，会报错
