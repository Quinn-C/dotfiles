":Telescope find_files Usage: toggle fold in Vim with 'za'. 'zR' to open all folds, 'zM' to close
" General: options {{{

" Enable filetype detection, plugin loading, and indentation loading
filetype plugin indent on
set nocompatible
" Code Completion:
set completeopt=menuone,longest wildmode=longest:full wildmenu

" for showing file icons in Nerdtree
set encoding=utf8

" Messages:
" c = don't give |ins-completion-menu| messages; they're noisy
" I = ignore startup message
set shortmess+=c shortmess+=I

" Hidden Buffer: enable instead of having to write each buffer
set hidden

" Sign Column: always show it
set signcolumn=number

set cursorline

" Mouse: enable GUI mouse support in all modes
set mouse=a

" SwapFiles: prevent their creation
set noswapfile

" Command Line Height: higher for display for messages
set cmdheight=2

" Line Wrapping: do not wrap lines by default
set nowrap linebreak

" Indentation:
set expandtab autoindent smartindent shiftwidth=2 softtabstop=2 tabstop=8

" Filename: for gf (@-@='@', see: https://stackoverflow.com/a/45244758)
set isfname+=@-@ isfname+=:

" Highlight Search: do that
" note: hlsearcha nd nohlsearch are defined in autocmd outside function
set incsearch inccommand=nosplit

" Spell Checking:
set spelllang=en_us

" Single Space After Punctuation: useful when doing :%j (the opposite of gq)
set nojoinspaces

set showtabline=2

set autoread

set grepprg=rg\ --vimgrep

" Don't timeout on mappings
set notimeout

" Numbering:
set number

" Window Splitting: Set split settings (options: splitright, splitbelow)
set splitright

" Terminal Color Support: only set guicursor if truecolor
if $COLORTERM ==# 'truecolor'
  set termguicolors
else
  set guicursor=
endif

" Set Background: defaults to dark
set background=dark

" Colorcolumn:
set colorcolumn=80
highlight ColorColumn ctermbg=lightcyan guibg=blue

" Status Line: specifics for custom status line
set laststatus=2 ttimeoutlen=50 noshowmode

" ShowCommand: turn off character printing to vim status line
set noshowcmd

" Updatetime: time Vim waits to do something after I stop moving
set updatetime=300

" Linux Dev Path: system libraries
set path+=/usr/include/x86_64-linux-gnu/

" Vim History: for command line; can't imagine that more than 100 is needed
set history=100

" Set the diff expression to EnhancedDiff
set diffopt+=internal,algorithm:patience

" Folding
set foldenable foldmethod=marker foldnestmax=1

"Automatically use the system clipboard for copy and paste
set clipboard=unnamedplus
" Redraw Window: whenever a window regains focus
augroup custom_redraw_on_refocus
  autocmd!
  autocmd FocusGained * redraw!
augroup end

augroup custom_incsearch_highlight
  autocmd!
  autocmd CmdlineEnter /,\? set hlsearch
  autocmd CmdlineLeave /,\? set nohlsearch
augroup end

augroup custom_iskeyword_overrides
  autocmd!
  autocmd FileType nginx set iskeyword+=$
  autocmd FileType zsh,sh set iskeyword+=-
augroup end
let mapleader = ","
" General: Plugin Install {{{

call plug#begin('~/.vim/plugged')

" TreeSitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" File finder
Plug 'kien/ctrlp.vim'

" vim color schema
Plug 'bkad/vim-terraform'
Plug 'hashivim/vim-hashicorp-tools'
" Vim color scheme
Plug 'EdenEast/nightfox.nvim'
Plug 'folke/tokyonight.nvim'
" markdown preview cmd, :MarkdownPreview :MarkdownPreviewStop
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" telescope and its dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }

" Nvim tree
Plug 'nvim-tree/nvim-web-devicons' " optional
Plug 'nvim-tree/nvim-tree.lua'

" NerdTree colorscheme
" add filetype icon
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
" Python LSP
"
" CoC
Plug 'neoclide/coc.nvim'

" Python syntax highlighting
"Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/seoul256.vim'

" Delete surrounding ds"
Plug 'tpope/vim-surround'

Plug 'windwp/nvim-autopairs'

call plug#end()
" }}}

