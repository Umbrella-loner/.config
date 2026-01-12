
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ───────────────────────────────────────────────────────────────────────────
  -- Themes
  -- ───────────────────────────────────────────────────────────────────────────

  -- TokyoNight
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
    end,
  },

  -- Nightfox (Carbonfox)
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
        },
      })
      -- Default theme (change if you want)
      vim.cmd.colorscheme("carbonfox")
    end,
  },

  -- ───────────────────────────────────────────────────────────────────────────
  -- File Explorer
  -- ───────────────────────────────────────────────────────────────────────────
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-tree/nvim-web-devicons" },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Telescope
  -- ───────────────────────────────────────────────────────────────────────────
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Treesitter
  -- ───────────────────────────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      if vim.fn.executable("cc") == 1
        or vim.fn.executable("gcc") == 1
        or vim.fn.executable("clang") == 1 then
        vim.cmd("TSUpdate")
      end
    end
  },

  -- ───────────────────────────────────────────────────────────────────────────
  -- LSP
  -- ───────────────────────────────────────────────────────────────────────────
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Autocompletion
  -- ───────────────────────────────────────────────────────────────────────────
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Autopairs
  -- ───────────────────────────────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end
  },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Git
  -- ───────────────────────────────────────────────────────────────────────────
  { "lewis6991/gitsigns.nvim" },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Statusline
  -- ───────────────────────────────────────────────────────────────────────────
  { "nvim-lualine/lualine.nvim" },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Copilot
  -- ───────────────────────────────────────────────────────────────────────────
  { "github/copilot.vim" },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Basic Settings
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.g.mapleader = " "

-- ─────────────────────────────────────────────────────────────────────────────
-- Transparency (GLOBAL)
-- ─────────────────────────────────────────────────────────────────────────────
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- NvimTree transparency
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

-- ─────────────────────────────────────────────────────────────────────────────
-- Treesitter Configuration
-- ─────────────────────────────────────────────────────────────────────────────
local has_compiler =
  vim.fn.executable("cc") == 1
  or vim.fn.executable("gcc") == 1
  or vim.fn.executable("clang") == 1

require("nvim-treesitter.configs").setup({
  ensure_installed = has_compiler and { "c", "lua", "vim", "vimdoc", "query" } or {},
  auto_install = has_compiler,
  highlight = { enable = true },
  indent = { enable = true },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- LSP Configuration
-- ─────────────────────────────────────────────────────────────────────────────
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd" },
  automatic_installation = true,
})

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
  },
  capabilities = capabilities,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
  callback = function()
    vim.lsp.enable("clangd")
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Statusline
-- ─────────────────────────────────────────────────────────────────────────────
require("lualine").setup({
  options = {
    theme = "auto",
    icons_enabled = true,
  },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Git Signs
-- ─────────────────────────────────────────────────────────────────────────────
require("gitsigns").setup()

-- ─────────────────────────────────────────────────────────────────────────────
-- NvimTree
-- ─────────────────────────────────────────────────────────────────────────────
require("nvim-tree").setup()

-- ─────────────────────────────────────────────────────────────────────────────
-- Keymaps
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>")
