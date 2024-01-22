local M = {}

M._keys = nil

function M.get()
    local format = require("plugins.lsp.format").format
    if M._keys then
        return M._keys
    end
    -- stylua: ignore
    M._keys =  {
        { "<leader>li", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        { "<leader>ln", "<cmd>NullLsInfo<cr>", desc = "NullLs Info" },
        { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition", has = "definition" },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "gl", vim.diagnostic.open_float, desc = "Line Diagnostics" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
        { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
        { "K", vim.lsp.buf.hover, desc = "Hover" },
        { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
        { "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
        { "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
        { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
        { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
        { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
        { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
        { "<leader>lf", format, desc = "Format Document", has = "documentFormatting" },
        { "<leader>lf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
        {
            "<leader>lA",
            function()
                vim.lsp.buf.code_action({
                    context = {
                        only = {
                            "source",
                        },
                        diagnostics = {},
                    },
                })
            end,
            desc = "Source Action",
            has = "codeAction",
        }
    }
    if require("core.util").has_plugin("inc-rename.nvim") then
        M._keys[#M._keys + 1] = {
            "<leader>lr",
            function()
                local inc_rename = require("inc_rename")
                return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
            end,
            expr = true,
            desc = "Rename",
            has = "rename",
        }
    else
        M._keys[#M._keys + 1] = { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
    end
    return M._keys
end

function M.get_clients(...)
    local fn = vim.lsp.get_clients or vim.lsp.get_active_clients -- TODO: remove when nvim 0.10 is released
    return fn(...)
end

---@param method string
function M.has(buffer, method)
    method = method:find("/") and method or "textDocument/" .. method
    local clients = M.get_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
        if client.supports_method(method) then
            return true
        end
    end
    return false
end

function M.resolve(buffer)
    local Keys = require("lazy.core.handler.keys")
    if not Keys.resolve then
        return {}
    end
    local spec = M.get()
    local opts = require("core.util").opts("nvim-lspconfig")
    local clients = M.get_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
        local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
        vim.list_extend(spec, maps)
    end
    return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
    local Keys = require("lazy.core.handler.keys")
    local keymaps = M.resolve(buffer)

    for _, keys in pairs(keymaps) do
        if not keys.has or M.has(buffer, keys.has) then
            local opts = Keys.opts(keys)
            opts.has = nil
            opts.silent = opts.silent ~= false
            opts.buffer = buffer
            vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
        end
    end
end

function M.diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

return M
