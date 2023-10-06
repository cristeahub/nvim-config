-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end

vim.g.mapleader = " "

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
		use 'nvim-tree/nvim-web-devicons'
    use {'neoclide/coc.nvim', branch = 'release'}
    use 'junegunn/fzf'
		use { 'ibhagwan/fzf-lua',
			-- optional for icon support
			requires = { 'nvim-tree/nvim-web-devicons' }
		}
    use 'antoinemadec/coc-fzf'
    use {
	    'nvim-lualine/lualine.nvim',
	    requires = { 'nvim-tree/nvim-web-devicons' }
    } 
		use 'nanotech/jellybeans.vim'
    use 'lewis6991/gitsigns.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-context'
    use {'akinsho/bufferline.nvim', tag = "v4.4.0", requires = 'nvim-tree/nvim-web-devicons'}

		-- llm
		use 'david-kunz/gen.nvim'

    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- llm
require('gen').prompts['Elaborate_Text'] = {
  prompt = "Elaborate the following text:\n$text",
  replace = true
}
require('gen').prompts['Fix_Code'] = {
  prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
  replace = true,
  extract = "```$filetype\n(.-)```"
}

vim.api.nvim_set_keymap('n', '<leader>d', ':Gen<CR>', {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>d', ':Gen<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ge', ':Gen Elaborate_Text<CR>', {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>ge', ':Gen Elaborate_Text<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gf', ':Gen Fix_Code<CR>', {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>gf', ':Gen Fix_Code<CR>', {noremap = true})

-- colorscheme
vim.cmd('colorscheme jellybeans')

-- Bufferline
vim.opt.termguicolors = true
require("bufferline").setup {
	options = {
		style = "padded_slant",
		always_show_bufferline = true,
		diagnostics = "coc",
	}
}

-- Lualine
require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {'filename'},
		lualine_x = {'filesize', 'encoding', 'filetype', 'g:coc_status'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	extensions = {},
}

-- Turn on line numbers:
vim.wo.number = true
vim.wo.relativenumber = true

vim.bo.tabstop=2
vim.bo.shiftwidth=2
vim.g.smarttab=true
vim.g.expandtab=true
vim.bo.softtabstop=4
vim.bo.autoindent=true
vim.g.tabpagemax=9999999
vim.bo.backupcopy='yes'
vim.bo.synmaxcol=500 --Don't bother highlighting anything over 500 chars

vim.api.nvim_set_keymap('c', 'w!!', '%!sudo tee > /dev/null %', {})

-- fzf
vim.api.nvim_set_keymap('n', '<leader>f', ':FzfLua git_files<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>r', ':FzfLua grep<CR>', {noremap = true})
vim.cmd([[
let g:fzf_action = {'enter': 'tabedit'}
]])

local actions = require "fzf-lua.actions"
require'fzf-lua'.setup {
	actions = {
    files = {
      ["default"]     = actions.file_tabedit,
		}
	}
}

require('fzf-lua').register_ui_select()

-- lazyredraw
vim.cmd([[
set lazyredraw
]])

-- Coc
vim.cmd([[
set hidden
set cmdheight=1
set signcolumn=yes
]])

vim.cmd([[
set updatetime=300

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <leader>rn <Plug>(coc-rename)

nmap <leader>sf <Plug>(coc-format-selected)

xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

nmap <leader>ac <Plug>(coc-codeaction)

nmap <leader>qf <Plug>(coc-fix-current)

xmap <silent> <TAB> <Plug>(coc-range-select)
nmap <silent> <TAB> <Plug>(coc-range-select)
nmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

nmap <leader>j <Plug>(coc-diagnostic-next-error)
nmap <leader>k <Plug>(coc-diagnostic-prev-error)
nmap <leader>n <Plug>(coc-diagnostic-next)
nmap <leader>p <Plug>(coc-diagnostic-prev)
]])

require("nvim-treesitter.configs").setup {
    rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        colors = {
            "#73de95",
            "#7cf2e0",
            "#b3a9f5",
            "#f26bd7",
            "#f7ed23",
        }, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    }
}

require('gitsigns').setup {
    signs = {
        add = {hl = 'GitSignsAdd' , text = '│', numhl='GitSignsAddNr' , linehl='GitSignsAddLn'},
        change = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    signcolumn = true, -- Toggle with :Gitsigns toggle_signs
    numhl = true, -- Toggle with :Gitsigns toggle_numhl
    linehl = false, -- Toggle with :Gitsigns toggle_linehl
    word_diff = true, -- Toggle with :Gitsigns toggle_word_diff
    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with :Gitsigns toggle_current_line_blame
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 10,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <abbrev_sha> <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    yadm = {
        enable = false
    },
}

require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = "all",

    -- Install parsers synchronously (only applied to ensure_installed)
    sync_install = false,

    -- List of parsers to ignore installing (for "all")
    ignore_install = {"phpdoc", "sql"},

    highlight = {
        -- false will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = { "sql" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if max_lines is exceeded. Choices: 'inner', 'outer'
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function',
            'method',
            -- 'for', -- These won't appear in the context
            -- 'while',
            -- 'if',
            -- 'switch',
            -- 'case',
        },
        -- Example for a specific filetype.
        -- If a pattern is missing, open a PR so everyone can benefit.
        -- rust = {
        -- 'impl_item',
        -- },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
}

vim.cmd([[
hi GitSignsAddInline guibg=#336449 term=underline
hi GitSignsChangeInline guibg=#8d6d4f term=underline
hi GitSignsDeleteInline guibg=#7e1920 term=underline
hi GitSignsAddLnInline guibg=#336449 term=underline
hi GitSignsChangeLnInline guibg=#8d6d4f term=underline
hi GitSignsDeleteLnInline guibg=#7e1920 term=underline
hi GitSignsAddVirtLnInline guibg=#336449 term=underline
hi GitSignsChangeVirtLnInline guibg=#8d6d4f term=underline
hi GitSignsDeleteVirtLnInline guibg=#7e1920 term=underline

nmap <leader>h :Gitsigns toggle_deleted<CR>

set lazyredraw
]])

vim.cmd([[
let g:coc_global_extensions = [
\'coc-json',
\'coc-tsserver',
\'coc-pyright',
\'coc-prettier',
\'coc-html',
\'coc-markdownlint',
\'coc-css',
\'coc-lists',
\'coc-eslint',
\'coc-yaml',
\'coc-sh',
\'coc-docker',
\'coc-vimlsp',
\'coc-lightbulb',
\'coc-sql',
\'coc-toml',
\'coc-xml',
\'coc-spell-checker',
\'coc-tailwindcss',
\'coc-actions',
\'coc-svg',
\'coc-git'
\]
]])
