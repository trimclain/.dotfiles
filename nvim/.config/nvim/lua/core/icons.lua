-- Icons used by other plugins

-- https://github.com/microsoft/vscode/blob/main/src/vs/base/common/codicons.ts
-- go to the above and then enter <c-v>u<unicode> and the symbold should appear
-- or go here and upload the font file: https://mathew-kurian.github.io/CharacterMap/
-- find more here: https://www.nerdfonts.com/cheat-sheet

return {
    diagnostics = {
        BoldError = "",
        Error = " ",
        BoldWarn = " ",
        Warn = " ",
        BoldInfo = " ",
        Info = " ",
        BoldQuestion = " ",
        Question = " ",
        -- BoldHint = "",
        BoldHint = " ",
        -- Hint = " ",
        Hint = "󰌶 ",
        Debug = "",
        Trace = "✎",
    },
    git = {
        -- Add = " ",
        Add = " ",
        -- Mod = " ",
        Mod = " ",
        -- Remove = " ",
        Remove = " ",
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
    kinds = {
        Array = " ",
        Boolean = " ",
        -- Class = " ",
        -- Class = " ",
        Class = "ﴯ ",
        -- Color = " ",
        Color = " ",
        -- Constant = " ",
        -- Constant = " ",
        Constant = " ",
        -- Constructor = " ",
        -- Constructor = " ",
        Constructor = " ",
        Copilot = " ",
        -- Enum = " ",
        Enum = " ",
        -- EnumMember = " ",
        EnumMember = " ",
        -- Event = " ",
        Event = " ",
        -- Field = " ",
        Field = "ﰠ ",
        -- File = " ",
        File = " ",
        -- Folder = " ",
        Folder = " ",
        -- Function = " ",
        Function = " ",
        -- Interface = " ",
        Interface = " ",
        Key = " ",
        -- Keyword = " ",
        -- Keyword = "",
        Keyword = " ",
        -- Method = " ",
        Misc = " ",
        Method = " ",
        -- Module = " ",
        Module = " ",
        Namespace = " ",
        -- Null = "󰟢 ",
        Null = " ",
        Number = " ",
        Object = " ",
        -- Operator = " ",
        Operator = " ",
        Package = " ",
        -- Property = "",
        -- Property = "ﰠ",
        Property = " ",
        -- Reference = " ",
        -- Reference = " ",
        Reference = " ",
        -- Snippet = " ",
        -- Snippet = " ",
        Snippet = " ",
        String = " ",
        -- Struct = "פּ",
        -- Struct = "",
        Struct = " ",
        -- Text = " ",
        Text = " ",
        TypeParameter = " ",
        -- TypeParameter = " ",
        -- Unit = "塞",
        -- Unit = "",
        Unit = " ",
        -- Value = " ",
        Value = " ",
        Variable = " ",
        -- Variable = " ", -- in BlexMono this is alpha, as it should be
    },
    ---------------------------------------------------------------------------
    type = {
        -- Array = "",
        -- Number = "",
        -- String = "",
        -- Boolean = "蘒",
        -- Object = "",
        Array = " ",
        Boolean = " ",
        Number = " ",
        Object = " ",
        String = " ",
    },
    documents = {
        -- File = "",
        -- Files = "",
        -- Folder = "",
        -- OpenFolder = "",
        File = " ",
        Files = " ",
        Folder = " ",
        OpenFolder = " ",
    },
    ui = {
        -- ArrowClosed = "",
        -- ArrowOpen = "",
        -- Lock = "",
        -- Circle = "",
        -- BigCircle = "",
        -- BigUnfilledCircle = "",
        -- Close = "",
        -- NewFile = "",
        -- Search = "",
        -- Lightbulb = "",
        -- Project = "",
        -- Dashboard = "",
        -- History = "",
        -- Comment = "",
        -- Bug = "",
        -- Code = "",
        -- Telescope = "",
        -- Gear = "",
        -- Package = "",
        -- List = "",
        -- SignIn = "",
        -- SignOut = "",
        -- Check = "",
        -- Fire = "",
        -- Note = "",
        -- BookMark = "",
        -- Pencil = "",
        -- -- ChevronRight = "",
        -- ChevronRight = ">",
        -- Table = "",
        -- Calendar = "",
        -- CloudDownload = "",
        ArrowCircleDown = "",
        ArrowCircleLeft = "",
        ArrowCircleRight = "",
        ArrowCircleUp = "",
        ArrowClosed = "",
        ArrowOpen = "",
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
        BookMark = " ",
        BoxChecked = "",
        Bug = " ",
        Calendar = " ",
        Check = " ",
        ChevronShortDown = "",
        ChevronShortLeft = "",
        ChevronShortRight = "",
        ChevronShortUp = "",
        Circle = "●",
        Close = " ",
        CloudDownload = " ",
        Code = " ",
        Comment = " ",
        Dashboard = " ",
        DebugConsole = "",
        DividerLeft = "",
        DividerRight = "",
        DoubleChevronRight = "»",
        DoubleCheck = "",
        Ellipsis = "",
        EmptyFolder = "",
        EmptyFolderOpen = "",
        File = "",
        FileSymlink = "",
        Files = " ",
        FindFile = "󰈞",
        FindText = "󰊄",
        Fire = " ",
        Folder = "󰉋 ",
        FolderOpen = " ",
        FolderSymlink = "",
        Forward = " ",
        Gear = " ",
        History = " ",
        Lightbulb = " ",
        LineLeft = "▏",
        LineMiddle = "│",
        List = " ",
        Lock = " ",
        NewFile = " ",
        Note = " ",
        NoteBook = " ",
        Package = " ",
        Pencil = " ",
        Plus = " ",
        Project = " ",
        Scopes = "",
        Search = " ",
        SignIn = " ",
        SignOut = " ",
        Stacks = "",
        Tab = "󰌒 ",
        Table = " ",
        Target = "󰀘 ",
        Telescope = " ",
        Text = " ",
        Tree = "",
        Triangle = "󰐊",
        TriangleShortArrowDown = "",
        TriangleShortArrowLeft = "",
        TriangleShortArrowRight = "",
        TriangleShortArrowUp = "",
        Watches = "󰂥",
    },
    misc = {
        -- Robot = "ﮧ",
        -- Squirrel = "",
        -- Tag = "",
        -- Watch = "",
        Robot = " ",
        Squirrel = " ",
        Tag = " ",
        Vim = " ",
        Watch = " ",
    },
}
