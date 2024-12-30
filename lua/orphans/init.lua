local git = require("orphans.git")
local Plugins = require("orphans.plugins")
local Loading = require("orphans.view.loading")
local List = require("orphans.view.plugin_list")

local M = {}

M.display_plugins = function()
    local ld = Loading:new()
    local list = List:new()
    local dirs = Plugins.all_possible_plugin_dirs()
    local total = #dirs
    local plugins = {}
    local processed_count = 0

    -- read from cache
    if #plugins > 0 then
        list:setup(plugins, {})
        ld:close()
        return
    end

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
end

M.setup = function(opts)
    -- Create a command `:Orphan`
    vim.api.nvim_create_user_command("Orphans", function()
    end, {})
end

return M
