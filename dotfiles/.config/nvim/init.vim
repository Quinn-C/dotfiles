
echo " ' Welcome to',   /_  ___   \\"
echo " '    vim   `.   /@ \\/@  \\   \\"
echo "  `  >^_^< ' `.. \\__/\\___/   /"
echo "    , . , .       \\_\\/______/"
echo "                  /     /\\\\\\\\\\"
echo "                 |     |\\\\\\\\\\"
echo "                  \\      \\\\\\\\\\"
echo "                   \\______/\\\\\\\\"
echo "             _______ ||_||_______"
echo "            (______(((_(((______(@)"
" General: Notes
"
" Author: Samuel Roeca
" Date: August 15, 2017
" TLDR: vimrc minimum viable product for Python programming
"
" I've noticed that many vim/neovim beginners have trouble creating a useful
" vimrc. This file is intended to get a Python programmer who is new to vim
" set up with a vimrc that will enable the following:
"   1. Sane editing of Python files
"   2. Sane defaults for vim itself
"   3. An organizational skeleton that can be easily extended
"
" Notes:
"   * When in normal mode, scroll over a folded section and type 'za'
"       this toggles the folded section
"
" Initialization:
"   1. Follow instructions at https://github.com/junegunn/vim-plug to install
"      vim-plug for either Vim or Neovim
"   2. Open vim (hint: type vim at command line and press enter :p)
"   3. :PlugInstall
"   4. :PlugUpdate
"   5. You should be ready for MVP editing
"
" Updating:
"   If you want to upgrade your vim plugins to latest version
"     :PlugUpdate
"   If you want to upgrade vim-plug itself
"     :PlugUpgrade
"
" General: packages {{{

if &compatible
  set nocompatible
endif

function! s:packager_init(packager) abort
  call a:packager.add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call a:packager.add('junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'})
  call a:packager.add('junegunn/fzf.vim')
  call a:packager.add('vimwiki/vimwiki', { 'type': 'opt' })
  call a:packager.add('Shougo/deoplete.nvim')
  call a:packager.add('autozimu/LanguageClient-neovim', { 'do': 'bash install.sh' })
  call a:packager.add('morhetz/gruvbox')
  call a:packager.add('lewis6991/gitsigns.nvim', {'requires': 'nvim-lua/plenary.nvim'})
  call a:packager.add('haorenW1025/completion-nvim', {'requires': [
  \ ['nvim-treesitter/completion-treesitter', {'requires': 'nvim-treesitter/nvim-treesitter'}],
  \ {'name': 'steelsojka/completion-buffers', 'opts': {'type': 'opt'}},
  \ 'kristijanhusak/completion-tags',
  \ ]})
  call a:packager.add('hrsh7th/vim-vsnip-integ', {'requires': ['hrsh7th/vim-vsnip'] })
  call a:packager.local('~/my_vim_plugins/my_awesome_plugin')

  "Loaded only for specific filetypes on demand. Requires autocommands below.
  call a:packager.add('kristijanhusak/vim-js-file-import', { 'do': 'npm install', 'type': 'opt' })
  call a:packager.add('fatih/vim-go', { 'do': ':GoInstallBinaries', 'type': 'opt' })

  call a:packager.add('sonph/onehalf', {'rtp': 'vim/'})
  " Tree:
  call a:packager.add('git@github.com:kyazdani42/nvim-tree.lua.git', {'requires': [
      \ 'git@github.com:kyazdani42/nvim-web-devicons.git',
      \ ]})
  " Markdown preview
  call packager#add('iamcco/markdown-preview.nvim' , { 'do': ':call mkdp#util#install()' })

  " Markdown linter
  call packager#add('git@github.com:fannheyward/coc-markdownlint.git', {
      \ 'do': 'yarn install --frozen-lockfile && yarn build',
      \ })


endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'))

