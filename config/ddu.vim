
" hook_add {{{
nnoremap <C-p> <Cmd>Ddu file_rec<CR>
nnoremap <C-S-p> <Cmd>Ddu -name=command_palette<CR>
nnoremap <Space>p <Cmd>Ddu -name=command_palette<CR>
nnoremap <C-c> <Cmd>Ddu -name=command_palette<CR>
"nnoremap <Space>h <Cmd>Ddu help<CR>
nnoremap <C-l> <Cmd>Ddu line<CR>
"nnoremap gd <Cmd>Ddu -name=lsp:definitions<CR>

" TODO: LSP サーバーがアタッチされた場合のみ有効にする
" ref: https://zenn.dev/botamotch/articles/21073d78bc68bf#1.-lsp-server-management
"nnoremap <C-]> <Cmd>Ddu -name=lsp:definitions<CR>
" }}}

" hook_source {{{
call ddu#custom#load_config(expand('$VIMDIR/config/ddu.ts'))
" }}}

" ddu-ff {{{
nnoremap <buffer><silent> <CR>
  \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
nnoremap <buffer><silent> i
  \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
nnoremap <buffer><silent> p
  \ <Cmd>call ddu#ui#ff#do_action('preview')<CR>
nnoremap <buffer><silent> P
  \ <Cmd>call ddu#ui#ff#do_action('togglePreview')<CR>
nnoremap <buffer><silent> <Esc>
  \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
nnoremap <buffer><silent> q
  \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
nnoremap <buffer><silent> <Space>
  \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>

setlocal cursorline
" }}}

" ddu-ff-filter {{{
"inoremap <buffer><silent> <CR>  <Esc><Cmd>close<CR>
inoremap <buffer><silent> <CR>
      \ <ESC><Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
nnoremap <buffer><silent> <CR>
      \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
inoremap <buffer><silent> <Esc> <Esc><Cmd>close<CR>
nnoremap <buffer><silent> <Esc> <Cmd>close<CR>

inoremap <buffer> <Down>
      \ <Cmd>call ddu#ui#do_action('cursorNext')<CR>
inoremap <buffer> <Up>
      \ <Cmd>call ddu#ui#do_action('cursorPrevious')<CR>
inoremap <buffer> <C-j>
      \ <Cmd>call ddu#ui#do_action('cursorNext')<CR>
inoremap <buffer> <C-k>
      \ <Cmd>call ddu#ui#do_action('cursorPrevious')<CR>
" }}}
