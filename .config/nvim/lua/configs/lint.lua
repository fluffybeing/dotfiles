local lint = require("lint")

lint.linters_by_ft = {
  markdown = { 'vale' },
  lua = { "luacheck" },
  python = { "flake8" },
}

-- Supress warning for things we don't want
-- lint.linters.luacheck.args = {
--   "--globals",
--   "love",
--   "vim",
--   "--formatter",
--   "plain",
--   "--codes",
-- }

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
