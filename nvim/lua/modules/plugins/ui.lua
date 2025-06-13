local ui = {}

ui["goolord/alpha-nvim"] = {
    lazy = true,
    event = "BufWinEnter",
    config = require("ui.alpha"),
}

ui["akinsho/bufferline.nvim"] = {
    lazy = true,
    event = { "BufReadPre", "BufAdd", "BufNewFile" },
    config = require("ui.bufferline"),
}

ui["Jint-lzxy/nvim"] = {
    lazy = false,
    branch = "refactor/syntax-highlighting",
    name = "catppuccin",
    config = require("ui.catppuccin"),
}

ui["lukas-reineke/indent-blankline.nvim"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("ui.indent-blankline"),
}

ui["nvim-lualine/lualine.nvim"] = {
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = require("ui.lualine"),
}

return ui




