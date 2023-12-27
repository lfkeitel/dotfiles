return {
    'catppuccin/nvim',
    config = function()
        vim.cmd.colorscheme('catppuccin')
        vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    end
}
