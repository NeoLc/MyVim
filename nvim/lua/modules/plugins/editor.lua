local editor = {}

editor["olimorris/persisted.nvim"] = {
    lazy = true,
    cmd = {
        "SessionToggle",
        "SessionStart",
        "SessionStop",
        "SessionSave",
        "SessionLoad",
        "SessionLoadLast",
        "SessionLoadFromFile",
        "SessionDelete",
    },
    config = require("editor.persisted"),
}

--editor["numToStr/Comment.nvim"] = {
--    lazy = true,
--    event = { "CursorHold", "CursorHoldI" },
--    config = require("editor.comment"),
--}

editor["brenoprata10/nvim-highlight-colors"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("editor.highlight-colors"),
}

editor["romainl/vim-cool"] = {
    lazy = true,
    event = { "CursorMoved", "InsertEnter" },
}

return editor
