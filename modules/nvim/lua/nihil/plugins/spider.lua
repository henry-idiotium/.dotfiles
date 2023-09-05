local function run(key) return nihil.utils.cmd.callbackRun("lua require('spider').motion('" .. key .. "')") end

return {
    'chrisgrieser/nvim-spider',
    lazy = true,
    keys = {
        { '<leader>w', run 'w', desc = 'Spider W', mode = { 'n', 'o', 'x' } },
        { '<leader>e', run 'e', desc = 'Spider E', mode = { 'n', 'o', 'x' } },
        { '<leader>b', run 'b', desc = 'Spider B', mode = { 'n', 'o', 'x' } },
        { '<leader>ge', run 'ge', desc = 'Spider GE', mode = { 'n', 'o', 'x' } },
    },
}
