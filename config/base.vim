
augroup vimrc
  autocmd!
augroup END

set expandtab
set tabstop=2
set shiftwidth=2
set history=10000
set nobackup
set noswapfile
set noundofile
set number
set showtabline=2
set clipboard=unnamedplus

set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

nmap k   gk
nmap j   gj
vmap k   gk
vmap j   gj

command! DppMakeState call dpp#make_state("~/.cache/dpp", $VIMDIR .. "/dpp.ts")

" BOL, EOL toggle
nnoremap <expr>0 col('.') == 1 ? '^' : '0'
nnoremap <expr>^ col('.') == 1 ? '^' : '0'

nnoremap _ :sp<CR>
nnoremap <bar> :vsp<CR>
