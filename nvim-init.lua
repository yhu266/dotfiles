require'packer'.startup(function(use)
  -- package management
  use 'wbthomason/packer.nvim'
  -- utility
  use 'Iron-E/nvim-cartographer'
  -- editing
  use 'lewis6991/spellsitter.nvim'
  use 'b3nj5m1n/kommentary'
  use {'JoosepAlviste/nvim-ts-context-commentstring', requires = {'nvim-treesitter/nvim-treesitter'}}
  use 'norcalli/snippets.nvim'
  use {'nvim-lua/completion-nvim', requires = {'steelsojka/completion-buffers'}}
  use 'Pocco81/AutoSave.nvim'
  -- navigation
  use 'karb94/neoscroll.nvim'
  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}}
  use 'ggandor/lightspeed.nvim'
  use 'nacro90/numb.nvim'
  -- UI
  use {'haringsrob/nvim_context_vt', requires = {'nvim-treesitter/nvim-treesitter'}}
  use 'RRethy/nvim-base16'
  use 'hoob3rt/lualine.nvim'
  -- git
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
  -- LSP & AST
  use 'neovim/nvim-lspconfig'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  -- extra
  use '~/Documents/nvim-extra'
  -- use 'yhu266/nvim-extra'
end)

-- Iron-E/nvim-cartographer
local map = require'cartographer'

-- lewis6991/spellsitter.nvim
require('spellsitter').setup {
  hl = 'SpellBad',
  captures = {'comment'},
}

-- b3nj5m1n/kommentary
require('kommentary.config').configure_language("default", {
  prefer_single_line_comments = true,
  use_consistent_indentation = true,
  ignore_whitespace = true,

  -- JoosepAlviste/nvim-ts-context-commentstring
  single_line_comment_string = 'auto',
  multi_line_comment_strings = 'auto',
  hook_function = function()
    require('ts_context_commentstring.internal').update_commentstring()
  end,
})

-- norcalli/snippets.nvim
require'snippets'.use_suggested_mappings()
require'snippets'.snippets = {
  _global = {},
  lua = {},
  c = {},
}

-- nvim-lua/completion-nvim
local completion_on_attach = function()
  require'completion'.on_attach({
    sorting = 'length',
    matching_strategy_list = {'exact', 'substring', 'fuzzy'},
    matching_ignore_case = 1,
    trigger_keyword_length = 3,
    auto_change_source = 1,
    enable_snippet = 'snippets.nvim',
    chain_complete_list = {
      default = {
        {complete_items = {'lsp', 'snippet', 'buffers'}},
        {complete_items = {'path'}, triggered_only = {'/'}},
        {mode = {'<c-p>'}},
        {mode = {'<c-n>'}},
      },
      comment = {},
    },
  })
end
map.i.nore.expr['<S-TAB>'] = 'pumvisible() ? "\\<C-p>" : "\\<TAB>"'
map.i.nore.expr['<TAB>'] = 'pumvisible() ? "\\<C-n>" : "\\<TAB>"'

-- Pocco81/AutoSave.nvim
require'autosave'.setup {
  execution_message = 'saved at '..vim.fn.strftime("%H:%M:%S"),
  events = {'InsertLeave'},
}

-- karb94/neoscroll.nvim
require'neoscroll'.setup {}

-- nvim-telescope/telescope.nvim
require'telescope'.setup {
  defaults = {
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    layout_strategy = 'vertical',
    layout_config = {vertical = {height = {padding = 1}, width = {padding = 1}}},
  },
  pickers = {
    find_files = {previewer = false},
    buffers = {previewer = false},
  },
}
local fd_find_command = '{"fd", "-t", "f", "-i", "-H", "-L", "-E", ".git", "-c", "never"}'
map.n.nore['<LEADER>ff'] = '<CMD>lua require("telescope.builtin").find_files({find_command='..fd_find_command..'})<CR>'
map.n.nore['<LEADER>fg'] = '<CMD>lua require("telescope.builtin").live_grep()<CR>'
map.n.nore['<LEADER>fb'] = '<CMD>lua require("telescope.builtin").buffers()<CR>'
map.n.nore['<LEADER>fh'] = '<CMD>lua require("telescope.builtin").help_tags()<CR>'

