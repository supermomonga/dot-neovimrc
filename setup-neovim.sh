if [ -f /usr/local/bin/nvim ]; then
  sudo rm /usr/local/bin/nvim
fi

if [ -d /neovim ]; then
  sudo rm -rf /neovim
fi

curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
sudo mv ./squashfs-root /neovim
sudo ln -s /neovim/AppRun /usr/local/bin/nvim
rm ./nvim.appimage
