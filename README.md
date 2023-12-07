# Setup

## Requirements

- ghq
- asdf-vm

## Setup NeoVim nightly

```sh
./setup-neovim.sh
```

## Setup dependency plugins

```sh
./setup-plugins.sh
```

## Setup Deno for denops.vim

It requires asdf-vm.

```
sudo apt install -y curl git unzip
asdf plugin-add deno https://github.com/asdf-community/asdf-deno.git
asdf install deno latest
asdf global deno latest
```
