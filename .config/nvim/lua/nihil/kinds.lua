-- custom kinds
local M = {}

M.priority = {
    Variable = 100,
    Reference = 95,
    Constant = 90,
    Interface = 90,
    TypeParameter = 90,
    Function = 85,
    Field = 85,
    Method = 85,
    Class = 85,
    Property = 80,
    Enum = 75,
    EnumMember = 75,
    Constructor = 75,
    Struct = 70,
    Module = 70,

    Color = 60,
    Unit = 60,
    Value = 60,
    File = 55,
    Folder = 55,
    Event = 40,
    Operator = 40,
    Keyword = 30,

    Supermaven = 20,
    Codeium = 20,
    TabNine = 20,
    Copilot = 20,

    Snippet = 15,
    Text = 0,
}

return M
