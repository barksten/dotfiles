local lspconfig = require("lspconfig")
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
          root_dir = lspconfig.util.root_pattern("Package.swift", ".git"),
        },
        gleam = {},
      },
    },
  },
}
