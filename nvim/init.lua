-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.api.nvim_create_user_command("Wq", function() vim.cmd("w") vim.cmd("bd") end, {})
vim.api.nvim_create_user_command("Q", function(opts)
  if opts.bang then vim.cmd("bd!") else vim.cmd("bd") end
end, { bang = true })
vim.cmd("cabbrev wq Wq")
vim.cmd("cabbrev q Q")
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})
