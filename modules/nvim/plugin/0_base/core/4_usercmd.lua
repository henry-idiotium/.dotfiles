local api = vim.api

local function create_user_command_schema(schema)
    for cmd_name, act_opts in pairs(schema) do
        local is_tbl  = type(act_opts) == 'table'
        local action  = is_tbl and (act_opts.act or act_opts[1]) or act_opts
        local options = is_tbl and (act_opts.opts or act_opts[2]) or {}

        api.nvim_create_user_command(cmd_name, action, options)
    end
end

create_user_command_schema {
    Q = 'q!',

    QuitPromptIfLast = function()
        local close_success, _ = pcall(vim.cmd, 'close')
        if close_success then return end

        vim.ui.input({ prompt = 'Wanna quit Neovim? (y: to quit): ' }, function(choice)
            local _choice = string.lower(choice or '')
            if _choice == 'y' or _choice == '' then
                local quit_success, _ = pcall(vim.cmd, 'quit')
                if quit_success then return end

                print '-> Save before quit!!'
            end
        end)
    end,

    QuitAllPromptIfLast = function()
        vim.ui.input({ prompt = 'Wanna quit Neovim? (y: to quit): ' }, function(choice)
            local _choice = string.lower(choice or '')
            if _choice == 'y' or _choice == '' then
                pcall(vim.cmd, 'quitall')
            end
        end)
    end,

    ToggleTabline = function()
        local is_show = vim.o.showtabline == 1
        vim.o.showtabline = is_show and 0 or 1
    end
}
