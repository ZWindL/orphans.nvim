local git = require("orphan.git")

local function list_plugins()
    -- pugins are located at `vim.opt.rtp`
    local plugins = {}
    for _, plugin in pairs(vim.opt.rtp:get()) do
        -- for each runtime path
        -- check if it is a directory with `.git` in it
        -- process them asynchronously
        -- use a heap to sort them according to last git commit time
        -- maybe insert sort is more properate here
        table.insert(plugins, plugin)
    end
    return plugins
end

-- cache

local M = {}

M.is_plugin_dir = function(path)
    return git.is_git_dir(path) and
        (vim.fn.isdirectory(path .. "/lua") == 1 or
            vim.fn.isdirectory(path .. "/plugin") == 1)
end

M.new_plugin = function(path)
    return {
        path = path,
        name = vim.fn.fnamemodify(path, ":t"),
        last_commit_time = git.last_commit_time(path),
        repo_url = "",
    }
end

M.setup = function()
    vim.api.nvim_list_runtime_paths()
    -- Create a command `:Orphan`
    vim.api.nvim_create_user_command("Orphan", function()
        -- local plugins = list_plugins()
        print("Orphaned plugins:")
        -- for _, plugin in pairs(plugins) do
        --     print(plugin)
        -- end
    end, {})
end

return M
