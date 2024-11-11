-- local function theme()
--   return vim.o.background == "light" and "dawnfox" or "duskfox"
-- end

return {
  { "shaunsingh/nord.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "rose-pine/neovim", name = "rose-pine", opts = {
    dark_variant = "moon",
  } },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
