local M = {}

local open_window = require("lazyjj.window").open_window

-- function M.open()
-- 	local function find_jj_repo()
-- 		local dir = vim.fn.getcwd()
-- 		while dir ~= "/" do
-- 			if vim.fn.isdirectory(dir .. "/.jj") == 1 then
-- 				return dir
-- 			end
-- 			dir = vim.fn.fnamemodify(dir, ":h")
-- 		end
-- 		return nil
-- 	end
-- 	local repo_dir = find_jj_repo()
-- 	vim.cmd(string.format("terminal ++curwin ++close cd %s && lazyjj", repo_dir))
-- end
--
M.open = open_window

function M.setup(opts)
	opts = opts or {}

	vim.api.nvim_create_user_command("LazyJJ", M.open, {})

	local keymap = opts.keymap or "<leader>jj"

	vim.keymap.set("n", keymap, M.open, {
		desc = "Open lazyjj in a window",
		silent = true,
	})
end

return M
