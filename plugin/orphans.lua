-- Check compatibility

if vim.fn.has("nvim-0.10.0") ~= 1 then
   vim.api.nvim_err_writeln("orphans.nvim requires at least nvim-0.10.0.")
end
