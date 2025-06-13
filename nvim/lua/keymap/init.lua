-- Builtin & Plugin keymaps
require("keymap.tool")

-- User keymaps
local ok, def = pcall(require, "user.keymap.init")
if ok then
    require("modules.utils.keymap").replace(def)
end
