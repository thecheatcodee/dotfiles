DOTFILES="$HOME/.dotfiles"

create_symlink() {
  src=$1
  dest=$2
  backup="$dest.bak"

  # 检查目标是否为目录或文件且不是符号链接
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then

    n=1
    while [ -e "$backup" ]; do
      backup="$dest.bak.$n"
      n=$((n + 1))
    done

    # 将原始文件或目录重命名为备份文件
    mv "$dest" "$backup"
    echo "Warning: Backed up existing $dest to $backup"
  fi

  # 创建符号链接，强制覆盖旧的符号链接
  ln -sfn "$src" "$dest"
  echo "Created symlink: $dest -> $src"
}

# 使用函数创建符号链接
create_symlink "$DOTFILES/ssh/config" "$HOME/.ssh/config"
create_symlink "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES/btop" "$HOME/.config/btop"
create_symlink "$DOTFILES/fd" "$HOME/.config/fd"
create_symlink "$DOTFILES/fish" "$HOME/.config/fish"
create_symlink "$DOTFILES/kitty" "$HOME/.config/kitty"
create_symlink "$DOTFILES/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES/yazi" "$HOME/.config/yazi"
create_symlink "$DOTFILES/zellij" "$HOME/.config/zellij"

sh $DOTFILES/iterm2/setup.sh
