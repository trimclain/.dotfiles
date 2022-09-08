local status_ok, hop = pcall(require, "hop")
if not status_ok then
    return
end

hop.setup {
    keys = "asdghklqwertyuiopzxcvbnmfj",
    quit_key = "<SPC>", -- default: <Esc>
    jump_on_sole_occurrence = true,
    case_insensitive = true,
    create_hl_autocmd = true,
    uppercase_labels = false,
    current_line_only = false,
    multi_windows = false,
    hint_position = require("hop.hint").HintPosition.BEGIN,
    hint_offset = 0,
}
