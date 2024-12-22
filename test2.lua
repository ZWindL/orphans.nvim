local renderer = require("test")

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

local function async_progress(callback)
    local total_steps = 100
    for i = 1, total_steps do
        vim.defer_fn(function()
            local progress = math.floor((i / total_steps) * 100)
            callback(progress)
        end, 10 * i)
    end
end

async_progress(function (progress)
    vim.schedule(function()
        if progress == 100 then
            renderer.hide_progress()
            return
        end
        renderer.show_progress(progress)
    end)
end)

-- vim.schedule(renderer.hide_progress)
