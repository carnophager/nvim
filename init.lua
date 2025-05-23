vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "


-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd("NvimTreeToggle")
    end,
})


local lazy_config = require "configs.lazy"

vim.api.nvim_create_user_command(
  'StartGamePlatform',
  function()
    -- vim.cmd("NvimTreeToggle")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "i", false)
    -- vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n")
    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "t", false)
    -- local file_path = "platform/src/games.config.json"

    vim.defer_fn(function()
      local file_path = "/home/amuser/git/game-platform/platform/src/games.config.json"
      vim.cmd("edit " .. file_path)
      require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
    end, 100)

    vim.defer_fn(function()
      -- Send a command to the terminal
      vim.fn.chansend(vim.b.terminal_job_id, "npx foreman start\n")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "t", false)
      
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-k>", true, false, true), "t", false)
    end, 200)
  end,
  { nargs = 0 }
)

vim.api.nvim_create_user_command(
  'StartSingleBase',
  function()
    -- vim.cmd("NvimTreeToggle")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "i", false)
    -- vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n")
    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "t", false)
    -- local file_path = "platform/src/games.config.json"

    vim.defer_fn(function()
      local file_path = "/home/amuser/git/engines/single-base-slot/src/Main.ts"
      vim.cmd("edit " .. file_path)
      require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
    end, 100)

    vim.defer_fn(function()
      -- Send a command to the terminal
      vim.fn.chansend(vim.b.terminal_job_id, "npm run debug\n")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "t", false)
      
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-k>", true, false, true), "t", false)
    end, 200)
  end,
  { nargs = 0 }
)

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")



require "options"
require "nvchad.autocmds"

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.ts", "*.js", "*.tsx", "*.json", "*.css", "*.go" },
  callback = function()
  local file = vim.fn.expand("%:p")
  if vim.fn.expand("%:e") == "go" then
    vim.cmd("silent! !gofmt -w " .. file)
    vim.cmd("edit!")
    else
      vim.cmd("silent! !npx prettier --write " .. file)
    end
    vim.cmd("edit")
  end,
})

vim.schedule(function()
  require "mappings"
end)

vim.opt.relativenumber=true
vim.opt.number=true
vim.opt.wrap = true
vim.opt.linebreak = true


-- Auto-hover on CursorHold
vim.cmd [[
  autocmd CursorHold * lua vim.lsp.buf.hover()
]]

vim.o.updatetime = 1000  -- 500ms idle before triggering CursorHold
vim.o.winblend = 10
vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded" , focusable = false}
)



