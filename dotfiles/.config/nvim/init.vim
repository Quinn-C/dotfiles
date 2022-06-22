" General: Notes
  "
  " Based On: Samuel Roeca dotfiles (https://github.com/pappasam/dotfiles)
  "
  " Notes:
  "   * When in normal mode, scroll over a folded section and type 'za'
  "       this toggles the folded section
  "
  " Initialization:
  "   1. Install vim-packager by running:
  "      git clone https://github.com/kristijanhusak/vim-packager ~/.config/nvim/pack/packager/opt/vim-packager
  "   2. Open vim (hint: type vim at command line and press enter :p)
  "   3. Run `:PackInstall`
  "
  "   Available packager commands:
  "   * :PackInstall installs packages from the https/ssh url provided above.
  "   * :PackUpdate updates packages from the https/ssh url provided above.
  "   * :PackClean removes packages that are no longer in your s:pack_init function
  "   * :PackStatus prints the current status of your packages


" Packages: {{{
  " Note: vim-packer automaticalle executes UpdateRemotePlugin
  " Install: To install vim-packer run this:
  " git clone https://github.com/kristijanhusak/vim-packager ~/.config/nvim/pack/packager/opt/vim-packager

  function s:pack_init() abort
    "Vim packager stuff
    packadd vim-packager
    call packager#init()
    call packager#add('git@github.com:kristijanhusak/vim-packager', {'type': 'opt'})

    " COC
    call packager#add('git@github.com:neoclide/coc.nvim.git', {'branch': 'release'})
    call packager#add('git@github.com:pappasam/coc-jedi.git', {'do': 'yarn install --frozen-lockfile && yarn build'})

    " General plugins
    call packager#add('git@github.com:tpope/vim-commentary')
    call packager#add('git@github.com:tpope/vim-repeat')
    call packager#add('git@github.com:kien/ctrlp.vim')
    call packager#add('git@github.com:alvan/vim-closetag.git') " Web close tag
    call packager#add('git@github.com:ckarnell/Antonys-macro-repeater') " Macro repeater
    call packager#add('git@github.com:scrooloose/nerdtree') " File system explorer for vim

    " Syntax Theme:
    call packager#add('git@github.com:pappasam/papercolor-theme-slim.git')
    " call packager#add('git@github.com:NLKNguyen/papercolor-theme')

    " Indentation Only:
    call packager#add('git@github.com:Vimjas/vim-python-pep8-indent')

    " Syntax Highlight
    call packager#add('git@github.com:cespare/vim-toml')
    call packager#add('git@github.com:evanleck/vim-svelte')
    call packager#add('git@github.com:rust-lang/rust.vim')

    " Repl integration
    call packager#add('git@github.com:pappasam/nvim-repl.git')

    call packager#add('git@github.com:pappasam/vim-filetype-formatter')

    call packager#add('git@github.com:pantharshit00/vim-prisma')
    " call packager#add('git@github.com:')
  endfunction

  command!       PackInstall call s:pack_init() | call packager#install()
  command! -bang PackUpdate  call s:pack_init() | call packager#update({ 'force_hooks': '<bang>', 'on_finish': 'call packager#status()' })
  command!       PackClean   call s:pack_init() | call packager#clean()
  command!       PackStatus  call s:pack_init() | call packager#status()
" }}}

" General: Leader mappings {{{
  let mapleader = ","
  let maplocalleader = "\\"
" }}}

