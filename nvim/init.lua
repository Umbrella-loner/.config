-- ─────────────────────────────────────────────────────────────────────────────
-- Plugins Manager: lazy.nvim
-- ─────────────────────────────────────────────────────────────────────────────
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
  -- Theme
  { "nyoom-engineering/oxocarbon.nvim" },
  
  -- File Explorer
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-tree/nvim-web-devicons" },

  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Treesitter (disabled build command to avoid C compiler requirement)
  { 
    "nvim-treesitter/nvim-treesitter",
    build = function()
      -- Only run TSUpdate if a C compiler is available
      if vim.fn.executable("cc") == 1 or vim.fn.executable("gcc") == 1 or vim.fn.executable("clang") == 1 then
        vim.cmd("TSUpdate")
      end
    end
  },

  -- LSP Configuration
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Autopairs
  { 
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end
  },

  -- Git
  { "lewis6991/gitsigns.nvim" },

  -- Statusline
  { "nvim-lualine/lualine.nvim" },

  -- Copilot
  { "github/copilot.vim" },
})
-- ─────────────────────────────────────────────────────────────────────────────


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
-- Theme
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.background = "dark"
vim.cmd.colorscheme("oxocarbon")


-- ─────────────────────────────────────────────────────────────────────────────
-- Treesitter Configuration
-- ─────────────────────────────────────────────────────────────────────────────
local has_compiler = vim.fn.executable("cc") == 1 or vim.fn.executable("gcc") == 1 or vim.fn.executable("clang") == 1

if has_compiler then
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  })
else
  -- Basic treesitter setup without automatic installation
  require("nvim-treesitter.configs").setup({
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  })
end


-- ─────────────────────────────────────────────────────────────────────────────
-- LSP Configuration
-- ─────────────────────────────────────────────────────────────────────────────
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd" },
  automatic_installation = true,
})

-- Setup nvim-cmp for autocompletion
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
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Setup LSP capabilities for autocompletion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP keymaps and settings
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
end

-- Configure clangd for C/C++ (using new Neovim 0.11+ API)
vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", ".git" },
  capabilities = capabilities,
}

-- Enable clangd LSP
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
  callback = function()
    vim.lsp.enable("clangd")
    -- Apply keymaps
    local bufnr = vim.api.nvim_get_current_buf()
    on_attach(nil, bufnr)
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
-- Git signs
-- ─────────────────────────────────────────────────────────────────────────────
require("gitsigns").setup()


-- ─────────────────────────────────────────────────────────────────────────────
-- NvimTree Configuration
-- ─────────────────────────────────────────────────────────────────────────────
require("nvim-tree").setup()


-- ─────────────────────────────────────────────────────────────────────────────
-- Keymaps
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>")
