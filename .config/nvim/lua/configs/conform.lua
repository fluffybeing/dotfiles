local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    python = { "isort", "black" },
    swift = { "swift_format" },
  },

  formatters = {
    -- Python
    black = {
      prepend_args = {
        "--fast",
        "--line-length",
        "80",
      },
    },
    isort = {
      prepend_args = {
        "--profile",
        "black",
      },
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

-- Autocommand to handle trailing spaces and newlines
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Remove trailing spaces
    vim.cmd([[%s/\s\+$//e]])

    -- Remove empty lines at the top
    vim.cmd([[
      while getline(1) == ''
        execute '1delete'
      endwhile
    ]])

    -- Ensure one and only one empty line at the end of the file
    vim.cmd([[
      let last_line = line('$')
      if getline(last_line) == ''
        " If last line is empty, remove any additional empty lines
        while getline(last_line) == ''
          execute last_line . 'delete'
          let last_line = last_line - 1
        endwhile
      endif

      " Now append one empty line at the end
      call append('$', '')
    ]])
  end,
})

return options
