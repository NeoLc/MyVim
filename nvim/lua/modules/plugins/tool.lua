local tool = {}
local settings = require("core.settings")

tool["nvim-tree/nvim-tree.lua"] = {
    lazy = true,
    cmd = {
        "NvimTreeToggle",
        "NvimTreeOpen",
        "NvimTreeFindFile",
        "NvimTreeFindFileToggle",
        "NvimTreeRefresh",
    },
    config = require("tool.nvim-tree"),
}

tool["folke/which-key.nvim"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("tool.which-key"),
}

tool["gelguy/wilder.nvim"] = {
    lazy = true,
    event = "CmdlineEnter",
    config = require("tool.wilder"),
    dependencies = { "romgrk/fzy-lua-native" },
}

tool["akinsho/toggleterm.nvim"] = {
    lazy = true,
    cmd = {
        "ToggleTerm",
        "ToggleTermSetName",
        "ToggleTermToggleAll",
        "ToggleTermSendVisualLines",
        "ToggleTermSendCurrentLine",
        "ToggleTermSendVisualSelection",
    },
    config = require("tool.toggleterm"),
}

return tool
