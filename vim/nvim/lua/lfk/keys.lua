vim.keymap.set('n', '<leader>K', 'ji')
vim.keymap.set('n', '<leader>J', 'J^')
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', '<leader>H', ':Hardtime toggle<cr>')
vim.keymap.set('n', '<leader>b', ':buffers<CR>:buffer<Space>')
vim.keymap.set('n', '<leader>i', ':setlocal list!<cr>')
vim.keymap.set('n', '<leader>l', ':source ~/.config/nvim/init.lua<cr>')
vim.keymap.set('n', '[e', ':m -2<CR>')
vim.keymap.set('n', ']e', ':m +1<CR>')
vim.keymap.set('n', '<leader>n', ':NERDTreeToggle<CR>')
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])
vim.keymap.set('n', '<leader>o', 'o<ESC>')
vim.keymap.set('n', '<leader>O', 'O<ESC>')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-f>', '<C-f>zz')
vim.keymap.set('n', '<C-b>', '<C-b>zz')
vim.keymap.set('n', '<leader><leader>', ',')
vim.keymap.set('v', '<leader>p', [["_dP]])
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set('n', "<C-Right>", "<C-w>l")
vim.keymap.set('n', "<C-Left>", "<C-w>h")
vim.keymap.set('n', "<C-Down>", "<C-w>j")
vim.keymap.set('n', "<C-Up>", "<C-w>k")

vim.opt.mouse = ""

-- document existing key chains
require('which-key').register {
    ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
    ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
    ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
    ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
    ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
    ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
    ['<leader>'] = { name = 'VISUAL <leader>' },
    ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })
