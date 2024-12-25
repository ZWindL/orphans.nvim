local git = {}

-- check if a path is a git directory
git.is_git_dir = function(path)
    return vim.fn.isdirectory(path .. "/.git") == 1
end

-- query the last commit time of a path
git.last_commit_time_async = function(path, callback)
    -- it returns a timestamp like `1734691156`
    -- TODO: consider return more info like commit message based on options
    vim.system(
        { "git", "log", "-1", "--format=%ct ", path },
        { cwd = path },
        function(rst)
            --TODO: handle error
            if rst.code ~= 0 then
                callback(nil)
            end
            callback(rst.stdout)
        end
    )
end

return git
