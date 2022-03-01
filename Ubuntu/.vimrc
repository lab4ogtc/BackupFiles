" -------------------------------------------------
function! MySys()
    if has("win16") || has("win32") || has("win64") || has("win95")
        return "windows"
    elseif has("unix")
        return "linux"
    elseif has("macunix")
        return "macos"
    endif
endfunction

if MySys() == "windows"
    let $VIMFILES = $VIM.'/vimfiles'
elseif MySys() == "linux" || MySys() == "macos"
    let $VIMFILES = $HOME.'/.vim'
endif

let helptags=$VIMFILES.'/doc'

" 设置字体以及中文支持
if has("win32")
    set guifont=Inconsolata:h12:cANSI
endif

if has("multi_byte")
    set encoding=utf-8
    set termencoding=utf-8
    set formatoptions+=mM
    set fencs=utf-8,gbk

    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif

    if has("win32")
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
        language messages zh_CN.utf-8
    endif
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

function! ToggleMouse()
    if &mouse == 'a'
        set mouse=
    else
        set mouse=a
    endif
endfunction
nnoremap <F5> :call ToggleMouse()<CR>

" -------------------------------------------------

set nocompatible
filetype off

syntax on                   " 自动语法高亮
filetype plugin indent on   " 打开插件
" set number                  " 显示行号
" set cursorline              " 突出显示当前行
set ruler                   " 打开标尺
set shiftwidth=4            " 设定>>和<<命令移动宽度为4
set softtabstop=4           " 退格键一次可删除4个空格
set tabstop=4               " 设定tab长度为4
set expandtab               " 使用空格替换tab
set pastetoggle=<F2>        " 切换粘贴模式
set nobackup                " 覆盖文件时不备份
set autochdir               " 自动切换当前目录为当前文件所在目录
set backupcopy=yes          " 设置备份时的行为为覆盖
set ignorecase smartcase    " 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感
set nowrapscan              " 禁止在搜索内容时就显示搜索结果
" set incsearch               " 输入搜索内容时就显示搜索结果
set hlsearch                " 搜索高亮
hi Search cterm=NONE ctermfg=NONE ctermbg=grey
set noerrorbells            " 关闭错误信息响铃
set novisualbell            " 关闭使用可视响铃
set t_vb=                   " 置空错误铃声
" set showmatch               " 插入括号时，短暂地跳转到匹配的对应括号
" set matchtime=2             " 短暂跳转到匹配括号的时间
set magic                   " 设置魔术
set hidden                  " 允许在有未保存的修改时切换缓冲区，此时修改由vim负责保存
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
set smartindent             " 开启新行时使用智能缩进
set backspace=indent,eol,start
set cmdheight=1             " 设定命令行的行数为1

" -------------------------------------------------
function! StatusMouse()
    return &mouse == 'a' ? 'mouse:on' : 'mouse:off'
endfunction

function! StatusPaste()
    return &paste == 0 ? '' : '<paste>'
endfunction

set laststatus=2            " 显示状态栏
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{StatusMouse()}\ %{StatusPaste()}\ %{&filetype}\ %{&fileformat}\ %{&encoding}\ %c:%l/%L%)\ 
" -------------------------------------------------


" -------------------------------------------------
" set foldenable              " 开始折叠
" set foldmethod=syntax       " 设置语法折叠
" set foldcolumn=0            " 设置折叠区域的宽度
" setlocal foldlevel=1        " 设置折叠层数为1
" set foldclose=all           " 设置为自动关闭折叠
" nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
                            " 用空格键开关折叠
" -------------------------------------------------

" -------------------------------------------------
nnoremap <C-Left> <C-w>h
nnoremap <C-Down> <C-w>j
nnoremap <C-Up> <C-w>k
nnoremap <C-Right> <C-w>l
" -------------------------------------------------




" -------------------------------------------------
"  PlugUpgrade  更新vim-plug本身
"  PlugUpdate   更新所有插件
"  PlugStatus   查看插件状态
call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'

Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'preservim/tagbar'

Plug 'ycm-core/YouCompleteMe'
" Plug 'jeaye/color_coded'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

call plug#end()
" -------------------------------------------------

" -------------------------------------------------
let g:ycm_global_ycm_extra_conf='$HOME/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf=0
nnoremap <leader>gg :YcmCompleter GoTo<CR>
nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gf :YcmCompleter Format<CR>
nnoremap <leader>gi :YcmCompleter GoToInclude<CR>
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <leader>gs :YcmCompleter GoToSymbol<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gx :YcmCompleter FixIt<CR>
" -------------------------------------------------

" -------------------------------------------------
nnoremap <F4> :TagbarToggle<CR>

nnoremap <F3> :NERDTreeToggle<CR>

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
" let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
" let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1
" -------------------------------------------------

" -------------------------------------------------
syntax enable
let g:solarized_termcolors=256
set background=dark
colorscheme solarized
" -------------------------------------------------

" -------------------------------------------------
"  vim -b 查看二进制文件自动转十六进制
" -------------------------------------------------
augroup Binary
    au!
    au BufReadPost * if &bin | %!xxd
    au BufReadPost * set ft=xxd | endif
    au BufWritePre * if &bin | %!xxd -r
    au BufWritePre * endif
    au BufWritePost * if &bin | %!xxd
    au BufWritePost * set nomod | endif
augroup END
" -------------------------------------------------