" }}}
" General: Leader mappings {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" General: global config {{{

" Code Completion:
set completeopt=menuone,longest,preview
set wildmode=longest,list,full
set wildmenu

" Hidden Buffer: enable instead of having to write each buffer
set hidden

" Mouse: enable GUI mouse support in all modes
set mouse=a

" SwapFiles: prevent their creation
set nobackup
set noswapfile

" Line Wrapping: do not wrap lines by default
set nowrap

" Highlight Search:
set incsearch
set inccommand=nosplit
augroup sroeca_incsearch_highlight
    autocmd!
    autocmd CmdlineEnter /,\? set hlsearch
    autocmd CmdlineLeave /,\? set nohlsearch
augroup END

filetype plugin indent on

" Spell Checking:
set dictionary=$HOME/.american-english-with-propcase.txt
set spelllang=en_us

" Single Space After Punctuation: useful when doing :%j (the opposite of gq)
set nojoinspaces

set showtabline=2

" Display Sign (errors for debugs) in number column
set signcolumn=number

set autoread

set grepprg=rg\ --vimgrep

" Paste: this is actually typed <C-/>, but term nvim thinks this is <C-_>
set pastetoggle=<C-_>

set notimeout   " don't timeout on mappings
set ttimeout    " do timeout on terminal key codes

" Local Vimrc: If exrc is set, the current directory is searched for 3 files
" in order (Unix), using the first it finds: '.nvimrc', '_nvimrc', '.exrc'
set exrc

" Default Shell:
set shell=$SHELL

" Numbering:
set number

" Window Splitting: Set split settings (options: splitright, splitbelow)
set splitright

" Redraw Window:
augroup redraw_on_refocus
    autocmd!
    autocmd FocusGained * redraw!
augroup END

" Terminal Color Support: only set guicursor if truecolor
if $COLORTERM ==# 'truecolor'
    set termguicolors
else
    set guicursor=
endif

" Default Background:
set background=dark

" Lightline: specifics for Lightline
set laststatus=2
set ttimeoutlen=50
set noshowmode

" ShowCommand: turn off character printing to vim status line
set noshowcmd

" Configure Updatetime: time Vim waits to do something after I stop moving
set updatetime=300

" Add a visual ruler (color column) at a specific line.
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lighgrey
" Linux Dev Path: system libraries
set path+=/usr/include/x86_64-linux-gnu/

" }}}
" General: Plugin Install {{{

call plug#begin('~/.vim/plugged')

" Help for vim-plug
Plug 'junegunn/vim-plug'

" Make tabline prettier
Plug 'kh3phr3n/tabline'

" Commands run in vim's virtual screen and don't pollute main shell
Plug 'fcpg/vim-altscreen'

" Basic coloring
Plug 'pappasam/papercolor-theme-slim'

" Utils
Plug 'tpope/vim-commentary'

" Language-specific syntax
Plug 'vim-python/python-syntax'

" Indentation
Plug 'Vimjas/vim-python-pep8-indent'

" CoC features
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" }}}
" General: Status Line and Tab Line {{{

" Tab Line:
set tabline=%t

" Status Line:
set laststatus=2
set statusline=
set statusline+=\ %{mode()}\  " spaces after mode
set statusline+=%#CursorLine#
set statusline+=\   " space
set statusline+=%{&paste?'[PASTE]':''}
set statusline+=%{&spell?'[SPELL]':''}
set statusline+=%r
set statusline+=%m
set statusline+=%{get(b:,'gitbranch','')}
set statusline+=\   " space
set statusline+=%*  " Default color
set statusline+=\ %f
set statusline+=%=
set statusline+=%n  " buffer number
set statusline+=\ %y\  " File type
set statusline+=%#CursorLine#
set statusline+=\ %{&ff}\  " Unix or Dos
set statusline+=%*  " Default color
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}\  " file encoding
augroup statusline_local_overrides
    autocmd!
    autocmd FileType nerdtree setlocal statusline=\ NERDTree\ %#CursorLine#
augroup END

" Strip newlines from a string
function! StripNewlines(instring)
    return substitute(a:instring, '\v^\n*(.{-})\n*$', '\1', '')
endfunction

function! StatuslineGitBranch()
    let b:gitbranch = ''
    if &modifiable
        try
            let branch_name = StripNewlines(system(
                        \ 'git -C ' .
                        \ expand('%:p:h') .
                        \ ' rev-parse --abbrev-ref HEAD'))
            if !v:shell_error
                let b:gitbranch = '[git::' . branch_name . ']'
            endif
        catch
        endtry
    endif
endfunction

augroup get_git_branch
    autocmd!
    autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

" }}}
" General: Indentation (tabs, spaces, width, etc) {{{

augroup indentation_sr
    autocmd!
    autocmd Filetype * setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
    autocmd Filetype python setlocal shiftwidth=4 softtabstop=4 tabstop=8
    autocmd Filetype yaml setlocal indentkeys-=<:>
augroup END

" }}}
" General: Folding Settings {{{

augroup fold_settings
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldlevelstart=0
  autocmd FileType * setlocal foldnestmax=1
augroup END

" }}}
" General: Trailing whitespace {{{

" This section should go before syntax highlighting
" because autocommands must be declared before syntax library is loaded
function! TrimWhitespace()
  if &ft == 'markdown'
    return
  endif
  let l:save = winsaveview()
  %s/\s\+$//e
  call winrestview(l:save)
endfunction

highlight EOLWS ctermbg=red guibg=red
match EOLWS /\s\+$/
augroup whitespace_color
  autocmd!
  autocmd ColorScheme * highlight EOLWS ctermbg=red guibg=red
  autocmd InsertEnter * highlight EOLWS NONE
  autocmd InsertLeave * highlight EOLWS ctermbg=red guibg=red
augroup END

augroup fix_whitespace_save
  autocmd!
  autocmd BufWritePre * call TrimWhitespace()
augroup END

" }}}
" General: Syntax highlighting {{{
try
  colorscheme PaperColorSlim
catch
  echo 'An error occured while configuring PaperColor'
endtry

"Filetype recognition to make vim automatically recognize them {{{
augroup custom_filetype_recognition
  autocmd!
  autocmd BufEnter *.asm set filetype=nasm
  autocmd BufEnter *.cfg,*.ini,.coveragerc,*pylintrc,zoomus.conf set filetype=dosini
  autocmd BufEnter *.config,.cookiecutterrc set filetype=yaml
  autocmd BufEnter *.handlebars set filetype=html
  autocmd BufEnter *.hql,*.q set filetype=hive
  autocmd BufEnter *.js,*.gs set filetype=javascript
  autocmd BufEnter *.min.js set filetype=none
  autocmd BufEnter *.m,*.oct set filetype=octave
  autocmd BufEnter *.py.j2 set filetype=python.jinja2
  autocmd BufEnter *.sql.j2 set filetype=sql.jinja2
  autocmd BufEnter *.toml set filetype=toml
  autocmd BufEnter *.tsv set filetype=tsv
  autocmd BufEnter .envrc set filetype=sh
  autocmd BufEnter .gitignore,.dockerignore set filetype=conf
  autocmd BufEnter .jrnl_config,*.bowerrc,*.babelrc,*.eslintrc,*.slack-term set filetype=json
  autocmd BufEnter Dockerfile.* set filetype=dockerfile
  autocmd BufEnter Makefile.* set filetype=make
  autocmd BufEnter poetry.lock,Pipfile set filetype=toml
  autocmd BufEnter tsconfig.json,*.jsonc,.markdownlintrc set filetype=jsonc
  autocmd BufEnter .bashrc set filetype=sh
augroup end
"}}}

" Add shebang line automatically in every new Python file {{{
augroup template
  autocmd!
  autocmd BufNewFile *.py
        \ normal i#!/usr/bin/env python3
augroup END
" }}}
"Indentation overrides {{{
augroup custom_indentation
  autocmd!
  " 4 spaces per tab, not 2
  autocmd Filetype python,c,haskell,rust,kv,nginx,asm,nasm,gdscript3 setlocal shiftwidth=4 softtabstop=4
  " Use hard tabs, not spaces
  autocmd Filetype make,tsv,votl,go,gomod setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  " Prevent auto-indenting from occuring
  autocmd Filetype yaml setlocal indentkeys-=<:>
augroup end
" }}}

" A column help you to aviod long line {{{
augroup custom_colorcolumn
  autocmd!
  autocmd FileType gitcommit setlocal colorcolumn=73 textwidth=72
  autocmd Filetype html,text,markdown,rst,fzf setlocal colorcolumn=0
augroup end
"}}}


" Long dotfiles be able to fold {{{
augroup custom_fold_settings
  autocmd!
  autocmd FileType vim,tmux,bash,zsh,sh setlocal foldenable foldmethod=marker foldnestmax=1
  autocmd FileType markdown,rst setlocal nofoldenable
  autocmd FileType yaml setlocal nofoldenable foldmethod=indent foldnestmax=1
augroup end
"}}}

" Indentation and line wrapping
autocmd FileType markdown
  \ setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8 wrap linebreak nolist colorcolumn=0 nofoldenable


"  Plugin: Configure {{{

" Plugin: vim-markdown
" Plugin: vim-markdown
let g:vim_markdown_frontmatter = v:true
let g:vim_markdown_toml_frontmatter = v:true
let g:vim_markdown_json_frontmatter = v:true
let g:vim_markdown_no_default_key_mappings = v:true
let g:vim_markdown_strikethrough = v:true
let g:vim_markdown_folding_disabled = v:true
let g:vim_markdown_auto_insert_bullets = v:false
let g:vim_markdown_new_list_item_indent = v:false

" Plugin: bullets.vim
let g:bullets_enabled_file_types = [
      \ 'markdown',
      \ 'text',
      \ 'gitcommit',
      \ 'scratch',
      \ 'rst',
      \ ]

" Plugin: Markdown-preview.vim
" Gives you command :MarkdownPreview
" New vim version 'v:false' means 0

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

" Python highlighting
let g:python_highlight_space_errors = 0
let g:python_highlight_all = 1

"  }}}
"
" Set command to start Python3 to make startup faster. Python Provider {{{
let g:python3_host_prog = "$HOME/.asdf/shims/python"
let g:loaded_python_provider = 0
"
"  }}}
" General: Key remappings {{{

" Coc:
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'
let g:coc_start_at_startup = 1
let g:coc_filetype_map = {
      \ 'python.jinja2': 'python',
      \ 'sql.jinja2': 'sql',
      \ 'yaml.ansible': 'yaml',
      \ 'yaml.docker-compose': 'yaml',
      \ 'jinja.html': 'html',
      \ }

" Coc Global Extensions: automatically installed on Vim open
let g:coc_global_extensions = [
      \ '@yaegassy/coc-nginx',
      \ 'coc-angular',
      \ 'coc-css',
      \ 'coc-diagnostic',
      \ 'coc-dictionary',
      \ 'coc-docker',
      \ 'coc-emoji',
      \ 'coc-go',
      \ 'coc-html',
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-markdownlint',
      \ 'coc-rls',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-svelte',
      \ 'coc-svg',
      \ 'coc-syntax',
      \ 'coc-texlab',
      \ 'coc-toml',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-word',
      \ 'coc-yaml',
      \ 'coc-yank',
      \ ]

function! s:autocmd_custom_coc()
  if !exists("g:did_coc_loaded")
    return
  endif
  augroup custom_coc
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    " Coc nvim might override my mappings. I call them again just in case.
    autocmd User CocNvimInit call s:default_key_mappings()
  augroup end
endfunction

augroup custom_coc
  autocmd!
  autocmd VimEnter * call s:autocmd_custom_coc()
  autocmd User CocNvimInit * call s:default_key_mappings()
augroup end

augroup custom_coc_additional_keyword_characters
  autocmd!
  autocmd FileType nginx let b:coc_additional_keywords = ['$']
augroup end

  " Coc: settings for coc.nvim
  nmap     <silent>        <C-]> <Plug>(coc-definition)
  nmap     <silent>        <C-LeftMouse> <Plug>(coc-definition)
  nnoremap <silent>        <C-k> <Cmd>call CocActionAsync('doHover')<CR>
  inoremap <silent>        <C-s> <Cmd>call CocActionAsync('showSignatureHelp')<CR>
  nnoremap <silent>        <C-w>f <Cmd>call coc#float#jump()<CR>
  nmap     <silent>        <leader>st <Plug>(coc-type-definition)
  nmap     <silent>        <leader>si <Plug>(coc-implementation)
  nmap     <silent>        <leader>su <Plug>(coc-references)
  nmap     <silent>        <leader>sr <Plug>(coc-rename)
  nmap     <silent>        <leader>sa v<Plug>(coc-codeaction-selected)
  vmap     <silent>        <leader>sa <Plug>(coc-codeaction-selected)
  nnoremap <silent>        <leader>sn <Cmd>CocNext<CR>
  nnoremap <silent>        <leader>sp <Cmd>CocPrev<CR>
  nnoremap <silent>        <leader>sl <Cmd>CocListResume<CR>
  nnoremap <silent>        <leader>sc <Cmd>CocList commands<cr>
  nnoremap <silent>        <leader>so <Cmd>CocList -A outline<cr>
  nnoremap <silent>        <leader>sw <Cmd>CocList -A -I symbols<cr>
  inoremap <silent> <expr> <c-space> coc#refresh()

  nnoremap <silent> <nowait> <expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"
  nnoremap <silent> <nowait> <expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>"
  inoremap <silent> <nowait> <expr> <C-e> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-e>"
  inoremap <silent> <nowait> <expr> <C-y> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-y>"
  vnoremap <silent> <nowait> <expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"
  vnoremap <silent> <nowait> <expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>"

  imap     <silent> <expr> <C-l> coc#expandable() ? "<Plug>(coc-snippets-expand)" : "\<C-y>"
  inoremap <silent> <expr> <CR> pumvisible() ? '<CR>' : '<C-g>u<CR><c-r>=coc#on_enter()<CR>'
  nnoremap                 <leader>d <Cmd>call CocActionAsync('diagnosticToggle')<CR>
  nnoremap                 <leader>D <Cmd>call CocActionAsync('diagnosticPreview')<CR>
  nmap     <silent>        ]g <Plug>(coc-diagnostic-next)
  nmap     <silent>        [g <Plug>(coc-diagnostic-prev)

function! GlobalKeyMappings()
  " Put your key remappings here
  " Prefer nnoremap to nmap, inoremap to imap, and vnoremap to vmap
  " This is defined as a function to allow me to reset all my key remappings
  " without needing to repeat myself.

  " MoveVisual: up and down visually only if count is specified before
  " Otherwise, you want to move up lines numerically e.g. ignore wrapped lines
  nnoremap <expr> k
        \ v:count == 0 ? 'gk' : 'k'
  vnoremap <expr> k
        \ v:count == 0 ? 'gk' : 'k'
  nnoremap <expr> j
        \ v:count == 0 ? 'gj' : 'j'
  vnoremap <expr> j
        \ v:count == 0 ? 'gj' : 'j'
  nnoremap <leader>ev :vsplit $MYVIMRC
  nnoremap <leader>sv :source $MYVIMRC
  inoremap <leader>dq <esc>ea"<esc>bi"
  inoremap <leader>sq <esc>ea'<esc>bi'
  inoremap jk <esc>
  inoremap <esc> <nop>
  " Escape: also clears highlighting
  nnoremap <silent> <esc> :noh<return><esc>

  " J: basically, unmap in normal mode unless range explicitly specified
  nnoremap <silent> <expr> J v:count == 0 ? '<esc>' : 'J'

  " Clipboard Copy Paste: Visual mode copy is pretty simple
  vnoremap <leader>y "+y
  nnoremap <leader>y "+y

  " Disable arrow keys: Stickler mode
  nnoremap <Up> <nop>
  nnoremap <Down> <nop>
  nnoremap <Left> <nop>
  nnoremap <Right> <nop>
  inoremap <Up> <nop>
  inoremap <Down> <nop>
  inoremap <Left> <nop>
  inoremap <Right> <nop>
  vnoremap <Up> <nop>
  vnoremap <Down> <nop>
  vnoremap <Left> <nop>
  vnoremap <Right> <nop>

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


endfunction

call GlobalKeyMappings()

" }}}
" General: Cleanup {{{
" commands that need to run at the end of my vimrc

" disable unsafe commands in your project-specific .vimrc files
" This will prevent :autocmd, shell and write commands from being
" run inside project-specific .vimrc files unless they’re owned by you.
set secure

" }}}
