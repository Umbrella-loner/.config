-- Load lazy.nvim ------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins -------------------------------------------------------------------
require("lazy").setup({
  -- File explorer
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",

  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Statusline
  "nvim-lualine/lualine.nvim",

  -- Autocomplete
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",

  -- Snippets
  "L3MON4D3/LuaSnip",

  -- LSP (provides server configs)
  "neovim/nvim-lspconfig",
})

-- Basic Settings -------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true

-- Keymaps ---------------------------------------------------------------------
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>")

-- Lualine ---------------------------------------------------------------------
require("lualine").setup()

-- Treesitter ------------------------------------------------------------------
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
})

-- nvim-cmp (autocomplete) -----------------------------------------------------
local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }
})

-- LSP Setup (New Neovim 0.11+ API) -------------------------------------------
local default_cap = vim.lsp.protocol.make_client_capabilities()
local lspconfig = vim.lsp.config

-- Python
vim.lsp.start(lspconfig.pyright({
  name = "pyright",
  cmd = { "pyright-langserver", "--stdio" },
  capabilities = default_cap,
}))

-- JavaScript/TypeScript (ts_ls replaces tsserver)
vim.lsp.start(lspconfig.ts_ls({
  name = "ts_ls",
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = default_cap,
}))

-- Lua
vim.lsp.start(lspconfig.lua_ls({
  name = "lua_ls",
  cmd = { "lua-language-server" },
  capabilities = default_cap,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    }
  }
}))

