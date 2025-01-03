local Config = require("orphans.config")
local Plugins = require("orphans.plugins")
local Loading = require("orphans.view.loading")
local List = require("orphans.view.plugin_list")
local Utils = require("orphans.utils")

local M = {}

M.display_plugins = function(opts)
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
        Utils.log.debug("sorting and opening dashboard")
        Plugins.sort_by_last_commit(plugins)
        list:setup(plugins, opts)
        ld:close()
    end

    local function update_progress()
        processed_count = processed_count + 1
        ld:render(math.floor((processed_count / total) * 100))
        Utils.log.debug(string.format("processed %d/%d plugins", processed_count, total))
        if processed_count == total then
            sort_and_open_dashboard()
        end
    end

    ld:show(opts)

    for _, dir in ipairs(dirs) do
        if Plugins.is_plugin(dir) then
            -- set a timer to close the loading window
            local timer = vim.defer_fn(function()
                ld:close()
            end, opts.analyzing_timeout)
            Plugins.new_plugin_async(dir, opts, function(p)
                if p ~= nil then
                    table.insert(plugins, p)
                end
                timer:stop()
                timer:close()
                update_progress()
            end)
        else
            update_progress()
        end
    end
end

M.setup = function(opts)
    -- Merge user options
    opts = Config.setup(opts)
    -- Create a command `:Orphan`
    vim.api.nvim_create_user_command("Orphans", function()
        M.display_plugins(opts)
    end, {})
end

return M
