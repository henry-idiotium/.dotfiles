if nihil.os.darwin then vim.opt.clipboard:append { 'unnamedplus' } end
if nihil.os.linux then vim.opt.clipboard:append { 'unnamedplus' } end
if nihil.os.win then vim.opt.clipboard:prepend { 'unnamed', 'unnamedplus' } end
if nihil.os.wsl then vim.cmd [[
    augroup Yank
    autocmd!
    autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ', @")
    augroup END
]] end

return {}
