vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.encoding = "utf-8"
vim.opt.textwidth = 120
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.cindent = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.background = "light"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local config_startuptime = {
	"dstein64/vim-startuptime",
	cmd = "StartupTime",
	init = function()
		vim.g.startuptime_tries = 10
	end,
}

local config_colorscheme = {
	'rebelot/kanagawa.nvim',
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd.colorscheme('kanagawa')
	end,
}

local config_modeline = {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		require("lualine").setup {
			sections = {
				lualine_c = { 'filename', 'progress', 'location' },
				lualine_y = {},
				lualine_z = {},
			}
		}
	end,
}

local config_keyhelp = {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		delay = 1000
	}
}

local config_complete = {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline"
	},
	config = function()
		local cmp = require('cmp')
		cmp.setup({
			mapping = cmp.mapping.preset.insert {
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
			},
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'buffer' },
				{ name = 'path' },
			},
			completion = {
				keyword_length = 2,
			}
		})
		cmp.setup.cmdline('/', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = 'buffer' }
			}
		})
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
				{name = 'cmdline' }
			})
		})
	end,
}

local config_jump = {
	"folke/flash.nvim",
	event = "VeryLazy",
	keys = {
		{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
		{ "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
		{ "r",     mode = "o",               function() require("flash").remote() end, desc = "Remote Flash" },
		{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end, desc = "Toggle Flash Search" },
	},
}

local config_finder = {
	"ibhagwan/fzf-lua",
	event = "VeryLazy",
	config = function()
		vim.keymap.set('n', '<leader>ff', function() require('fzf-lua').files() end, { desc = "find file" })
		vim.keymap.set('n', '<leader>fg', function() require('fzf-lua').git_files() end, { desc = "find git file" })
		vim.keymap.set('n', '<leader>fr', function() require('fzf-lua').oldfiles() end, { desc = "find history" })
		vim.keymap.set('n', '<leader>fl', function() require('fzf-lua').lgrep_curbuf() end, { desc = "find line" })
		vim.keymap.set('n', '<leader>fb', function() require('fzf-lua').buffers() end, { desc = "find buffer" })
		vim.keymap.set('n', '<leader>fe', function() require('fzf-lua').diagnostics_workspace() end, { desc = "find diagnostics" })
		vim.keymap.set("n", "<leader>cd", function() vim.cmd("cd %:p:h") end)
	end,
}

local config_lsp = {
	'neovim/nvim-lspconfig',
	config = function()
		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		local lsp = require('lspconfig')
		lsp.clangd.setup {
			capabilities = capabilities,
		}
		lsp.gopls.setup {
			capabilities = capabilities,
		}
		lsp.rust_analyzer.setup {
			capabilities = capabilities,
		}
		lsp.lua_ls.setup {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { 'vim' }
					}
				}
			}
		}
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('UserLspConfig', {}),
			callback = function(ev)
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf })
				vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf })
				vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf })
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf })
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf })
				vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf })
				vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = ev.buf, desc = "lsp_rename" })
				vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf })
				vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { buffer = ev.buf, desc = "lsp_format" })
			end,
		})
	end,
}

local config_lsp_ext = {
	'nvimdev/lspsaga.nvim',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		require('lspsaga').setup()
	end,
}

local config_treesitter = {
	'nvim-treesitter/nvim-treesitter',
	config = function()
		require'nvim-treesitter.configs'.setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
			highlight = {
				enable = true,
				disable = function(lang, buf)
					local blacklists = {"c", "rust"}
					if vim.tbl_contains(blacklists, lang) then
						return true
					end

					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,

				additional_vim_regex_highlighting = false,
			}
		})
	end,
}

local config_lint = {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			python = { "pylint" },
			go = { "golangcilint" }
		}
		vim.api.nvim_create_autocmd({"BufWritePost"}, {
			callback = function()
				lint.try_lint()
			end,
		})
		vim.keymap.set("n", "<leader>cl", function() lint.try_lint() end, { desc = "Trigger linting for current file" })
	end,
}

local config_git_signs = {
	"lewis6991/gitsigns.nvim",
	config = function()
		require('gitsigns').setup()
	end,
}

require("lazy").setup({
	config_startuptime,
	config_colorscheme,
	config_modeline,
	config_keyhelp,
	config_finder,
	config_complete,
	config_jump,
	config_lsp,
	config_lsp_ext,
	config_treesitter,
	config_lint,
	config_git_signs,
})
