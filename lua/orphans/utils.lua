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

-- Return a semantic string for a time delta.
-- e.g. "1 day ago", "2 hours ago", "over a year" etc.
M.format_delta = function (time)
    local delta = os.difftime(os.time(), time)
    if delta < 60 then
        return "just now"
    elseif delta < 60 * 60 then
        local minutes = math.floor(delta / 60)
        return minutes .. " minute" .. (minutes ~= 1 and "s" or "") .. " ago"
    elseif delta < 60 * 60 * 24 then
        local hours = math.floor(delta / (60 * 60))
        return hours .. " hour" .. (hours ~= 1 and "s" or "") .. " ago"
    elseif delta < 60 * 60 * 24 * 30 then
        local days = math.floor(delta / (60 * 60 * 24))
        return days .. " day" .. (days ~= 1 and "s" or "") .. " ago"
    elseif delta < 60 * 60 * 24 * 365 then
       local months = math.floor(delta / (60 * 60 * 24 * 30))
       return months .. " month" .. (months ~= 1 and "s" or "") .. " ago"
    else
        local years = math.floor(delta / (60 * 60 * 24 * 365))
        return years .. " year" .. (years ~= 1 and "s" or "") .. " ago"
    end
end

-- compare function takes 2 elements and returns -1, 0, 1
-- for less than, equal to, greater than
M.bin_search = function (arr, target, compare_f)
    local left = 1
    local right = #arr
    while left <= right do
        local mid = math.floor((left + right) / 2)
        if compare_f(arr[mid], target) < 0 then
            left = mid + 1
        elseif compare_f(arr[mid], target) > 0 then
            right = mid - 1
        else
            return mid
        end
    end
    return nil
end

return M