"colorscheme PaperColor
" Markdown preview
function OpenMarkdownPreview (url)
let g:mkdp_browserfunc = 'OpenMarkdownPreview'
" set to 1, nvim will open the preview window after entering the Markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when changing
" from Markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" General: key mappings {{{

let g:mapleader = ','
endfunction

function! s:default_key_mappings()

  " J: unmap in normal mode unless range explicitly specified
  nnoremap <silent> <expr> J v:count == 0 ? '<esc>' : 'J'

  " SearchBackward: remap comma to single quote
  nnoremap ' ,

  " MoveVisual: up and down visually only if count is specified before
  nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  vnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
  vnoremap <expr> j v:count == 0 ? 'gj' : 'j'

  " MoveTabs: goto tab number. Same as Firefox
  nnoremap <silent> <A-1> <Cmd>silent! 1tabnext<CR>
  nnoremap <silent> <A-2> <Cmd>silent! 2tabnext<CR>
  nnoremap <silent> <A-3> <Cmd>silent! 3tabnext<CR>
  nnoremap <silent> <A-4> <Cmd>silent! 4tabnext<CR>
  nnoremap <silent> <A-5> <Cmd>silent! 5tabnext<CR>
  nnoremap <silent> <A-6> <Cmd>silent! 6tabnext<CR>
  nnoremap <silent> <A-7> <Cmd>silent! 7tabnext<CR>
  nnoremap <silent> <A-8> <Cmd>silent! 8tabnext<CR>
  nnoremap <silent> <A-9> <Cmd>silent! $tabnext<CR>

  inoremap jk <esc>
  inoremap <esc> <nop>

   " Goto tab number by alt + tab number
  nnoremap <A-1> 1gt
  nnoremap <A-2> 2gt
  nnoremap <A-3> 3gt
  nnoremap <A-4> 4gt
  nnoremap <A-5> 5gt
  nnoremap <A-6> 6gt
  nnoremap <A-7> 7gt
  nnoremap <A-8> 8gt
  nnoremap <A-9> 9gt

  " NERDTree key mappings
  nnoremap <leader>n :NERDTreeFocus<CR>
  nnoremap <C-n> :NERDTree<CR>
  nnoremap <C-t> :NERDTreeToggle<CR>
  nnoremap <C-f> :NERDTreeFind<CR>

  " TogglePluginWindows:
  " nnoremap <silent> <space>j <Cmd>NvimTreeFindFileToggle<CR>

  " IndentLines: toggle if indent lines is visible
  "nnoremap <silent> <leader>i <Cmd>IndentLinesToggle<CR>

  " Telescope: create shortcuts for finding stuff
  " <C-n>/<Down> Next item
  " <C-p>/<Up>	 Previous item
  " https://github.com/nvim-telescope/telescope.nvim#default-mappings
  "nnoremap <silent> <C-p><C-p> <Cmd>Telescope find_files hidden=true<CR>
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  "nnoremap <silent> <C-p><C-b> <Cmd>Telescope buffers<CR>
  "nnoremap <silent> <C-n><C-n> <Cmd>Telescope live_grep<CR>
  "nnoremap <silent> <C-n><C-w> <Cmd>Telescope grep_string<CR>

  "" FiletypeFormat: remap leader f to do filetype formatting
  "nnoremap <silent> <leader>f <Cmd>silent! CocDisable<cr><Cmd>FiletypeFormat<cr><Cmd>silent! CocEnable<cr>
  "vnoremap <silent> <leader>f <Cmd>silent! CocDisable<cr>:FiletypeFormat<cr><Cmd>silent! CocEnable<cr>

  "" Open GitHub ssh url
  "nnoremap gx <Cmd>call <SID>gx_improved()<CR>

  "" Clipboard Copy: Visual mode copy is pretty simple
  "vnoremap <leader>y "+y
  "nnoremap <leader>y "+y

  "" Mouse: toggle folds with middle click (I never use it for paste)
  "noremap <silent> <MiddleMouse>   <LeftMouse>za
  "noremap <silent> <2-MiddleMouse> <LeftMouse>za
  "noremap <silent> <3-MiddleMouse> <LeftMouse>za
  "noremap <silent> <4-MiddleMouse> <LeftMouse>za
  "
  " remap vim-surround ysiw" to a"
  nnoremap ga" :ysiw"<CR>
  " Auto-execute all filetypes
  let &filetype=&filetype
endfunction

call s:default_key_mappings()

augroup custom_remap_man_help
  autocmd!
  autocmd FileType man,help nnoremap <buffer> <silent> <C-]> <C-]>
augroup end

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_match_func = {'match': 'matcher#python', 'match_args': ['line','fname','source']}

nnoremap <leader>f :CtrlP<CR>


" }}}
" General: filetype {{{

augroup custom_filetype_recognition
  autocmd!
  autocmd BufEnter *.asm set filetype=nasm
  autocmd BufEnter *.scm set filetype=query
  autocmd BufEnter *.cfg,*.ini,.coveragerc,*pylintrc,zoomus.conf set filetype=dosini
  autocmd BufEnter *.config,.cookiecutterrc set filetype=yaml
  autocmd BufEnter *.handlebars set filetype=html
  autocmd BufEnter *.hql,*.q set filetype=hive
  autocmd BufEnter *.js,*.gs set filetype=javascript
  autocmd BufEnter *.mdx set filetype=markdown
  autocmd BufEnter *.min.js set filetype=none
  autocmd BufEnter *.m,*.oct set filetype=octave
  autocmd BufEnter *.toml set filetype=toml
  autocmd BufEnter *.tsv set filetype=tsv
  autocmd BufEnter .envrc set filetype=sh
  autocmd BufEnter .gitignore,.dockerignore set filetype=conf
  autocmd BufEnter .jrnl_config,*.bowerrc,*.babelrc,*.eslintrc,*.slack-term,*.htmlhintrc,*.stylelintrc,*.firebaserc set filetype=json
  autocmd BufEnter Dockerfile.* set filetype=dockerfile
  autocmd BufEnter Makefile.* set filetype=make
  autocmd BufEnter poetry.lock,Pipfile set filetype=toml
  autocmd BufEnter tsconfig.json,*.jsonc,.markdownlintrc set filetype=jsonc
  autocmd BufEnter tmux-light.conf set filetype=tmux
  autocmd BufEnter .zshrc set filetype=sh
augroup end

" }}}
" General: indentation {{{

augroup custom_indentation
  autocmd!
  " Reset to 2 (something somewhere overrides...)
  autocmd Filetype markdown setlocal shiftwidth=2 softtabstop=2
  " 4 spaces per tab, not 2
  autocmd Filetype python,c,nginx,haskell,rust,kv,asm,nasm,gdscript3
        \ setlocal shiftwidth=4 softtabstop=4
  " Use hard tabs, not spaces
  autocmd Filetype make,tsv,votl,go,gomod
        \ setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  " Prevent auto-indenting from occuring
  autocmd Filetype yaml setlocal indentkeys-=<:>
augroup end

" }}}
" General: statusline {{{

" Status Line
set laststatus=2
set statusline=
set statusline+=%#CursorLine#
set statusline+=\ %{mode()}
set statusline+=\ %*\  " Color separator + space
set statusline+=%{&paste?'[P]':''}
set statusline+=%{&spell?'[S]':''}
set statusline+=%r
set statusline+=%t
set statusline+=%m
set statusline+=%=
set statusline+=\ %v:%l/%L\  " column, line number, total lines
set statusline+=\ %y\  " file type
set statusline+=%#CursorLine#
set statusline+=\ %{&ff}\  " Unix or Dos
set statusline+=%*  " default color
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}\  " file encoding

