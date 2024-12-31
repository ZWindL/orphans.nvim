local lazypath = "./build/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
vim.opt.rtp:prepend("/home/zwindl/test/matrix")

-- install lazy if it doesn't exist
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

require("lazy").setup({
    spec = {
        {
            dir = "./",
            config = function ()
                require("orphans").setup()
            end
        },
    },
    dev = {
        path = "./",
        fallback = false,
    },
    -- defaults = {
    --     spec = {
    --     },
    -- },
    -- {
    -- },
})
