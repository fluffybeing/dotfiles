local lint = require("lint")

lint.linters_by_ft = {
  markdown = { "vale" },
  python = { "flake8" },
  swift = { "swiftlint" },
}

-- Supress warning for things we don't want
local unpack = table.unpack or unpack
local agruments = unpack(lint.linters.luacheck.args)
lint.linters.luacheck.args = {
  agruments,
  "--globals",
  "love",
  "vim",
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
