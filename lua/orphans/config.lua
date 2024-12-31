---Provides utilities for configuring user options
---@module 'config'
local C = {}

---Default options
---@type table
C.defaults = {
    ui = {
        date_format = "%Y-%m-%d",
    },
    filetype = "orphans",   -- the filetype for the floating window
}

---Merged options
---@type table
C._opts = {}

---Validate user options
---@return boolean
C.validate = function ()
    local options = C._opts
    assert(
        type(options.ui.date_format) == "string",
        "options.ui.date_format must be a string"
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
    C.validate()
    -- put debug in `_G`
    -- TODO: that doesn't work
    -- _G.plug_toggler.debug = options.debug
    return options
end

return C
