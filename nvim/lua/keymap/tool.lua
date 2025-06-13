local vim_path = require("core.global").vim_path
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
--require("keymap.helpers")

local mappings = {
    plugins = {
        -- Plugin: nvim-tree
        ["n|<leader>s"] = map_cr("NvimTreeToggle"):with_noremap():with_silent():with_desc("filetree: Show file"),
        -- Plugin: toggleterm
        ["t|<Esc><Esc>"] = map_cmd([[<C-\><C-n>]]):with_noremap():with_silent(), -- switch to normal mode in terminal.
        ["n|<A-\\>"] = map_cr("ToggleTerm direction=float"):with_noremap():with_silent():with_desc("terminal: Toggle float"),
        --["n|<A-\\>"] = map_cr("ToggleTerm direction=vertical"):with_noremap():with_silent():with_desc("terminal: Toggle vertical"),
        --["n|<A-\\>"] = map_cr("ToggleTerm direction=horizontal"):with_noremap():with_silent():with_desc("terminal: Toggle horizontal"),
    },
}

bind.nvim_load_mapping(mappings.plugins)
