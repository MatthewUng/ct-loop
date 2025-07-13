
local M = {}

-- State stores the following:
-- buf: bufnr of the main terminal buffer
-- job_id: the associated job_id
M.state = {}

-- Debug method
local function print_state()
    vim.notify("state: " .. vim.inspect(M.state))
end

-- Focuses on the input bufnr if it's available in the current tabpage.
-- No-op if bufnr is not available
-- Returns whether the bufnr was found.
local function focus_buffer_current_tabpage(bufnr) 
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
            vim.api.nvim_set_current_win(win)
            return true
        end
    end
    return false
end

-- Snaps focus to the main buffer.  If the buffer does not exists, we create it.
-- If it is not available in the current tabpage, we create it via a vertical split.
local function create_term_if_not_exists()
    if M.state.buf == nil or not vim.api.nvim_buf_is_valid(M.state.buf) then
        local buf = vim.api.nvim_create_buf(false, true)
        vim.cmd('vsplit')
        vim.api.nvim_set_current_buf(buf)
        local job_id = vim.fn.termopen(os.getenv("SHELL") or "sh")
        M.state.buf = buf
        M.state.job_id = job_id
    else
        local buf = M.state.buf
        local exists = focus_buffer_current_tabpage(buf)

        if not exists then
            vim.cmd("vsplit")
            vim.api.nvim_set_current_buf(buf)
        end
    end
end

function M.set_command(cmd)
    M.state.command = cmd
end

function M.run_command()
    create_term_if_not_exists()
    local job_id = M.state.job_id
    local cmd = M.state.command
    vim.fn.chansend(job_id, cmd .. '\n')
end



return M
