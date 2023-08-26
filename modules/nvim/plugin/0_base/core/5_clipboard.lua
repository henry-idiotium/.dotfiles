if nihil.os.darwin then
	vim.opt.clipboard:append { 'unnamedplus' }
end

if nihil.os.linux then
	vim.opt.clipboard:append { 'unnamedplus' }
end

if nihil.os.win then
	vim.opt.clipboard:prepend { 'unnamed', 'unnamedplus' }
end

if nihil.os.wsl then
	vim.cmd [[
		augroup Yank
		autocmd!
		autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
		augroup END
	]]
	-- local clip = '/mnt/c/windows/system32/clip.exe'
	-- vim.api.nvim_create_autocmd('TextYankPost', {
	-- 	group = vim.api.nvim_create_augroup('Yank', { clear = true }),
	-- 	callback = function() vim.fn.system(clip, vim.fn.getreg(',@')) end,
	-- })

	-- -- Better paste method (best clipboard is comming from neovim's built-in).
	-- -- note: it also do paste without yank.
	-- --
	-- -- caveats:
	-- --		Pasting after yank WHOLE LINE will only preserve newline after but not before.
	-- --		So do notice when pasting a whole line in middle of a sentence.
	-- nihil.utils.keymap.map_schema {
	-- 	{
	-- 		'p',
	-- 		function ()
	-- 			local register = '+'
	-- 			
	-- 			if vim.o.clipboard == 'unnamed' then
	-- 				register = '*'
	-- 			end

	-- 			local register_registry = vim.fn.getreg(register)
	-- 			vim.fn.setreg('x', register_registry)
	-- 			vim.api.nvim_paste(register_registry, {}, -1)
	-- 			vim.fn.setreg(register, vim.fn.getreg('x'))
	-- 		end,
	-- 		desc = 'WSL Paste',
	-- 		mode = { 'n', 'v' },
	-- 	}
	-- }
end
