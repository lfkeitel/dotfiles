vim.cmd("highlight ColorColumn guifg=White guibg=#592929 ctermbg=red ctermfg=white")
vim.opt.colorcolumn = "80,100"

vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.laststatus = 2
vim.opt.showmatch = true
vim.opt.scrolloff = 2
vim.opt.lazyredraw = true
vim.opt.scrolljump = 0
vim.opt.showcmd = true
vim.opt.ttyfast = true
vim.opt.startofline = false
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.mouse = ""

vim.opt.wrapscan = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.magic = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true

vim.opt.tabstop = 4        -- How many spaces takes a tab character.
vim.opt.softtabstop = 4    -- The number of spaces a tab character counts for.
vim.opt.expandtab = true   -- Use spaces instead of tabs for indenting.
vim.opt.shiftwidth = 4     -- Autoindent width.
vim.opt.smarttab = true    -- A tab executes automatic indentation in insert mode.
vim.opt.smartindent = true -- Adds automatic indentation on new line.
vim.opt.autoindent = true  -- Adds automatic indentation on copy paste as well.

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.listchars = "eol:$,tab:>-,trail:~,extends:>,precedes:<"
-- Common shift mistakes
vim.cmd([[
    command! Wq wq
    command! W w
    command! Q q
]])

-- Format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