" Status Line
augroup custom_statusline
  autocmd!
  autocmd BufEnter NvimTree* setlocal statusline=\ NvimTree\ %#CursorLine#
augroup end

" }}}
" General: tabline {{{

function! CustomTabLine()
  " Initialize tabline string
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif
    " set the tab page number (for mouse clicks)
    let s ..= '%' .. (i + 1) .. 'T'
    " the label is made by CustomTabLabel()
    let s ..= ' ' . (i + 1) . ':%{CustomTabLabel(' .. (i + 1) .. ')} '
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s ..= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s ..= '%=%#TabLine#%999Xclose'
  endif
  return s
endfunction

function! CustomTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bname = bufname(buflist[winnr - 1])
  let bnamemodified = fnamemodify(bname, ':t')
  if bnamemodified == ''
    return '[NO NAME]'
  endif
  return bnamemodified
endfunction

set tabline=%!CustomTabLine()

" }}}
" General: environment variables {{{

" Path: add node_modules for language servers / linters / other stuff
let $PATH = $PWD . '/node_modules/.bin:' . $PATH

" }}}
" General: comment & text format options {{{

" Notes:
" commentstring: read by vim-commentary; must be one template
" comments: csv of comments.
" formatoptions: influences how Vim formats text
augroup custom_comment_config
  autocmd!
  autocmd FileType dosini setlocal commentstring=#\ %s comments=:#,:;
  autocmd FileType tmux,python,nginx setlocal commentstring=#\ %s comments=:# formatoptions=jcroql
  autocmd FileType jsonc setlocal commentstring=//\ %s comments=:// formatoptions=jcroql
  autocmd FileType sh setlocal formatoptions=jcroql
  autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
