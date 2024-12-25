local M = {}

M.setup = function()
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
