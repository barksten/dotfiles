-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if true then return {} end

return {
  { "shaunsingh/nord.nvim" },

  -- Configure LazyVim to load nord
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nord",
    },
  },
}