" General: global config ------------ {{{
  "A comma separated list of options for Insert mode completion
  "   menuone  Use the popup menu also when there is only one match.
  "            Useful when there is additional information about the
  "            match, e.g., what file it comes from.

  "   longest  Only insert the longest common text of the matches.  If
  "            the menu is displayed you can use CTRL-L to add more
  "            characters.  Whether case is ignored depends on the kind
  "            of completion.  For buffer text the 'ignorecase' option is
  "            used.

  "   preview  Show extra information about the currently selected
  "            completion in the preview window.  Only works in
  "            combination with 'menu' or 'menuone'.
  set completeopt=menuone,longest,preview

  " Case insensitive matching unless a capital leter is used
  set ignorecase
  set smartcase

  " Enable buffer deletion instead of having to write each buffer
  set hidden

  " Disable swap files
  set nobackup
  set noswapfile
  set nowritebackup

  " Enable filetype detection, plugins and indentation
  filetype plugin indent on

  " Single spaces after periods
  set nojoinspaces

  " Always display tabline
  set showtabline=2

  " Improve key timeout behaviour
    " don't timeout on mappings
    set notimeout
    " do timeout on terminal key codes
    set ttimeout

  " Explicitely set shell
  set shell=$SHELL

  " Mouse: enable GUI mouse support in all modes
  set mouse=a

  " Remove query for terminal version
  " This prevents un-editable garbage characters from being printed
  " after the 80 character highlight line
  set t_RV=

  set autoread

  " When you type the first tab hit will complete as much as possible,
  " the second tab hit will provide a list, the third and subsequent tabs
  " will cycle through completion options so you can complete the file
  " without further keys
  set wildmode=longest,list,full
  set wildmenu

  " Turn off complete vi compatibility
  set nocompatible

  " Enable using local vimrc ('.nvimrc', '_nvimrc', '.exrc')
  set exrc

  " Make sure numbering is set
  set number

  " Redraw window whenever I've regained focus
  augroup redraw_on_refocus
    autocmd!
    autocmd FocusGained * redraw!
  augroup end

  " Enable Truecolor if applicable
  if $COLORTERM ==# 'truecolor'
    set termguicolors
  else
    set guicursor=
  endif

  " Configure Update time: time vim waits to do something after I stop moving,
  " was in 750, updated to 300 coc-recommended
  set updatetime=300

  " Tabs: <tab> inserts 2 spaces, tabs already present occupy 8 spaces visually
  set expandtab
  set shiftwidth=2
  set softtabstop=2
  set tabstop=8

  " Spelling
  " set spellang=es " for spanish
  set spelllang=en_us
  " set spell

  " Enables by default 2 lines for messages, coc-recommended
  set cmdheight=2

  " Don't pass messages to 'floating menu'? coc-recommended
  " Dissabled cause not yet sure if I want it
  " set shortmess+=c

  " Always show signcolumn, used for diagnostics. coc-recommended
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  " coc-recommended
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Python provider
  let g:python3_host_prog = "$HOME/.asdf/shims/python"
  let g:loaded_python_provider = 0
" }}}

" COC: for IDE stuff ------------ {{{
  " Docs:
  function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
      execute 'help ' . expand('<cword>')
    else
      call CocActionAsync('doHover')
    endif
  endfunction

  " General Config:
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

  " Global Extensions: installed on Vim open
  let g:coc_global_extensions = [
    \ 'coc-go',
    \ 'coc-svelte',
    \ 'coc-docker',
    \ 'coc-markdownlint',
    \ 'coc-css',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-lists',
    \ 'coc-pairs',
    \ 'coc-rls',
    \ 'coc-sh',
    \ 'coc-snippets',
    \ 'coc-svg',
    \ 'coc-syntax',
    \ 'coc-tsserver',
    \ 'coc-vimlsp',
    \ 'coc-jedi',
    \ 'coc-word',
    \ 'coc-yaml',
    \ 'coc-yank',
    \ 'coc-diagnostic',
    \ 'coc-dictionary',
    \ 'coc-spell-checker',
    \ 'coc-texlab',
    \ 'coc-prisma',
    \ ]

  function! s:autocmd_custom_coc()
    if !exists("g:did_coc_loaded")
      return
    endif
    augroup custom_coc
      autocmd CursorHold * silent call CocActionAsync('highlight')
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
      " Coc nvim might override mappings, call them again just in case
      autocmd User CocNvimInit call s:default_key_mappings()
    augroup end
  endfunction

  augroup custom_coc
    autocmd!
    autocmd VimEnter * call s:autocmd_custom_coc()
  augroup end

  augroup custom_coc_pairs
    autocmd!
    autocmd FileType html let b:coc_pairs_disabled = ['<']
    autocmd FileType plantuml let b:coc_pairs_disabled = ["'"]
    autocmd FileType rust let b:coc_pairs_disabled = ["'"]
    autocmd FileType vim let b:coc_pairs_disabled = ['"']
  augroup end

  augroup custom_coc_additional_keyword_characters
    autocmd!
    autocmd FileType nginx let b:coc_additional_keywords = ['$']
    autocmd FileType zsh let b:coc_additional_keywords = ['-']
  augroup end

  " Diagnostics: ================================
  function! s:coc_diagnostic_disable()
    cal coc#config('diagnostic.enable', v:false)
    let g:coc_custom_diagnostic_enabled = v:false
    silent CocRestart
    echom 'Disabled: Coc Diagnostics'
  endfunction

  function! s:coc_diagnostic_enable()
    cal coc#config('diagnostic.enable', v:true)
    let g:coc_custom_diagnostic_enabled = v:true
    silent CocRestart
    echom 'Enabled: Coc Diagnostics'
  endfunction

  function! s:coc_diagnostic_toggle()
    if g:coc_custom_diagnostic_enabled == v:true
      call s:coc_diagnostic_disable()
    else
      call s:coc_diagnostic_enable()
    endif
  endfunction
  " =============================================

  function! s:coc_init()
    let g:coc_custom_diagnostic_enabled = v:false
    call s:coc_diagnostic_disable()
  endfunction

  augroup coc_initialization
    autocmd!
    autocmd VimEnter * call s:coc_init()
  augroup end

  command! CocDiagnosticToggle call s:coc_diagnostic_toggle()
  command! CocDiagnosticEnable call s:coc_diagnostic_enable()
  command! CocDiagnosticDisable call s:coc_diagnostic_disable()

  " coc-pairs to auto indent braces, parentheses, etc
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" }}}

