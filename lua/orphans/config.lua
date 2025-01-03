---Provides utilities for configuring user options
---@module 'config'
local C = {}

---Default options
---@type table
C.defaults = {
    ui = {
        date_format = "%Y-%m-%d",
    },
    filetype = "orphans",       -- the filetype for the floating window
    analyzing_timeout = 2000,   -- the timeout for the analysis for each plugin in ms
    debug = false,
}

---Merged options
---@type table
C._opts = {}

---Validate user options
---@return boolean
C.validate = function (opts)
    assert(
        type(opts.ui.date_format) == "string",
        "options.ui.date_format must be a string"
    )
    assert(
        type(opts.debug) == "boolean",
        "options.debug must be a boolean"
    )
    return true
end

--- Merge user options with defaults
---@param options table
---@return table
C.merge_config = function(options)
    -- Override `defaults` with `options`
    C._opts = vim.tbl_deep_extend("force", C.defaults, options)
    return C._opts
end

---Setup options, called by `require("toggler").setup(options)`
C.setup = function(opts)
    local user_opts = opts or {}
    local options = C.merge_config(user_opts)
    C.validate(options)
    -- put every opts in `_G` might be a bad idea
    -- put only `orphans.debug` in `_G`
    _G.orphans = {}
    _G.orphans.debug = options.debug
    return options
end

return C
