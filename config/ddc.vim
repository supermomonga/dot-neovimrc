" hook_add {{{
" }}}

" hook_source {{{
call ddc#custom#load_config(expand('$VIMDIR/config/ddc.ts'))

" 挿入モードの設定

" カーソル位置が行頭でなく、カーソル手前が文字（.含む）であれば補完を発動
inoremap <expr> <TAB>
      \ pum#visible() ?
      \   '<Cmd>call pum#map#select_relative(+1)<CR>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \   '<TAB>' : ddc#map#manual_complete()

" pum 表示中なら確定
inoremap <expr> <CR> pum#visible()
      \ ? pum#map#confirm_word()
      \ : '<CR>'

" ddc 表示中なら ddc キャンセル
inoremap <expr> <ESC> ddc#visible()
      \ ? '<Cmd>call ddc#hide()<CR>'
      \ : '<ESC>'

inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>

" コマンドラインモードの設定
cnoremap <expr> <Tab>
      \ wildmenumode() ? &wildcharm->nr2char() :
      \ pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' :
      \ ddc#map#manual_complete()
cnoremap <expr> <Down> ddc#visible()
      \ ? '<Cmd>call pum#map#select_relative(+1)<CR>'
      \ : '<Down>'
cnoremap <expr> <Up> ddc#visible()
      \ ? '<Cmd>call pum#map#select_relative(-1)<CR>'
      \ : '<Up>'
cnoremap <expr> <CR> pum#visible()
      \ ? '<Cmd>call pum#map#confirm()<CR>'
      \ : '<CR>'
cnoremap <expr> <ESC> ddc#visible()
      \ ? '<Cmd>call ddc#hide()<CR>'
      \ : '<C-c>'

call ddc#enable(#{ context_filetype: 'treesitter' })
" }}}