" General: Filetype recognition ------------ {{{
  augroup custom_filetype_recognition
    autocmd!
    autocmd BufEnter *.asm set filetype=nasm
    autocmd BufEnter *.cfg,*.ini,.coveragerc,*pylintrc,zoomus.conf set filetype=dosini
    autocmd BufEnter *.config,.cookiecutterrc set filetype=yaml
    autocmd BufEnter *.go set filetype=go
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
    autocmd BufEnter Dockerfile.* set filetype=Dockerfile
    autocmd BufEnter Makefile.* set filetype=make
    autocmd BufEnter poetry.lock,Pipfile set filetype=toml
    autocmd BufEnter tsconfig.json,*.jsonc,.markdownlintrc set filetype=jsonc
    autocmd BufEnter .zshrc set filetype=sh
  augroup end
" }}}

" General: Indentation (tabs, spaces, width, etc)------------- {{{
  augroup custom_indentation
    autocmd!
    " 4 spaces per tab, not 2
    autocmd Filetype python,c,haskell,markdown,rust,rst,kv,nginx,asm,nasm,gdscript3
            \ setlocal shiftwidth=4 softtabstop=4
    " Use hard tabs, not spaces
    autocmd Filetype make,tsv,votl,go,gomod
            \ setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
    " Prevent auto-indenting from occuring
    autocmd Filetype yaml setlocal indentkeys-=<:>
    autocmd Filetype ron setlocal cindent
            \ cinkeys=0{,0},0(,0),0[,0],:,0#,!^F,o,O,e
            \ cinoptions+='(s,m2'
            \ cinoptions+='(s,U1'
            \ cinoptions+='j1'
            \ cinoptions+='J1'
  augroup end
" }}}

" Writing: Mainly for markdown {{{
  " augroup writing
  "  autocmd!
  "  " autocmd VimEnter * call s:abolish_correct()
  "  autocmd FileType markdown,rst,text,gitcommit
  "        \ setlocal wrap linebreak nolist
  "        \ | call textobj#sentence#init()
  "  autocmd FileType requirements setlocal nospell
  "  autocmd BufNewFile,BufRead *.html,*.tex setlocal wrap
  "  autocmd FileType markdown nnoremap <buffer> <leader>f :TableFormat<CR>
  " augroup end
" }}}

" General: Color column --------------- {{{
  " Set column to light grey at 80 characters
  set colorcolumn=80
  augroup custom_colorcolumn
    autocmd!
    autocmd FileType gitcommit setlocal colorcolumn=73 textwidth=72
    autocmd FileType html,text,markdown,rst,fzf setlocal colorcolumn=0
  augroup end
" }}}

" General: Folding Settings --------------- {{{
  set foldmethod=indent
  set foldnestmax=10
  set nofoldenable

  augroup custom_fold_setting
    autocmd!
    autocmd FileType vim,tmux,bash,zsh,sh
          \ setlocal foldmethod=marker foldnestmax=1 foldenable
    autocmd FileType markdown,rst
          \ setlocal nofoldenable
    autocmd FileType yaml setlocal nofoldenable foldmethod=indent foldnestmax=1
  augroup end
" }}}

