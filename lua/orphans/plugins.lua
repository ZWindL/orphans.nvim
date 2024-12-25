local Opt = require("orphan.config").options
local Git = require("orphan.git")
local api = vim.api

local P = {
}

function P.all_possible_plugin_dirs()
    -- pugins are located at `vim.opt.rtp`
    -- vim.opt.rtp:get()
    -- A more convenient way is to use `vim.api.nvim_list_runtime_paths`
    return api.nvim_list_runtime_paths()
end

function P.sort_by_last_commit(plugins)
    table.sort(plugins, function(a, b)
        return a.last_commit_time > b.last_commit_time
    end)
end

-- cache
-- serialize to json

P.is_plugin = function(path)
    return Git.is_git_dir(path) and
        (
            vim.fn.isdirectory(path .. "/plugin") == 1 or
            vim.fn.isdirectory(path .. "/autoload") == 1 or
            vim.fn.isdirectory(path .. "/lua") == 1 or
            vim.fn.isdirectory(path .. "/ftplugin") == 1
        )
end

-- Return a semantic string for a time delta.
-- e.g. "1 day ago", "2 hours ago", "over a year" etc.
local function format_delta(time)
    local delta = os.difftime(os.time(), time)
    if delta < 60 then
        return "just now"
    elseif delta < 60 * 60 then
        return math.floor(delta / 60) .. " minutes ago"
    elseif delta < 60 * 60 * 24 then
        return math.floor(delta / (60 * 60)) .. " hours ago"
    elseif delta < 60 * 60 * 24 * 30 then
        return math.floor(delta / (60 * 60 * 24)) .. " days ago"
    elseif delta < 60 * 60 * 24 * 365 then
        return math.floor(delta / (60 * 60 * 24 * 30)) .. " months ago"
    else
        return math.floor(delta / (60 * 60 * 24 * 365)) .. " years ago"
    end
end

P.new_plugin = function()
    return {
        path = "",
        name = "",
        last_commit_time = 0,
        last_commit_time_str = "",
        last_commit_time_delta = "",
        last_commit_msg = "",
        repo_url = "",
    }
end

P.new_plugin_async = function(path, callback)
    local plugin = P.new_plugin()
    Git.last_commit_time_async(path, function(t)
        t = tonumber(t)
        plugin.path = path
        plugin.name = vim.fn.fnamemodify(path, ":t")
        plugin.last_commit_time = t
        plugin.last_commit_time_str = os.date(Opt.ui.date_format, t)
        plugin.last_commit_time_delta = format_delta(t)
        vim.schedule(function()
            callback(plugin)
        end)
    end)
end

return P
