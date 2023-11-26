" Ward off unexpected things that your distro might have made, as
" well as sanely reset options when re-sourcing .vimrc
set nocompatible

augroup MyAutoCmd
  autocmd!
augroup END

let $VIMDIR = expand(trim(system('ghq root')) .. '\github.com\supermomonga\dot-nvimrc')

source $VIMDIR/config/base.vim

" Set dpp base path (required)
const s:dpp_base = '~/.cache/dpp'

" Set dpp source path (required)
const s:dpp_src = '~/.cache/dpp/repos/github.com/Shougo/dpp.vim'
const s:ext_toml = '~/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml'
const s:ext_lazy = '~/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy'
const s:ext_installer = '~/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer'
const s:ext_git = '~/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git'
const s:denops_src = '~/.cache/dpp/repos/github.com/vim-denops/denops.vim'

const s:dpp_config = $VIMDIR .. '/dpp.ts'

" Set dpp runtime path (required)
execute 'set runtimepath^=' .. s:dpp_src

execute 'set runtimepath+=' .. s:ext_toml
execute 'set runtimepath+=' .. s:ext_lazy
execute 'set runtimepath+=' .. s:ext_installer
execute 'set runtimepath+=' .. s:ext_git

execute 'set runtimepath^=' .. s:denops_src

if dpp#min#load_state(s:dpp_base)
  " NOTE: dpp#make_state() requires denops.vim
  autocmd User DenopsReady call dpp#make_state(s:dpp_base, s:dpp_config)
endif

function! s:make_state_if_needed(file)
  let l:vimdir = expand('$VIMDIR')
  let l:filedir = fnamemodify(a:file, ':p:h')
  " if the file's directory starts with $VIMDIR, call dpp#make_state()
  if stridx(l:filedir, l:vimdir) == 0
    call dpp#make_state()
  endif
endfunction

autocmd MyAutoCmd BufWritePost *.vim,*.toml,*.ts call s:make_state_if_needed(expand('<afile>'))

" Attempt to determine the type of a file based on its name and
" possibly its " contents. Use this to allow intelligent
" auto-indenting " for each filetype, and for plugins that are
" filetype specific.
filetype indent plugin on

" Enable syntax highlighting
if has('syntax')
  syntax on
endif
