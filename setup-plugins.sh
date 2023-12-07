repos=(
  "Shougo/dpp.vim"
  "Shougo/dpp-ext-toml"
  "Shougo/dpp-ext-lazy"
  "Shougo/dpp-ext-installer"
  "Shougo/dpp-protocol-git"
  "vim-denops/denops.vim"
)

for repo in "${repos[@]}"; do
  dir=~/.cache/dpp/repos/github.com/${repo%/*}
  [ ! -d "$dir" ] && mkdir -p "$dir"
  [ ! -d "$dir/${repo##*/}/.git" ] && git clone "https://github.com/$repo" "$dir/${repo##*/}"
done

mkdir -p ~/.config/nvim
[ ! -f ~/.config/nvim/init.vim ] && echo source $(ghq root)/github.com/supermomonga/dot-nvimrc/init.vim >> ~/.config/nvim/init.vim

