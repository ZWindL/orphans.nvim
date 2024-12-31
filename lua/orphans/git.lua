local git = {}

-- check if a path is a git directory
git.is_git_dir = function(path)
    return vim.fn.isdirectory(path .. "/.git") == 1
end

-- query the last commit time of a path
git.last_commit_info_async = function(path, callback)
    -- it returns a timestamp and a commit message like `1734691156\nmessage`
    vim.system(
        { "git", "log", "-1", "--format=%ct%n%s ", path },
        { cwd = path },
        function(rst)
            if rst.code ~= 0 then
                -- for plugins don't have any commit yet, ignore them, just return
                -- callback(nil)
                vim.notify(
                    string.format("warning: failed to get the last commit info from %s", path),
                    vim.log.levels.WARN,
                    { title = "Orphans.nvim" }
                )
                return
            end
            callback(rst.stdout)
        end
    )
end

return git
