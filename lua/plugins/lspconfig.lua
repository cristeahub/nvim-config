return {
  "neovim/nvim-lspconfig",
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    opts.inlay_hints.enabled = false
  end,
}
