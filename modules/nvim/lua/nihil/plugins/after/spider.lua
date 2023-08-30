local function run(key) return nihil.utils.cmd.callbackRun("lua require('spider').motion('" .. key .. "')") end

return {
    'chrisgrieser/nvim-spider',
    lazy = true,
    keys = {
        { 'w', run 'w', desc = 'Spider W', mode = { 'n', 'o', 'x' } },
        { 'e', run 'e', desc = 'Spider E', mode = { 'n', 'o', 'x' } },
        { 'b', run 'b', desc = 'Spider B', mode = { 'n', 'o', 'x' } },
        { 'ge', run 'ge', desc = 'Spider GE', mode = { 'n', 'o', 'x' } },
    },
}