" General: Trailing whitespace ------------- {{{
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
  endfunction()

  command! TrimWhitespace call <SID>trim_whitespace()

  augroup custom_fix_whitespace_save
    autocmd!
    autocmd BufWritePre * TrimWhitespace
  augroup end
" }}}

" General: Syntax highlighting ---------------- {{{
  " Papercolor: options
    let g:PaperColor_Theme_Options = {}
    let g:PaperColor_Theme_Options.theme = {}
  " Bold And Italics:
    let g:PaperColor_Theme_Options.theme.default = {
          \ 'allow_bold': 1,
          \ 'allow_italic': 1,
          \ }
  " Folds And Highlights:
    let g:PaperColor_Theme_Options.theme['default.dark'] = {}
    let g:PaperColor_Theme_Options.theme['default.dark'].override = {
          \ 'folded_bg': ['gray22', '0'],
          \ 'folded_fg': ['gray69', '0'],
          \ 'visual_fg': ['gray12', '0'],
          \ 'visual_bg': ['gray', '6'],
          \ }
  " Language Specific Overrides:
    let g:PaperColor_Theme_Options.language = {
          \   'python': {
          \     'highlight_builtins': 1,
          \   },
          \   'cpp': {
          \     'highlight_standard_library': 1,
          \   },
          \   'c': {
          \     'highlight_builtins': 1,
          \   }
          \ }
  " Load:
    try
      colorscheme PaperColorSlim
    catch
      echo 'An error occured while configuring Papercolor'
    endtry

  " Python: Highlight self and cls keyword in class definitions
    augroup python_syntax
      autocmd!
      autocmd FileType python syn keyword pythonBuiltinObj self
      autocmd FileType python syn keyword pythonBuiltinObj cls
    augroup end
" }}}

"  Plugin: Configure ------------ {{{
  " Python highlighting
    let g:python_highlight_space_errors = 0
    let g:python_highlight_all = 1

  " NERD Tree:
    autocmd StdinReadPre * let s:std_in=1
    " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

    let g:NERDTreeShowHidden = 1
    let g:NERDTreeMapOpenInTab = '<C-t>'
    let g:NERDTreeMapOpenSplit = '<C-s>'
    let g:NERDTreeMapOpenVSplit = '<C-v>'
    let g:NERDTreeShowLineNumbers = 1
    let g:NERDTreeCaseSensitiveSort = 0
    let g:NERDTreeWinPos = 'right'
    let g:NERDTreeWinSize = 35
    let g:NERDTreeAutoDeleteBuffer = 2
    let g:NERDTreeIgnore=[
      \'.env$[[dir]]',
      \'.env$[[file]]',
      \'.git$[[dir]]',
      \'.mypy_cache$[[dir]]',
      \'.pyc$[[file]]',
      \'.pytest_cache$[[dir]]',
      \'.tox$[[dir]]',
      \'__pycache__$[[dir]]',
      \'node_modules$[[dir]]'
      \'pip-wheel-metadata$[[dir]]',
      \'venv$[[dir]]',
      \'\.xlsx$[[file]]',
      \]
    nnoremap <silent> <space>h :NERDTreeToggle %<CR>

  " Jedi:
    " Python:
    " Open module, e.g. :Pyimport os (opens the os module)
    let g:jedi#popup_on_dot = 0
    let g:jedi#show_call_signatures = 0
    let g:jedi#auto_close_doc = 0
    let g:jedi#smart_auto_mappings = 0
    let g:jedi#force_py_version = 3

  " CtrlP:
    let g:ctrlp_working_path_mode = 'rw' " start from cwd
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    " open first in current window and others as hidden
    let g:ctrlp_open_multiple_files = '1r'
    let g:ctrlp_use_caching = 0

  " Mappings:
    " auto_vim_configuration creates space between where vim is opened and
    " closed in my bash terminal. This is annoying, so I disable and manually
    " configure. See 'set completeopt' in my global config for my settings
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#goto_command = "<C-]>"
    let g:jedi#documentation_command = "<leader>sd"
    let g:jedi#usages_command = "<leader>su"
    let g:jedi#rename_command = "<leader>r"

  " Web Close Tag:
    " These are the file extensions where this plugin is enabled.
    "
    let g:closetag_filenames = '*.html,*.xhtml,*.js,*.jsx,*.vue'

    " filetypes like xml, html, xhtml, ...
    " These are the file types where this plugin is enabled.
    "
    let g:closetag_filetypes = 'html,xhtml,javascript,javascript.jsx,jsx,vue'

    " integer value [0|1]
    " This will make the list of non-closing tags case-sensitive
    " (e.g. `<Link>` will be closed while `<link>` won't.)
    "
    let g:closetag_emptyTags_caseSensitive = 1

    " dict
    " Disables auto-close if not in a "valid" region (based on filetype)
    "
    let g:closetag_regions = {
        \ 'typescript.tsx': 'jsxRegion,tsxRegion',
        \ 'javascript': 'jsxRegion',
        \ 'javascript.jsx': 'jsxRegion',
        \ }

    " Shortcut for closing tags, default is '>'
    "
    let g:closetag_shortcut = '>'

    " Add > at current position without closing the current tag, default is ''
    "
    let g:closetag_close_shortcut = '<leader>>'

  " Code Formatter:
    " let g:vim_filetype_formatter_verbose = 1
    let g:vim_filetype_formatter_commands = {
          \ 'python': 'black - -q --line-length 79',
          \ 'css': 'npx -q prettier --parser css --stdin',
          \ 'less': 'npx -q prettier --parser less --stdin',
          \ 'html': 'npx -q prettier --parser html --stdin',
          \ }

    augroup mapping_vim_filetype_formatter
      autocmd FileType python,javascript,javascript.jsx,css,less,json,html
            \ nnoremap <silent> <buffer> <leader>f :FiletypeFormat<cr>
      autocmd FileType python,javascript,javascript.jsx,css,less,json,html
            \ vnoremap <silent> <buffer> <leader>f :FiletypeFormat<cr>
    augroup end
