local api = vim.api

-- Configuration for the floating window
local config = {
  border = "rounded", -- You can also use "none", "single", "double", "shadow"
  focusable = false, -- Prevent the window from being focused
  style = "minimal", -- Remove extra decorations
  relative = "editor", -- Position relative to the editor window
  width = 40,        -- Adjust as needed
  height = 3,        -- Adjust as needed
}

local progress_win_id = nil
local progress_buf_id = nil

--- Shows the floating progress bar window.
-- @param progress The current progress percentage (0-100).
local function show_progress(progress)
  -- Calculate the filled part of the progress bar
  local filled_width = math.floor(config.width * (progress / 100))
  local filled = string.rep("█", filled_width)
  local empty = string.rep(" ", config.width - filled_width)
  local progress_bar = string.format("[%s%s] %d%%", filled, empty, progress)

  -- Get the main window size
  local main_width = vim.o.columns
  local main_height = vim.o.lines

  -- Calculate the position to center the floating window
  local row = math.floor((main_height - config.height) / 2)
  local col = math.floor((main_width - config.width) / 2)

  config.row = row
  config.col = col

  if not progress_win_id or not api.nvim_win_is_valid(progress_win_id) then
    -- Create a new buffer for the progress bar
    progress_buf_id = api.nvim_create_buf(false, true) -- Not listed, bufnested

    -- Create the floating window
    progress_win_id = api.nvim_open_win(progress_buf_id, false, config)
  end

  -- Set the progress bar text in the buffer
  api.nvim_buf_set_lines(progress_buf_id, 0, -1, false, { progress_bar })
end

--- Hides the floating progress bar window.
local function hide_progress()
  if progress_win_id and api.nvim_win_is_valid(progress_win_id) then
    api.nvim_win_close(progress_win_id, true)
    progress_win_id = nil
    progress_buf_id = nil
  end
end

-- Example Usage:
-- To show the progress bar:
-- show_progress(50) -- Shows a 50% progress bar

-- To update the progress:
-- show_progress(75)

-- To hide the progress bar:
-- hide_progress()

-- Example of a simple progress loop:
-- local total_steps = 100
-- for i = 1, total_steps do
--   local progress = math.floor((i / total_steps) * 100)
--   vim.schedule(function()
--     show_progress(progress)
--   end)
--   vim.wait(100) -- Simulate some work
-- end
-- vim.schedule(hide_progress)

return {
  show_progress = show_progress,
  hide_progress = hide_progress,
}