augroup end

" }}}
" General: gx improved {{{

function! s:gx_improved()
  silent execute '!gio open ' . expand('<cfile>')
endfunction

" }}}
" General: trailing whitespace {{{

function! s:trim_whitespace()
  let l:save = winsaveview()
  if &ft == 'markdown'
    " Replace lines with only trailing spaces
    %s/^\s\+$//e
    " Replace lines with exactly one trailing space with no trailing spaces
    %g/\S\s$/s/\s$//g
    " Replace lines with more than 2 trailing spaces with 2 trailing spaces
    %s/\s\s\s\+$/  /e
  else
    " Remove all trailing spaces
    %s/\s\+$//e
  endif
  call winrestview(l:save)
endfunction

command! TrimWhitespace call s:trim_whitespace()

augroup custom_fix_whitespace_save
  autocmd!
  autocmd BufWritePre * TrimWhitespace
augroup end

" }}}
" General: clean unicode {{{

" Replace unicode symbols with cleaned, ascii versions
function! s:clean_unicode()
  silent! %s/”/"/g
  silent! %s/“/"/g
  silent! %s/’/'/g
  silent! %s/‘/'/g
  silent! %s/—/-/g
  silent! %s/…/.../g
  silent! %s/​//g
endfunction
command! CleanUnicode call s:clean_unicode()

" }}}
" Package: markdown-preview.vim {{{

let g:mkdp_auto_start = v:false
let g:mkdp_auto_close = v:false

" set to 1, the vim will just refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = v:false

" set to 1, the MarkdownPreview command can be use for all files,
" by default it just can be use in markdown file
" default: 0
let g:mkdp_command_for_global = v:false

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
let g:mkdp_preview_options = {
      \ 'mkit': {},
      \ 'katex': {},
      \ 'uml': {},
      \ 'maid': {},
      \ 'disable_sync_scroll': 0,
      \ 'sync_scroll_type': 'middle'
      \ }

" }}}
" Package: preview compiled stuff in viewer {{{

function! s:preview()
  if &filetype ==? 'rst'
    silent exec 'terminal restview %'
    silent exec "normal \<C-O>"
  elseif &filetype ==? 'markdown'
    " from markdown-preview.vim
    silent exec 'MarkdownPreview'
  elseif &filetype ==? 'plantuml'
    " from plantuml-previewer.vim
    silent exec 'PlantumlOpen'
  else
    silent !gio open '%:p'
  endif
endfunction

command! Preview call s:preview()

" }}}
" Package: misc global var config {{{

" Languages: configure location of host
"let g:python3_host_prog = "$HOME/.asdf/shims/python"

let g:loaded_netrwPlugin = 1
let g:netrw_nogx = 1

" Man Pager
let g:man_hardwrap = v:true

" IndentLines:
let g:indentLine_enabled = v:false  " indentlines disabled by default

" QuickScope: great plugin helping with f and t
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars = 10000

" Makefile: global variable to prevent syntax highlighting of commands
let g:make_no_commands = 1

" vim-filetype-formatter:
let g:vim_filetype_formatter_verbose = v:false
let g:vim_filetype_formatter_ft_no_defaults = []
let g:vim_filetype_formatter_commands = {
      \ 'python': 'black -q - | isort -q - | docformatter -',
      \ }

" Configs for Python syntax highlighter
"colorscheme nightfox
colorscheme tokyonight-storm
lua << EOF
require("nvim-autopairs").setup {}
EOF
