local completion = {}
local use_copilot = require("core.settings").use_copilot

completion["neovim/nvim-lspconfig"] = {
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = require("completion.lsp"),
    dependencies = {
        { "mason-org/mason.nvim" },
        { "mason-org/mason-lspconfig.nvim" },
        { "folke/neoconf.nvim" },
        {
            "Jint-lzxy/lsp_signature.nvim",
            config = require("completion.lsp-signature")
        },
    },
}

completion["hrsh7th/nvim-cmp"] = {
    lazy = true,
    event = "InsertEnter",
    config = require("completion.cmp"),
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
            config = require("completion.luasnip"),
            dependencies = { "rafamadriz/friendly-snippets" },
        },
        { "lukas-reineke/cmp-under-comparator" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "andersevenrud/cmp-tmux" },
        { "hrsh7th/cmp-path" },
        { "f3fora/cmp-spell" },
        { "hrsh7th/cmp-buffer" },
        { "kdheepak/cmp-latex-symbols" },
        { "ray-x/cmp-treesitter", commit = "c8e3a74" },
    },
}

return completion
