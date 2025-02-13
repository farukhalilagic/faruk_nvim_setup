vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
  {
    "neoclide/coc.nvim",
    branch = "release",
    lazy = false,
  },
}, lazy_config)


-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.api.nvim_create_user_command('Format', function()
  vim.fn.CocAction('format')
end, {})

vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    require('cmp').setup.buffer { enabled = false }
  end,
})



vim.keymap.set("v", "<F7>", function()
  -- Get the visually selected text
  vim.cmd('noau normal! "vy"')  
  local s = vim.fn.getreg("v")  

  vim.fn.inputsave()
  local replace = vim.fn.input("Replace with: ")
  vim.fn.inputrestore()

  if replace ~= "" then
    -- Escape special characters and perform a whole-word substitution
    local pattern = "\\V\\<" .. vim.fn.escape(s, "/\\") .. "\\>"
    vim.cmd(string.format("%%s/%s/%s/g", pattern, replace))
  end
end, { noremap = true, silent = true })
