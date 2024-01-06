" hook_add {{{
nnoremap <Space>f <Cmd>Ddu file_rec<CR>
nnoremap <Space>p <Cmd>Ddu -name=command_palette<CR>
nnoremap <Space>g <Cmd>Ddu -name=grep<CR>
nnoremap <Space>h <Cmd>Ddu help<CR>
nnoremap <Space>l <Cmd>Ddu line<CR>
nnoremap <Space>b <Cmd>Ddu buffer<CR>
nnoremap <Space><Space> <Cmd>DduContextAwareCommandPalette<CR>

" hook_source {{{
call ddu#custom#load_config(expand('$VIMDIR/config/ddu.ts'))

let g:command_palette_common_commands = {
      \ 'LSP: Start': 'LspStart',
      \ 'LSP: Stop': 'LspStop',
      \ 'LSP: Restart': 'LspRestart',
      \ 'LSP: Info': 'LspInfo',
      \ 'Git: Log': 'GinLog',
      \ 'Git: Status': 'GinStatus',
      \ 'Git: Browse': 'GinBrowse',
      \ }
let g:command_palette_common_commands_keys = map(keys(g:command_palette_common_commands), { idx, v -> v })
let g:command_palette_callback_id = denops#callback#register(
      \ { name -> execute(g:command_palette_common_commands[name]) },
      \ #{ once: v:false })
function! DduContextAwareCommandPalette() abort
  call ddu#start(#{ sources: [
        \   #{
        \     name: 'custom-list',
        \     params: #{ texts: g:command_palette_common_commands_keys, callbackId: g:command_palette_callback_id }
        \   }
        \ ]})
endfunction
command! DduContextAwareCommandPalette call DduContextAwareCommandPalette()
" }}}

" ddu-ff {{{
nnoremap <buffer><silent> <CR>
  \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
nnoremap <buffer><silent> a
  \ <Cmd>call ddu#ui#ff#do_action('chooseAction')<CR>
nnoremap <buffer><silent> i
  \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
nnoremap <buffer><silent> p
  \ <Cmd>call ddu#ui#ff#do_action('preview')<CR>
nnoremap <buffer><silent> P
  \ <Cmd>call ddu#ui#ff#do_action('togglePreview')<CR>
nnoremap <buffer><silent> <Esc>
  \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
nnoremap <buffer><silent> <Space>
  \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
nnoremap <buffer><silent> S
  \ <Cmd>call ddu#ui#ff#do_action('toggleAllItems')<CR>

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
