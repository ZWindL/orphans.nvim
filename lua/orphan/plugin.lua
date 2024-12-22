local git = require("orphan.git")

local plugin = {}

plugin.plugins = {}

function plugin:new ()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function plugin:all_plugins ()
    -- pugins are located at `vim.opt.rtp`
    -- vim.opt.rtp:get()
    -- A more convenient way is to use `vim.api.nvim_list_runtime_paths`
    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
        if self.is_plugin_dir(path) then
            table.insert(self.plugins, self.new_plugin(path))
            self:sort_by_last_commit()
        end
    end
end

function plugin:sort_by_last_commit ()
    table.sort(self.plugins, function(a, b)
        return a.last_commit_time > b.last_commit_time
    end)
end

-- cache
-- serialize to json

plugin.is_plugin_dir = function(path)
    return git.is_git_dir(path) and
        (
            vim.fn.isdirectory(path .. "/plugin") == 1 or
            vim.fn.isdirectory(path .. "/autoload") == 1 or
            vim.fn.isdirectory(path .. "/lua") == 1 or
            vim.fn.isdirectory(path .. "/ftplugin") == 1
        )
end

plugin.new_plugin = function(path)
    return {
        path = path,
        name = vim.fn.fnamemodify(path, ":t"),
        last_commit_time = tonumber(git.last_commit_time(path)),
        repo_url = "",
    }
end

return plugin
