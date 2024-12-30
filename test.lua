-- NOTE: Don't remove these code
-- NOTE: Modify the imports in plugins.lua before running this file.
-- NOTE: `:luafile %` to run

local git = require("lua.orphans.git")
local Plugins = require("lua.orphans.plugins")
local Loading = require("lua.orphans.view.loading")
local List = require("lua.orphans.view.plugin_list")

local ld = Loading:new()
local list = List:new()

ld:show()
ld:render(0)

local dirs = Plugins.all_possible_plugin_dirs()
local total = #dirs
local plugins = {}
local processed_count = 0

local function sort_and_open_dashboard()
    Plugins.sort_by_last_commit(plugins)
    list:setup(plugins, {})
    ld:close()
end

for _, dir in ipairs(dirs) do
    if git.is_git_dir(dir) then
        Plugins.new_plugin_async(dir, function(p)
            table.insert(plugins, p)
            processed_count = processed_count + 1
            ld:render(math.floor((processed_count / total) * 100))

            if processed_count == total then
                sort_and_open_dashboard()
            end
        end)
    else
        processed_count = processed_count + 1
        ld:render(math.floor((processed_count / total) * 100))
        if processed_count == total then
            sort_and_open_dashboard()
        end
    end
end
