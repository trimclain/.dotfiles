-- Icons used everywhere in the config

-- https://github.com/microsoft/vscode/blob/main/src/vs/base/common/codicons.ts
-- go to the above and then enter <c-v>u<unicode> and the symbold should appear
-- or go here and upload the font file: https://mathew-kurian.github.io/CharacterMap/
-- you can also find more icons here: https://www.nerdfonts.com/cheat-sheet

M = {}

M.diagnostics = { -- referenced
    -- BoldError = "",
    Error = "", -- referenced
    BoldWarn = "", -- referenced
    Warn = "", -- referenced
    -- BoldInfo = "",
    Info = "", -- referenced
    -- BoldQuestion = "",
    -- Question = "",
    -- BoldHint = "",
    -- Hint = "",
    Hint = "󰌶", -- referenced
    -- Debug = "",
    -- Trace = "✎",
}
M.git = {
    -- Add = "",
    Add = "", -- referenced
    -- Mod = "",
    Mod = "", -- referenced
    -- Remove = "",
    Remove = "", -- referenced
    Ignore = "",
    Rename = "",
    -- Diff = "",
    Diff = "",
    Repo = "",
    -- FileDeleted = "",
    -- FileIgnored = "◌",
    -- FileRenamed = "",
    -- FileStaged = "S",
    -- FileUnmerged = "",
    -- FileUnstaged = "",
    -- FileUntracked = "U",
    -- Branch = "",
}

--- LSP symbol kinds.
M.kinds = { -- referenced
    Array = "",
    Boolean = "",
    Class = "",
    Color = "",
    Constant = "", -- "", "󰏿"
    Constructor = "", -- "", ""
    Copilot = "",
    Enum = "", -- ""
    EnumMember = "", -- ""
    Event = "", -- ""
    Field = "󰜢", -- ""
    File = "", -- ""
    Folder = "", -- ""
    Function = "󰊕", -- ""
    Interface = "", -- ""
    Key = "",
    Keyword = "󰌋", -- ""
    Misc = "",
    Method = "󰊕", -- ""
    Module = "",
    Namespace = "",
    Null = "󰟢", -- ""
    Number = "",
    Object = "",
    Operator = "󱓉", -- ""
    Package = "", -- ""
    Property = "", -- ""
    Reference = "", -- ""
    Snippet = "", -- "", ""
    String = "", -- ""
    Struct = "", -- ""
    Text = "󰊄", -- "", ""
    TypeParameter = "",
    Unit = "", -- ""
    Value = "󰎠", -- ""
    Variable = "󰀫", -- ""
}
---------------------------------------------------------------------------

-- TODO: separate these into different tables
M.ui = {
    ArrowCircleDown = "",
    ArrowCircleLeft = "",
    ArrowCircleRight = "",
    ArrowCircleUp = "",
    -- ArrowClosed = "",
    ArrowClosed = "", -- referenced
    -- ArrowOpen = "",
    ArrowOpen = "", -- referenced
    ArrowClosedSmall = "", -- referenced
    ArrowOpenSmall = "", -- referenced
    -- BigCircle = "",
    BigCircle = "",
    BigUnfilledCircle = "",
    BoldArrowDown = "",
    BoldArrowLeft = "",
    BoldArrowRight = "",
    BoldArrowUp = "",
    BoldClose = "",
    BoldDividerLeft = "",
    BoldDividerRight = "",
    BoldLineLeft = "▎", -- referenced
    -- BookMark = "",
    BookMark = "",
    -- BoxChecked = "",
    BoxChecked = "󰄵", -- referenced
    -- Bug = "",
    Bug = "", -- referenced
    -- Calendar = "",
    Calendar = "",
    -- Check = "",
    Check = "", -- referenced
    ChevronRight = "",
    ChevronDown = "",
    ChevronShortDown = "",
    ChevronShortLeft = "",
    ChevronShortRight = "",
    ChevronShortUp = "",
    -- Circle = "",
    Circle = "●", -- referenced
    Clock = "", -- referenced
    Close = "",
    -- CloudDownload = "",
    CloudDownload = "",
    -- Code = "",
    Code = "",
    Comment = "",
    -- Dashboard = "",
    Dashboard = "",
    DashedLine = "┊", -- referenced
    DebugConsole = "",
    DividerLeft = "",
    DividerRight = "",
    DoubleCheck = "", -- referenced
    DoubleChevronRight = "»",
    Ellipsis = "",
    EmptyFolder = "",
    EmptyFolderOpen = "",
    File = "", -- duplicate of kinds
    FileSymlink = "",
    Files = "", -- referenced
    FindFile = "󰈞",
    FindText = "󰊄",
    -- Fire = "",
    Fire = "", -- referenced
    Folder = "󰉋", -- duplicate of kinds
    -- FolderOpen = "",
    FolderOpen = "",
    FolderSymlink = "",
    Forward = "  ", -- referenced
    -- Gear = "",
    Gear = "", -- referenced
    GitFolder = "", -- referenced
    History = "",
    Lazy = "󰒲", -- referenced
    Lightbulb = "",
    LineLeft = "▏", -- referenced
    LineMiddle = "│",
    -- List = "",
    List = "", -- referenced
    Lock = "", -- referenced
    Message = "󰍩", --referenced
    MidCircle = "",
    MidDottedCircle = "",
    MidUnfilledCircle = "",
    -- NewFile = "",
    NewFile = " ", -- referenced
    Note = "",
    NoteBook = "",
    Package = "", -- duplicate of kinds
    Paragraph = "󰊆",
    Pencil = "",
    Plus = "",
    -- Project = "",
    Project = "",
    Scopes = "",
    -- Search = "",
    Search = "", -- referenced
    -- SignIn = "",
    SignIn = "",
    -- SignOut = "",
    SignOut = "", -- referenced
    -- Speedometer = "⏲",
    Speedometer = "󰾆", -- referenced
    Stacks = "",
    Tab = "󰌒", -- referenced
    -- Table = "",
    Table = "",
    Target = "󰀘",
    -- Telescope = "",
    Telescope = "",
    Tree = "",
    Triangle = "󰐊",
    TriangleShortArrowDown = "",
    TriangleShortArrowLeft = "",
    TriangleShortArrowRight = "",
    TriangleShortArrowUp = "",
    UnicodeBallotX = "✗", -- referenced
    UnicodeCheck = "✓", -- referenced
    UnicodeCircleArrow = "⟳", -- referenced
    Watches = "󰂥",
}

M.misc = {
    Robot = "",
    Squirrel = "", -- ""
    Tag = "", -- ""
    Vim = "", -- referenced
    Watch = "",
}

return M
