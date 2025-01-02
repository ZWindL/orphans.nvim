local M = {}

----- Logging utilities
M.log = {}

M.log.debug = function (msg)
    if not _G.orphans.debug then
        return
    end
    msg = debug.traceback(msg, vim.log.levels.DEBUG)
    vim.print(msg)
end

M.log.error = function (msg)
    if not _G.orphans.debug then
        return
    end
    msg = debug.traceback(msg, vim.log.levels.ERROR)
    vim.print(msg)
end

M.log.warn = function (msg)
    if not _G.orphans.debug then
        return
    end
    msg = debug.traceback(msg, vim.log.levels.WARN)
    vim.print(msg)
end

M.log.info = vim.print

M.log.notify = function (msg)
    vim.notify(msg, vim.log.levels.INFO, { title = "Orphans.nvim" })
end


----- Utility functions
M.table_concat = function (t1, t2)
    local t = vim.deepcopy(t1, true)
    for _, v in ipairs(t2) do
        table.insert(t, v)
    end
    return t
end

return M
