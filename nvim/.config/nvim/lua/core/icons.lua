-- Icons used by other plugins

-- https://github.com/microsoft/vscode/blob/main/src/vs/base/common/codicons.ts
-- go to the above and then enter <c-v>u<unicode> and the symbold should appear
-- or go here and upload the font file: https://mathew-kurian.github.io/CharacterMap/
-- you can also find more icons here: https://www.nerdfonts.com/cheat-sheet

return {
    diagnostics = { -- referenced
        BoldError = "",
        Error = " ",
        BoldWarn = " ",
        Warn = " ",
        BoldInfo = " ",
        Info = " ",
        BoldQuestion = " ",
        Question = " ",
        BoldHint = " ",
        -- Hint = " ",
        Hint = "󰌶 ",
        Debug = "",
        Trace = "✎",
    },
    git = {
        -- Add = " ",
        Add = " ", -- referenced
        -- Mod = " ",
        Mod = " ", -- referenced
        -- Remove = " ",
        Remove = " ", -- referenced
        Ignore = " ",
        Rename = " ",
        -- Diff = "",
        Diff = " ",
        Repo = " ",
        -- FileDeleted = " ",
        -- FileIgnored = "◌",
        -- FileRenamed = " ",
        -- FileStaged = "S",
        -- FileUnmerged = "",
        -- FileUnstaged = "",
        -- FileUntracked = "U",
        -- Branch = "",
    },
    kinds = { -- referenced
        Array = " ",
        Boolean = " ",
        Class = " ",
        Color = " ",
        -- Constant = " ",
        -- Constant = "󰏿 ",
        Constant = " ",
        -- Constructor = " ",
        -- Constructor = " ",
        Constructor = " ",
        Copilot = " ",
        -- Enum = " ",
        Enum = " ",
        -- EnumMember = " ",
        EnumMember = " ",
        -- Event = " ",
        Event = " ",
        -- Field = " ",
        Field = "󰜢 ",
        File = " ",
        -- Folder = " ",
        Folder = " ",
        -- Function = " ",
        Function = "󰊕 ",
        -- Interface = " ",
        Interface = " ",
        Key = " ",
        -- Keyword = " ",
        Keyword = "󰌋 ",
        -- Method = " ",
        Misc = " ",
        Method = "󰊕 ",
        Module = " ",
        Namespace = " ",
        -- Null = " ",
        Null = "󰟢 ",
        Number = " ",
        Object = " ",
        -- Operator = " ",
        Operator = "󱓉 ",
        Package = " ",
        -- Property = "",
        Property = " ",
        -- Reference = " ",
        Reference = " ",
        -- Snippet = " ",
        -- Snippet = " ",
        Snippet = " ",
        String = " ",
        -- Struct = "",
        Struct = " ",
        -- Text = " ",
        -- Text = " ",
        Text = "󰊄 ",
        TypeParameter = " ",
        -- Unit = "",
        Unit = " ",
        -- Value = " ",
        Value = "󰎠 ",
        -- Variable = " ",
        Variable = "󰀫 ",
    },
    ---------------------------------------------------------------------------
    type = {
        Array = " ",
        Boolean = " ",
        Number = " ",
        Object = " ",
        String = " ",
    },
    -- TODO: fix duplicates
    ui = {
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
        BigCircle = " ",
        BigUnfilledCircle = " ",
        BoldArrowDown = "",
        BoldArrowLeft = "",
        BoldArrowRight = "",
        BoldArrowUp = "",
        BoldClose = "",
        BoldDividerLeft = "",
        BoldDividerRight = "",
        BoldLineLeft = "▎",
        -- BookMark = "",
        BookMark = " ",
        -- BoxChecked = "",
        BoxChecked = "󰄵 ", -- referenced
        -- Bug = " ",
        Bug = " ", -- referenced
        -- Calendar = "",
        Calendar = " ",
        -- Check = " ",
        Check = " ", -- referenced
        ChevronRight = "",
        ChevronDown = "",
        ChevronShortDown = "",
        ChevronShortLeft = "",
        ChevronShortRight = "",
        ChevronShortUp = "",
        -- Circle = "",
        Circle = "●",  -- referenced
        Clock = " ", -- referenced
        Close = " ",
        -- CloudDownload = "",
        CloudDownload = " ",
        -- Code = "",
        Code = " ",
        Comment = " ",
        -- Dashboard = "",
        Dashboard = " ",
        DebugConsole = "",
        DividerLeft = "",
        DividerRight = "",
        DoubleCheck = "", -- referenced
        DoubleChevronRight = "»",
        Ellipsis = "",
        EmptyFolder = "",
        EmptyFolderOpen = "",
        -- File = " ",
        File = " ",
        FileSymlink = "",
        Files = " ", -- referenced
        FindFile = "󰈞",
        FindText = "󰊄",
        -- Fire = " ",
        Fire = " ",  -- referenced
        -- Folder = " ",
        Folder = "󰉋 ",
        -- FolderOpen = " ",
        FolderOpen = " ",
        FolderSymlink = "",
        Forward = "  ", -- referenced
        -- Gear = " ",
        Gear = " ", -- referenced
        GitFolder = " ", -- referenced
        History = " ",
        Lazy = "󰒲 ", -- referenced
        Lightbulb = " ",
        LineLeft = "▏", -- referenced
        LineMiddle = "│",
        -- List = " ",
        List = " ", -- referenced
        Lock = " ", -- referenced
        Message = "󰍩 ", --referenced
        MidCircle = "",
        MidDottedCircle = " ",
        MidUnfilledCircle = " ",
        -- NewFile = "",
        NewFile = " ", -- referenced
        Note = " ",
        NoteBook = " ",
        -- Package = "",
        Package = " ",
        Paragraph = "󰊆 ",
        Pencil = " ",
        Plus = " ",
        -- Project = "",
        Project = " ",
        Scopes = "",
        -- Search = " ",
        Search = " ", -- referenced
        -- SignIn = "",
        SignIn = " ",
        -- SignOut = " ",
        SignOut = " ", -- referenced
        -- Speedometer = "⏲ ",
        Speedometer = "󰾆 ", -- referenced
        Stacks = "",
        Tab = "󰌒 ", -- referenced
        -- Table = "",
        Table = " ",
        Target = "󰀘 ",
        -- Telescope = " ",
        Telescope = " ",
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
    },
    misc = {
        Robot = " ",
        -- Squirrel = " ",
        Squirrel = " ",
        -- Tag = " ",
        Tag = " ",
        Vim = " ", -- referenced
        Watch = " ",
    },
}
