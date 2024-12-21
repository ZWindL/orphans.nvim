---Provides utilities for configuring user options
---@module 'config'
local config = {}

---Default options
---@type table
config.defaults = {
}

---Validate user options
---@param options table
---@return boolean
config.validate = function (options)
    -- assert(
    --     type(options.prefix) == "string",
    --     "options.prefix must be a table"
    -- )
    return true
end

--- Merge user options with defaults
---@param options table
---@return table
config.merge_config = function(options)
    local options_merged = config.defaults

    -- Override `defaults` with `options`
    options_merged = vim.tbl_deep_extend("force", config.defaults, options)

    config.validate(options_merged)
    return options_merged
end

---Setup options, called by `require("toggler").setup(options)`
config.setup = function(opts)
    local options = config.merge_config(opts)
    config.validate(options)
    -- put debug in `_G`
    -- TODO: that doesn't work
    -- _G.plug_toggler.debug = options.debug
    return options
end

return config
