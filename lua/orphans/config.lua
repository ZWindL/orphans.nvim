---Provides utilities for configuring user options
---@module 'config'
local C = {}

---Default options
---@type table
C.defaults = {
    ui = {
        date_format = "%Y-%m-%d",
    },
}

---Merged options
---TODO: clean up
---@type table
C.options = {
    ui = {
        date_format = "%Y-%m-%d",
    },
}

---Validate user options
---@param options table
---@return boolean
C.validate = function (options)
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
    C.options = vim.tbl_deep_extend("force", C.defaults, options)

    C.validate(C.options)
    return C.options
end

---Setup options, called by `require("toggler").setup(options)`
C.setup = function(opts)
    local options = C.merge_config(opts)
    C.validate(options)
    -- put debug in `_G`
    -- TODO: that doesn't work
    -- _G.plug_toggler.debug = options.debug
    return options
end

return C
