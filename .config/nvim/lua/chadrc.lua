-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "chadracula",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

M.nvdash = {
  load_on_startup = true,
  buttons = {
    { txt = "󰈚  Recent Projects", keys = "fp", cmd = "SessionSearch" },
  },
}

return M
