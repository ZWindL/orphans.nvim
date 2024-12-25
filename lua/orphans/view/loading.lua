local api = vim.api

local loading = {
    percent = 0,
    buf_nr = nil,
    win_nr = nil,
    config = {
        relative = "editor",                         -- Position relative to the editor
        row = math.floor(vim.o.lines / 2 - 40 / 2),  -- Center vertically
        col = math.floor(vim.o.columns / 2 - 3 / 2), -- Center horizontally
        width = 50,
        height = 3,
        border = "rounded",
        title = "Analyzing...",
        title_pos = "center",
        style = "minimal", -- Optional: "minimal", "underline", "double"
    }
}

function loading:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function loading:show()
    if self.win_nr and api.nvim_win_is_valid(self.win_nr) then
        return
    end

    -- get the main window size
    local main_width = vim.o.columns
    local main_height = vim.o.lines

    -- calculate the position to center the floating window
    local row = math.floor((main_height - self.config.height) / 2)
    local col = math.floor((main_width - self.config.width) / 2)

    self.config.row = row
    self.config.col = col

    -- show the floating window
    self.buf_nr = api.nvim_create_buf(false, true)
    self.win_nr = api.nvim_open_win(self.buf_nr, false, self.config)
end

function loading:render(value)
    self.percent = value
    -- calculate the filled part of the progress bar
    local bar_size = self.config.width - 8
    local top_side = " ┌" .. string.rep("─", bar_size) .. "┐"
    local bottom_side = " └" .. string.rep("─", bar_size) .. "┘"
    local filled_width = math.floor(bar_size * (value / 100))
    local filled = string.rep("█", filled_width)
    local empty = string.rep(" ", bar_size - filled_width)
    local progress_bar = string.format(" │%s%s│ %d%% ", filled, empty, value)
    -- set the progress bar text in the buffer
    api.nvim_buf_set_lines(self.buf_nr, 0, -1, false, {
        top_side,
        progress_bar,
        bottom_side,
    })
end

function loading:close()
    -- clean up
    if self.win_nr and api.nvim_win_is_valid(self.win_nr) then
        api.nvim_win_close(self.win_nr, true)
    end
    if self.buf_nr and api.nvim_buf_is_valid(self.buf_nr) then
        api.nvim_buf_delete(self.buf_nr, { force = true })
    end
    self.buf_nr = nil
    self.win_nr = nil
    self.percent = 0
end

return loading
