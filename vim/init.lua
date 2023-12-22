local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","

require("lazy").setup({
    'catppuccin/nvim',
    'tpope/vim-sensible',
    'airblade/vim-gitgutter',
    'preservim/nerdtree',
    'ctrlpvim/ctrlp.vim',
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}
})

vim.cmd("colorscheme catppuccin")

vim.opt.number = true
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

vim.opt.wrapscan = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.magic = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true

vim.opt.tabstop = 4          -- How many spaces takes a tab character.
vim.opt.softtabstop = 4      -- The number of spaces a tab character counts for.
vim.opt.expandtab = true          -- Use spaces instead of tabs for indenting.
vim.opt.shiftwidth = 4       -- Autoindent width.
vim.opt.smarttab = true           -- A tab executes automatic indentation in insert mode.
vim.opt.smartindent = true        -- Adds automatic indentation on new line.
vim.opt.autoindent = true         -- Adds automatic indentation on copy paste as well.

vim.opt.listchars = "eol:$,tab:>-,trail:~,extends:>,precedes:<"
vim.cmd([[
    command! Wq wq
    command! W w
    command! Q q
]])

function map(mode, shortcut, command)
    vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
    map('n', shortcut, command)
end

function imap(shortcut, command)
    map('i', shortcut, command)
end

nmap("<leader>b", ":buffers<CR>:buffer<Space>")
nmap("<leader>i", ":setlocal list!<cr>")
nmap("<leader>l", ":source ~/.config/nvim/init.lua<cr>")

nmap("<leader>n", ":NERDTreeFocus<CR>")
nmap("<C-n>", ":NERDTree<CR>")
nmap("<C-t>", ":NERDTreeToggle<CR>")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

local nvim_lsp = require'lspconfig'

local on_attach = function(client)
    require'completion'.on_attach(client)
end

nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
})
nvim_lsp.gopls.setup{}

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
            cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
            else
            fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
            cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
            else
            fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}