-- ggandor/lightspeed.nvim
require'lightspeed'.setup {
  jump_to_first_match = false,
  limit_ft_matches = 7,
}

-- nacro90/numb.nvim
require'numb'.setup {
  number_only = true,
}

-- haringsrob/nvim_context_vt
require'nvim_context_vt'.setup {}

-- RRethy/nvim-base16
vim.cmd('colorscheme base16-solarized-dark')

-- hoob3rt/lualine.nvim
require'lualine'.setup {
  options = {
    icons_enabled = false,
    theme = 'solarized_dark',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {{'diff', colored = false, symbols = {added = 'A', modified = 'C', removed = 'D'}}},
    lualine_y = {'location'},
    lualine_z = {{'filetype', colored = false}},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {
    'quickfix',
  },
}

-- lewis6991/gitsigns.nvim
require('gitsigns').setup {
  signs = {
    add = {text = 'A'},
    change = {text = 'C'},
    delete = {text = 'D'},
    topdelete = {text = 'D'},
    changedelete = {text = 'C'},
  },
  numhl = false,
  linehl = false,
}

-- neovim/nvim-lspconfig
local sumneko_root_path = vim.fn.getenv('HOME')..'/Documents/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/macOS/lua-language-server'
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')
require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
  on_attach = completion_on_attach,
  settings = {
    Lua = {
      runtime = {version = 'LuaJIT', path = runtime_path},
      diagnostics = {globals = {'vim'}},
      workspace = {library = vim.api.nvim_get_runtime_file('', true)},
      telemetry = {enable = false},
    },
  },
}
require'lspconfig'.clangd.setup {
  cmd = {'/usr/local/opt/llvm/bin/clangd'},
  on_attach = completion_on_attach,
  filetypes = {'c', 'cpp'},
}
require'lspconfig'.texlab.setup {
  on_attach = completion_on_attach,
  settings = {
    texlab = {
      chktex = {
        onOpenAndSave = true,
      },
    },
  },
}

-- nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'c', 'cmake', 'latex', 'lua'},
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {enable = false},

  -- JoosepAlviste/nvim-ts-context-commentstring
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}

-- yhu266/nvim-extra

-- key mappings
vim.api.nvim_set_keymap('', '<space>', '<leader>', {})
vim.api.nvim_set_keymap('i', 'jk', '<esc>', {noremap = true})
vim.api.nvim_set_keymap('n', '<up>', '<nop>', {})
vim.api.nvim_set_keymap('n', '<down>', '<nop>', {})
vim.api.nvim_set_keymap('n', '<left>', '<nop>', {})
vim.api.nvim_set_keymap('n', '<right>', '<nop>', {})
vim.api.nvim_set_keymap('n', 'j', 'gj', {})
vim.api.nvim_set_keymap('n', 'k', 'gk', {})
vim.api.nvim_set_keymap('n', '<leader><space>', '<cmd>nohlsearch<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>w', '<cmd>w!<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>q!<cr>', {noremap = true})

-- editing
vim.opt.fileignorecase = true
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
vim.opt.pumheight = 9
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.guicursor = 'a:block'
vim.opt.shortmess = 'acIFoOtT'
vim.opt.cursorline = true
vim.opt.showtabline = 0
vim.opt.foldenable = false
vim.opt.showmode = false
vim.opt.viewoptions = {'cursor', 'folds', 'slash', 'unix'}
vim.opt.wrap = true

-- misc
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.wildignore = {'*.o', '*.swp', '*.DS_Store', '*.git', '*.h5'}
vim.opt.wildignorecase = true