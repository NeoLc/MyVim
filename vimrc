set nocompatible

" 显示行号
set nu

" 显示颜色
set t_Co=256

"语法高亮
syntax on

" Tab键的宽度
set tabstop=4

" 统一缩进为4
set softtabstop=4
set shiftwidth=4

" 用空格代替制表符
set expandtab

" 不要用空格代替制表符
"set noexpandtab

set cursorline

" 高亮显示匹配的括号
set showmatch

"搜索逐字符高亮
set hlsearch
set incsearch

"搜索忽略大小写
set ignorecase

set listchars=tab:»■,trail:■
set list

" 输入vim命令时，按Tab键在上方显示所有补全命令
set wildmenu

 " 右下角显示输入的命令
set showcmd

set backspace=indent,eol,start

filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme hybrid_material

"colorscheme onedark
hi Visual cterm=none ctermbg=darkgrey ctermfg=cyan

""""""""""""""""""""""""""""""""""""""""""""""""""""

"ctags
set autochdir
set tags=tags;
nnoremap '] <C-t>

""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

" fix alt key map not work problem
for i in range(97,122)
  let c = nr2char(i)
  exec "map \e".c." <M-".c.">"
"  exec "map! \e".c." <M-".c.">"
endfor

nmap <A-w> <C-w>
"cnoremap source source ~/.vimrc

""""""""""""""""""""""""""""""""""""""""""""""""""""
"terminal
nnoremap <C-t> :terminal<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""

" plug config for nerdtree
nnoremap <leader>s :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
let NERDTreeShowHidden=1

" plug config for vim-interestingwords
let g:interestingWordsDefaultMappings = 0
nnoremap <silent> <leader>l :call InterestingWords('n')<cr>
vnoremap <silent> <leader>l :call InterestingWords('v')<cr>
nnoremap <silent> <leader>L :call UncolorAllWords()<cr>

nnoremap <silent> n :call WordNavigation(1)<cr>
nnoremap <silent> N :call WordNavigation(0)<cr>

"nnoremap * <leader>l

" plug config for vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>0 <Plug>AirlineSelectTab0
nmap <Tab> <Plug>AirlineSelectNextTab
nmap <S-Tab> <Plug>AirlineSelectPrevTab

" plug config for vim-ariline-theme
"let g:airline_theme='atomic'
let g:airline_theme='angr'


" plug config for coc
" utf-8 byte sequence
set encoding=utf-8

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
"inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<TAB>"

" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" plug config for tagbar
nmap <F8> :TagbarToggle<CR>
autocmd VimEnter * nested :call tagbar#autoopen(1)

"plug config for Startify
nnoremap <F7> :Startify<CR>

" Plug 'ludovicchabant/vim-gutentags'
set statusline+=%{gutentags#statusline()}
let g:gutentags_cache_dir = "~/.cache/tags"
let g:gutentags_project_root = ['Makefile']

""""""""""""""""""""""""""""""""""""""""""""""""""""

"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()"
func SetTitle()
   if &filetype == 'sh'
      call append(line("."), "#!/bin/bash")
      call append(line(".")+1, "")
   endif
   if &filetype == 'cpp'
      call append(line("."), "#include <iostream>")
       call append(line(".")+1, "using namespace std;")
      call append(line(".")+2, "")
   endif
   if &filetype == 'c'
      call append(line("."), "#include <stdio.h>")
      call append(line(".")+1, "")
   endif
   autocmd BufNewFile * normal G
endfunc
