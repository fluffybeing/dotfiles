vim.g.mapleader = " " -- sets leader key
vim.g.netrw_banner = 0 -- gets rid of the annoying banner for netrw
vim.g.netrw_browse_split = 4 -- open in prior window
vim.g.netrw_altv = 1 -- change from left splitting to right splitting
vim.g.netrw_liststyle = 3 -- tree style view in netrw
--vim.cmd("let g:netrw_list_hide=netrw_gitignore#Hide()")
vim.opt.title = true -- show title
vim.opt.syntax = "ON"
vim.opt.backup = false
vim.opt.compatible = false -- turn off vi compatibility mode
vim.opt.number = true -- turn on line numbers
vim.opt.relativenumber = true -- turn on relative line numbers
vim.opt.mouse = "a" -- enable the mouse in all modes
vim.opt.ignorecase = true -- enable case insensitive searching
vim.opt.smartcase = true -- all searches are case insensitive unless there's a capital letter
vim.opt.hlsearch = false -- disable all highlighted search results
vim.opt.incsearch = true -- enable incremental searching
vim.opt.wrap = true -- enable text wrapping
vim.opt.tabstop = 2 -- tabs=4spaces
vim.opt.shiftwidth = 2
vim.opt.fileencoding = "utf-8" -- encoding set to utf-8
vim.opt.pumheight = 10 -- number of items in popup menu
vim.opt.showtabline = 2 -- always show the tab line
vim.opt.laststatus = 2 -- always show statusline
vim.opt.signcolumn = "auto"
vim.opt.expandtab = false -- expand tab
vim.opt.smartindent = true
vim.opt.showcmd = true
vim.opt.cmdheight = 2
vim.opt.showmode = true
vim.opt.scrolloff = 8 -- scroll page when cursor is 8 lines from top/bottom
vim.opt.sidescrolloff = 8 -- scroll page when cursor is 8 spaces from left/right
vim.opt.guifont = "FiraCode Nerd Font:h13"
vim.opt.clipboard = unnamedplus
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.splitbelow = true -- split go below
vim.opt.splitright = true -- vertical split to the right
vim.opt.termguicolors = true -- terminal gui colors
vim.cmd([[
	set path+=**
	colorscheme catpuccin
	filetype plugin on
	set wildmenu
	:autocmd BufNewFile *.md 0r ~/.config/nvim/snippets/skeleton.md
	:autocmd BufWritePost *.h !make
	:autocmd BufNewFile *.mdx 0r ~/.config/nvim/snippets/skeleton.mdx
	command! Reload :source ~/.config/nvim/init.lua
	command! Make :!make
]])
--statusline
vim.cmd("highlight StatusType guibg=#b16286 guifg=#1d2021")
vim.cmd("highlight StatusFile guibg=#fabd2f guifg=#1d2021")
vim.cmd("highlight StatusModified guibg=#1d2021 guifg=#d3869b")
vim.cmd("highlight StatusBuffer guibg=#98971a guifg=#1d2021")
vim.cmd("highlight StatusLocation guibg=#458588 guifg=#1d2021")
vim.cmd("highlight StatusPercent guibg=#1d2021 guifg=#ebdbb2")
vim.cmd("highlight StatusNorm guibg=none guifg=white")
vim.o.statusline = " "
  .. ""
  .. " "
  .. "%l"
  .. " "
  .. " %#StatusType#"
  .. "<< "
  .. "%Y"
  .. "  "
  .. " >>"
  .. "%#StatusFile#"
  .. "<< "
  .. "%F"
  .. " >>"
  .. "%#StatusModified#"
  .. " "
  .. "%m"
  .. " "
  .. "%#StatusNorm#"
  .. "%="
  .. "%#StatusBuffer#"
  .. "<< "
  .. "﬘ "
  .. "%n"
  .. " >>"
  .. "%#StatusLocation#"
  .. "<< "
  .. "燐 "
  .. "%l,%c"
  .. " >>"
  .. "%#StatusPercent#"
  .. "<< "
  .. "%p%%  "
  .. " >> "

-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- reload config
map("n", "<leader>r", ":source ~/.config/nvim/init.lua<CR>") -- reload neovim config

-- Tab bindings
map("n", "<leader>t", ":tabnew<CR>") -- space+t creates new tab
map("n", "<leader>x", ":tabclose<CR>") -- space+x closes current tab
map("n", "<leader>j", ":tabprevious<CR>") -- space+j moves to previous tab
map("n", "<leader>k", ":tabnext<CR>") -- space+k moves to next tab

-- easy split generation
map("n", "<leader>v", ":vsplit") -- space+v creates a veritcal split
map("n", "<leader>s", ":split") -- space+s creates a horizontal split

-- easy split navigation
map("n", "<C-h>", "<C-w>h") -- control+h switches to left split
map("n", "<C-l>", "<C-w>l") -- control+l switches to right split
map("n", "<C-j>", "<C-w>j") -- control+j switches to bottom split
map("n", "<C-k>", "<C-w>k") -- control+k switches to top split

-- buffer navigation
map("n", "<Tab>", ":bnext <CR>") -- Tab goes to next buffer
map("n", "<S-Tab>", ":bprevious <CR>") -- Shift+Tab goes to previous buffer
map("n", "<leader>d", ":bd! <CR>") -- Space+d delets current buffer

-- adjust split sizes easier
map("n", "<C-Left>", ":vertical resize +3<CR>") -- Control+Left resizes vertical split +
map("n", "<C-Right>", ":vertical resize -3<CR>") -- Control+Right resizes vertical split -

-- Open netrw in 25% split in tree view
map("n", "<leader>e", ":25Lex<CR>") -- space+e toggles netrw tree view

-- Easy way to get back to normal mode from home row
map("i", "kj", "<Esc>") -- kj simulates ESC
map("i", "jk", "<Esc>") -- jk simulates ESC

-- Visual Maps
map("v", "<leader>r", '"hy:%s/<C-r>h//g<left><left>') -- Replace all instances of highlighted words
map("v", "<C-s>", ":sort<CR>") -- Sort highlighted text in visual mode with Control+S
map("v", "J", ":m '>+1<CR>gv=gv") -- Move current line down
map("v", "K", ":m '>-2<CR>gv=gv") -- Move current line up
