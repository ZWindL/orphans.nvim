local git = {}

-- check if a path is a git directory
git.is_git_dir = function(path)
    return vim.fn.isdirectory(path .. "/.git") == 1
end

-- query the last commit time of a path
git.last_commit_time = function(path)
    -- it returns a timestamp like `1734691156`
    -- translate timestamp back to date string with:
    -- vim.print(os.date("%Y-%m-%d", 1734691156))
    -- TODO: consider return more info like commit message based on options
    return vim.fn.system("git log -1 --format=%ct " .. path)
end

return git
