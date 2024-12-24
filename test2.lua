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

-- local Loading = require("test")
-- local ld = Loading:new()
-- ld:show()
--
-- local function async_progress(callback)
--     local total_steps = 100
--     for i = 1, total_steps do
--         vim.defer_fn(function()
--             local progress = math.floor((i / total_steps) * 100)
--             callback(progress)
--         end, 10 * i)
--     end
-- end
--
-- async_progress(function (progress)
--     vim.schedule(function()
--         if progress == 100 then
--             ld:close()
--             return
--         end
--         ld:render(progress)
--     end)
-- end)

-- vim.schedule(renderer.hide_progress)

-- NOTE: Don't remove these code
local git = require("lua.orphan.git")
local Plugins = require("lua.orphan.plugins")
local Loading = require("lua.orphan.view.loading")

local ld = Loading:new()

ld:show()
ld:render(0)

local dirs = Plugins.all_possible_plugin_dirs()
local total = #dirs
local plugins = {}
local processed_count = 0

local function open_dashboard()
    ld:close()
    vim.print(plugins)
end

for _, dir in ipairs(dirs) do
    if git.is_git_dir(dir) then
        Plugins.new_plugin_async(dir, function(p)
            table.insert(plugins, p)
            processed_count = processed_count + 1
            ld:render(math.floor((processed_count / total) * 100))

            if processed_count == total then
                open_dashboard()
            end
        end)
    else
        processed_count = processed_count + 1
        ld:render(math.floor((processed_count / total) * 100))
        if processed_count == total then
            open_dashboard()
        end
    end
end
