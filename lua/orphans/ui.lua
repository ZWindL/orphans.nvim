-- Display a progress bar seems better
-- Title: Analyzing...
-- Content: A progress bar with a percentage

local ui = {}

ui.display = function()
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = 50,
        height = 10,
        col = 10,
        row = 10,
        style = 'minimal',
        border = 'double',
    })
    vim.api.nvim_win_close(win, true)
end

ui.update = function()
    vim.print("Orpahan UI update")
end

return ui
