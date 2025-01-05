local Git = require("orphans.git")
local Utils = require("orphans.utils")
local api = vim.api

local P = {}

function P.all_possible_plugin_dirs()
    -- pugins are located at `vim.opt.rtp`
    -- vim.opt.rtp:get()
    -- A more convenient way is to use `vim.api.nvim_list_runtime_paths`
    return api.nvim_list_runtime_paths()
end

function P.sort_by_last_commit(plugins)
    table.sort(plugins, function(a, b)
        return a.last_commit_time < b.last_commit_time
    end)
end

function P.sort_by_name(plugins)
    table.sort(plugins, function(a, b)
        return a.name > b.name
    end)
end

function P.is_ignored(plugin_name, opts)
    local ignore_list_sorted = opts.ignored
    local matched = Utils.bin_search(ignore_list_sorted, plugin_name, function(a, b)
        if a > b then
            return 1
        elseif a < b then
            return -1
        else
            return 0
        end
    end)
    return matched ~= nil
end

-- cache
-- serialize to json

P.is_plugin = function(path)
    if path == vim.fn.stdpath("config") then
        return false
    end
    return Git.is_git_dir(path) and
        (
            vim.fn.isdirectory(path .. "/plugin") == 1 or
            vim.fn.isdirectory(path .. "/autoload") == 1 or
            vim.fn.isdirectory(path .. "/lua") == 1 or
            vim.fn.isdirectory(path .. "/ftplugin") == 1
        )
end

P.new_plugin = function(path)
    local name = vim.fn.fnamemodify(path, ":t")
    return {
        path = path,
        name = name,
        last_commit_time = 0,
        last_commit_time_str = "",
        last_commit_time_delta = "",
        last_commit_msg = "",
        -- repo_url = "", --TODO: show repo url
    }
end

P.new_plugin_async = function(path, opts, callback)
    local plugin = P.new_plugin(path)
    if P.is_ignored(plugin.name, opts) then
        Utils.log.debug(string.format("ignoring %s", plugin.name))
        vim.schedule(function()
            callback(nil)
        end)
        return
    end
    Git.last_commit_info_async(path, function(info)
        Utils.log.debug(string.format("last commit info for %s: %s", path, info))
        if info == nil then
            Utils.log.debug("failed to get last commit info for " .. path .. ", calling cb with nil")
            vim.schedule(function()
                callback(nil)
            end)
            return
        end
        Utils.log.debug(string.format("analyzing %s: %s", plugin.name, path))
        -- split info by newline, first line is timestamp, second line is commit message
        local t = info:match("^(%d+)\n")
        -- the rest is the commit message, trim the newline
        local msg = info:match("\n(.*)"):gsub("\n", " ")
        t = tonumber(t)
        plugin.last_commit_time = t
        plugin.last_commit_time_str = os.date(opts.ui.date_format, t)
        plugin.last_commit_time_delta = Utils.format_delta(t)
        plugin.last_commit_msg = msg
        vim.schedule(function()
            callback(plugin)
        end)
    end)
end

return P
