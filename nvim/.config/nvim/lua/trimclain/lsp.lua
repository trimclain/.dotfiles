-- LSP
require'lspinstall'.setup()

local function on_attach()
    -- TODO: TJ told Prime to do this and I should do because he is Telescopic
    -- "Big Tech" "Cash Money" Johnson
end

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
    require'lspconfig'[server].setup{on_attach=on_attach}
    -- require'lspconfig'[server].setup{on_attach=require'completion'.on_attach} -- this line only if using nvim-completion
end
