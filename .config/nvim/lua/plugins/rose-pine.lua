return {
  { "rose-pine/neovim", name = "rose-pine" },
  -- Configure LazyVim to load rose-pine
  {
    "LazyVim/LazyVim",
    opts = {
      dark_variant = "moon", -- main, moon, or dawn
      colorscheme = "rose-pine",
    },
  },
}