"  }}}

" General: Key remappings ----------------------- {{{
  " Put your key remappings here
  " Prefer nnoremap to nmap, inoremap to imap, and vnoremap to vmap

  function! s:default_key_mappings()
    " nnoremap <silent> <C-k> :wincmd k<CR>
    nnoremap <silent> <C-j> :wincmd j<CR>
    nnoremap <silent> <C-l> :wincmd l<CR>
    nnoremap <silent> <C-h> :wincmd h<CR>

    " FiletypeFormat:
      nnoremap <leader>f <cmd>FiletypeFormat<cr>
      vnoremap <leader>f :FiletypeFormat<cr>

    " Disable Ex Mode: to avoid opening it by mistake
      nnoremap Q <nop>

    " " Disable Arrow Keys: for normal mode and visual mode.
    "   nnoremap <Up> <nop>
    "   nnoremap <Down> <nop>
    "   nnoremap <Left> <nop>
    "   nnoremap <Right> <nop>
    "   vnoremap <Up> <nop>
    "   vnoremap <Down> <nop>
    "   vnoremap <Left> <nop>
    "   vnoremap <Right> <nop>

    " Copy With System Clipboard:
      vnoremap <leader>y "+y
      nnoremap <leader>y "+y

    " Paste From System Clipboard: easier paste
      " Normal mode paste checks whether the current line has text if yes,
      " insert new line, if no, start paste on current line
      nnoremap <expr> <leader>p
            \ len(getline('.')) == 0 ? '"+p' : 'o<esc>"+p'

    " Select Tab By Number:
      " MoveTabs: goto tab number. Same as Firefox
      nnoremap <A-1> 1gt
      nnoremap <A-2> 2gt
      nnoremap <A-3> 3gt
      nnoremap <A-4> 4gt
      nnoremap <A-5> 5gt
      nnoremap <A-6> 6gt
      nnoremap <A-7> 7gt
      nnoremap <A-8> 8gt
      nnoremap <A-9> 9gt

    " Escape Also Clears Highlighting:
      nnoremap <silent> <esc> :noh<return><esc>

    " Bad J is bad
      " unmap J in normal mode unless range explicitely specified
      nnoremap <silent> <expr> J v:count == 0 ? '<esc>' : 'J'

    " Search Backward: remap comma to single quote
      nnoremap ' ,

    " MoveVisual: up and down visually only if count is specified before
    " Otherwise, you want to move up lines numerically
      nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
      vnoremap <expr> k v:count == 0 ? 'gk' : 'k'
      nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
      vnoremap <expr> j v:count == 0 ? 'gj' : 'j'

    " Substitute: replace word under cursor
      nnoremap <leader><leader>s yiw:%s/\<<C-R>0\>//gc<Left><Left><Left>
      vnoremap <leader><leader>s y:%s/<C-R>0//gc<Left><Left><Left>

    " Relative Numbers: uses custom functions TODO
      nnoremap <silent> <leader>R <cmd>ToggleNumber<CR>
      nnoremap <silent> <leader>r <cmd>ToggleRelativeNumber<CR>

    " Choose Window: just like tmux TODO
      nnoremap <C-w>q <cmd>ChooseWin<CR>

    " Indent Lines: toggle if indent lines is visible TODO
      nnoremap <silent> <leader>i <cmd>IndentLinesToggle<CR>

    " Resize Window: up and down; relies on custom functions TODO
      nnoremap <silent> <leader><leader>h <cmd>ResizeWindowHeight<CR>
      nnoremap <silent> <leader><leader>w <cmd>ResizeWindowWidth<CR>

    " COC: settings for coc.nvim ============================================
      " Jump to definition
        nmap <silent> <C-]> <Plug>(coc-definition)
        nmap <silent> <C-LeftMouse> <Plug>(coc-defintion)

      " Show documentation
        nnoremap <silent> <C-k> :call <SID>show_documentation()<CR>
        inoremap <silent> <C-h> <cmd>call CocActionAsync('showSignatureHelp')<CR>

      " Use control space to trigger completion
        inoremap <silent><expr> <c-space> coc#refresh()

      " Scroll in floating windows
        nnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"
        nnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>"
        inoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-e>"
        inoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-y>"
        vnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"
        vnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>

      " Snippets
        imap     <silent> <expr> <C-l> coc#expandable() ? "<Plug>(coc-snippets-expand)" : "\<C-y>"

      " Diagnostics mappings
        nnoremap <silent> <leader>d :CocDiagnosticToggle<CR>
        nnoremap <silent> <leader>D <cmd>call CocActionAsync('diagnosticPreview')<CR>
        nmap     <silent> ]g <Plug>(coc-diagnostic-next)
        nmap     <silent> [g <Plug>(coc-diagnostic-prev)

      " No idea, but recommended
        nmap     <silent>        <leader>st <Plug>(coc-type-definition)
        nmap     <silent>        <leader>si <Plug>(coc-implementation)
        nmap     <silent>        <leader>su <Plug>(coc-references)
        nmap     <silent>        <leader>sr <Plug>(coc-rename)
        nmap     <silent>        <leader>sa v<Plug>(coc-codeaction-selected)
        vmap     <silent>        <leader>sa <Plug>(coc-codeaction-selected)
        nnoremap <silent>        <leader>sn <cmd>CocNext<CR>
        nnoremap <silent>        <leader>sp <cmd>CocPrev<CR>
        nnoremap <silent>        <leader>sl <cmd>CocListResume<CR>
        nnoremap <silent>        <leader>sc <cmd>CocList commands<cr>
        nnoremap <silent>        <leader>so <cmd>CocList -A outline<cr>
        nnoremap <silent>        <leader>sw <cmd>CocList -A -I symbols<cr>
        inoremap <silent> <expr> <CR> pumvisible() ? '<CR>' : '<C-g>u<CR><c-r>=coc#on_enter()<CR>'

    " Repl: my very own repl plugin
      nnoremap <leader><leader>e :ReplToggle<CR>
      nmap <leader>e <Plug>ReplSendLine
      vmap <leader>e <Plug>ReplSendVisual

    " Mouse Configuration: remaps mouse to work better in terminal
      " Out Jump List: <C-RightMouse> already mapped to something like <C-t>
      nnoremap <RightMouse> <C-o>
      vnoremap <RightMouse> "+y
      " inoremap <RightMouse> <S-C-v>

    " Format JSON Files:
      nnoremap <leader>fj :%!json_xs -f json -t json-pretty<CR>
      inoremap <leader>fj :%!json_xs -f json -t json-pretty<CR>

  endfunction

  call s:default_key_mappings()
" }}}

" General: Cleanup ------------------ {{{
  " commands that need to run at the end of my vimrc

  " disable unsafe commands in your project-specific .vimrc files
  " This will prevent :autocmd, shell and write commands from being
  " run inside project-specific .vimrc files unless they’re owned by you.
  set secure

  " ShowCommand: turn off character printing to vim status line
  set noshowcmd
" }}}
