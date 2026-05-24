--[[ Options ]]
vim.g.mapleader = ' '
vim.g.have_nerd_font = true

-- Enables autocomplete suggestions while typing
vim.opt.autocomplete = true
-- Where to scan for complete options
vim.opt.complete = ".,w,b,u,t,o"
-- Options for Insert mode completion
vim.opt.completeopt = { "menuone", "fuzzy", "popup", "noselect" }
-- Completion border
vim.opt.pumborder = "bold"
-- Number of complete suggestions
vim.opt.pumheight = 10
-- Displays number of current line
vim.opt.number = true
-- Display numbers relative to current line
vim.opt.relativenumber = true
-- Start scrolling up/down when scrolloff value from top/bottom
vim.opt.scrolloff = 8
-- Same as scrolloff but horizontally and when wrap = false
vim.opt.sidescrolloff = 8
-- Break lines in the buffer
vim.opt.wrap = false
-- Visual width of tab character \t
vim.opt.tabstop = 4
-- Number of spaces a tab key inserts
vim.opt.softtabstop = 4
-- Indent value for auto-indenting
vim.opt.shiftwidth = 4
-- Convert tab to spaces (useful for \t deniers like yaml)
vim.opt.expandtab = true
-- Border type
vim.opt.winborder = "bold"
-- auto-indenting when starting a new line
vim.opt.smartindent = true
-- Ignore case in search patterns
vim.opt.ignorecase = true
-- Override the ignorecase when using upper case characters in the search pattern
vim.opt.smartcase = true
-- Keep previous search patterns highlighted
vim.opt.hlsearch = false
-- Show where the pattern matches as you are typing
vim.opt.incsearch = true
-- Put split window on the right of the current one
vim.opt.splitright = true
-- Put split window bellow the current one (for vsplit)
vim.opt.splitbelow = true
-- When and how to draw the signcolumn
vim.opt.signcolumn = 'yes'
-- List of columns highlighted with hl-ColorColumn
vim.opt.colorcolumn = ""

vim.opt.listchars = {
    tab = '> ',
    space = '-',
    trail = '-',
    eol = '¶'
}

vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"

--[[ Packages ]]
vim.pack.add({
    { src = "https://github.com/connormxfadden/petrolnoir.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    {
        src = "https://github.com/stevearc/oil.nvim",
        data = { view_options = { show_hidden = true } }
    },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/chomosuke/typst-preview.nvim" },
})
require("mason").setup()

require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>-", require("oil").toggle_float)

vim.cmd("colorscheme petrolnoir")

vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bold = true })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a2a" })

--[[ LSP ]]
vim.lsp.enable({ "lua_ls", "clangd", "fortls", "ruff", "basedpyright", "rust_analyzer", "tinymist", "bashls" })

-- diagnostics
vim.diagnostic.config({
    float = { source = true },
})
vim.keymap.set("n", "<C-w>d", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)

-- Buffer-local LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        -- Autocompletion
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client then
            vim.lsp.completion.enable(true, client.id, event.buf, {
                autotrigger = true,
                convert = function(item)
                    return { abbr = item.label:gsub("%b()", "") }
                end,
            })
        end

        local opts = { buffer = event.buf }

        -- Navigation
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- int foo;
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)  -- foo = 2;
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)  -- list of all uses
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

        -- Information
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

        -- Actions
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

        -- Workspace
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
    end,
})

--[[ autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Disable autocomments in new line
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')
