
-- Extended init file for neovim stuff only

-- plugins confis  {{{1
-- mason: auto-installer for language client languages {{{2
local masonOk, mason = pcall(require, "mason")
if masonOk then
  mason.setup {
    ui = {
      icons = {
        package_installed = "✓"
      }
    }
  }
  require("mason-lspconfig").setup {}
end



-- nvim-cmp. {{{2
local cmp = require("cmp")

cmp.setup({
  snippet = { -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'tags' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- LSP  {{{2

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', ',e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',d', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',p', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rm', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>;f', '<cmd>vim.lsp.buf.format { async = true }<CR>', opts)

end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local ltexLanguages = {
  -- default:
  "bibtex", "context", "context.tex", "html", "latex", "markdown", "org", "restructuredtext", "rsweave",
  -- additional:
  "jira",
}

-- make sure phpactor is in the path. Eg: PATH="$PATH:$HOME/.vim/bundle/phpactor/bin"
-- :LspInstallInfo
local servers = {
    'phpactor',
    'rust_analyzer',
    -- 'tsserver',
    'jdtls',
    'bashls',
    'vimls',
    'marksman',
    'lua_ls',
    'basedpyright',
}
-- 'ltex', -- added extra below
-- 'kotlin_language_server', -- Has problems with large projects

for _, lsp in pairs(servers) do
  vim.lsp.config(lsp, {
    capabilities = capabilities,
    on_attach = on_attach
  })
end

-- same as above, but special case for ltex

vim.lsp.config('ltex', {
  capabilities = capabilities,
  filetypes = {}, -- do not add ltex automatically
  on_attach = on_attach,
  settings = {
    ltex = {
      enabled = false,
    },
  },
})


-- ServerConfig: ltex
-- Grammar/Spell Checker Using LanguageTool with Support for LATEX,
-- Markdown, and Others


-- vim.lsp.config('ltex', {
--   settings = {
--     ltex = {
--       enabled = false,
--     },
--   },
-- })

vim.api.nvim_create_user_command(
  'LngOn',
  function(opts)
    local providedLanguage = opts.fargs[1]
    if not providedLanguage == nil then
      print("Enabling ltex (globally) with langauge:",providedLanguage)
    else
      print("Enabling ltex (globally) with default langauge (en-US)")
    end

    vim.lsp.config('ltex', {
      settings = {
        ltex = {
          enabled = ltexLanguages,
          language = providedLanguage,
        },
      },
      filetypes = ltexLanguages,
    })

    -- in the setup, ltex is configured to not be autostarted. This enables lsp
    -- to start reading the filetype
    vim.lsp.enable('ltex')
    -- now reload the file so ltex gets started
    vim.cmd("edit")

  end,
  { nargs = '?' }
)

vim.api.nvim_create_user_command(
  'LngOff',
  function()
    print("Disabling ltex (globally)")

    -- now disable the language server
    vim.lsp.enable('ltex', false)
  end,
  {}
)

-- Detaches the ltex language tool plugin from the current buffer. This is
-- usefull when multiple buffers are opened and spellchecking should only be
-- done in one of them.
vim.api.nvim_create_user_command(
  'LngDetatch',
  function()
    local bufNr = vim.fn.bufnr()
    for index, client in ipairs(vim.lsp.get_clients({name='ltex'})) do
      print("Disconnecting Languagetool from bufNr:", bufNr)
      vim.lsp.buf_detach_client(bufNr, client['id'])
    end
  end,
  {}
)

-- treesitter  {{{2

local treesitterOk, treesitter = pcall(require, "nvim-treesitter.configs")
if treesitterOk then
  treesitter.setup({
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline", "bash" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    -- sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    -- ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    -- highlight = {
    --   enable = true,

    --   -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    --   -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    --   -- the name of the parser)
    --   -- list of language that will be disabled
    --   disable = { "c", "rust" },
    --   -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    --   disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --       return true
    --     end
    --   end,

    --   -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    --   -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    --   -- Using this option may slow down your editor, and you may see some duplicate highlights.
    --   -- Instead of true it can also be a list of languages
    --   additional_vim_regex_highlighting = false,
    -- },
  })
end

-- diff-view  {{{2

local diffviewOk, diffview = pcall(require, "diffview")
if diffviewOk then
  diffview.setup({
    use_icons = false,
    signs = {
      fold_closed = "> ",
      fold_open = "v ",
      done = "✓",
    }
  })
end

-- refactoring  {{{2

local refactoringOk, refactoring = pcall(require, "refactoring")
if refactoringOk then
  refactoring.setup()
end

-- aerial  {{{2
-- code outline window using lsp

local aerialOk, aerial = pcall(require, "aerial")
if aerialOk then
  aerial.setup({
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { buffer = bufnr })
      vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    end,
  })
end

-- harpoon  {{{2
-- Saving favorite files in a separate menu

local harpoonOk, harpoon = pcall(require, "harpoon")
if harpoonOk then
  harpoon:setup()

  vim.keymap.set("n", "<leader>ga", function() harpoon:list():add() end)
  vim.keymap.set("n", "<leader>gm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

  -- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
  -- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
  -- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
  -- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

  -- Toggle previous & next buffers stored within Harpoon list
  vim.keymap.set("n", "<leader>gn", function() harpoon:list():prev() end)
  vim.keymap.set("n", "<leader>gp", function() harpoon:list():next() end)

end



-- }}}
-- vim:fdm=marker
