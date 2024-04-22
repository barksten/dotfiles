return {
  { "rose-pine/neovim", name = "rose-pine", opts = {
    dark_variant = "moon",
  } },
  -- Configure LazyVim to load rose-pine
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
