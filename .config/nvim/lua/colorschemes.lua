return {
    {
        "rebelot/kanagawa.nvim", 
    },
    {
        "Shatur/neovim-ayu", 
        config = function()
            vim.cmd.colorscheme("ayu-mirage")
        end,
    },
    {
        "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000 
    }
}

