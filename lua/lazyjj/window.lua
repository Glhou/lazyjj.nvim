-- open a buffer floating window with lazyjj
local function find_jj_repo()
	local dir = vim.fn.getcwd()
	while dir ~= "/" do
		if vim.fn.isdirectory(dir .. "/.jj") == 1 then
			return dir
		end
		dir = vim.fn.fnamemodify(dir, ":h")
	end
	return nil
end
local function open_window()
	local repo_dir = find_jj_repo()
	if not repo_dir then
		vim.notify("No Jujutsu repository found", vim.log.levels.ERROR)
		return
	end
	vim.notify(repo_dir, vim.log.levels.DEBUG)
	local buf = vim.api.nvim_create_buf(false, true) -- scratch buffer
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = true
	vim.bo[buf].readonly = false
	local scale_width = 0.8 -- 80% of editor width
	local scale_height = 0.8 -- 80% of editor height
	local offset_x = (1 - scale_width) / 2
	local offset_y = (1 - scale_height) / 2
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = math.floor(vim.o.columns * scale_width),
		height = math.floor(vim.o.lines * scale_height),
		row = math.floor(vim.o.lines * offset_y),
		col = math.floor(vim.o.columns * offset_x),
		style = "minimal",
		border = "rounded",
	})

	-- Start insert mode by default
	vim.api.nvim_set_current_win(win)
	vim.cmd("startinsert")
	-- exit function
	local job_id
	local function close_window()
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		if job_id then
			vim.fn.jobstop(job_id)
		end
		if vim.fn.mode() == "i" then
			vim.cmd("stopinsert")
		end
	end

	job_id = vim.fn.jobstart({ "lazyjj" }, {
		pty = true,
		term = true,
		cwd = repo_dir,
		stdout_buffered = true,
		stderr_buffered = true,
		on_stderr = function(_, data, _)
			if data then
				local clean = {}
				for _, line in ipairs(data) do
					if line ~= "" and line ~= nil then
						table.insert(clean, line)
					end
				end
				if #clean > 0 then
					vim.notify("LazyJJ Error" .. table.concat(clean, "\n"), vim.log.levels.ERROR)
				end
			end
		end,
		on_exit = function(_, exit_code, _)
			if exit_code ~= 0 then
				vim.notify("LazyJJ exited with code" .. exit_code, vim.log.levels.ERROR)
			else
				close_window()
			end
		end,
	})
end

return {
	open_window = open_window,
}
