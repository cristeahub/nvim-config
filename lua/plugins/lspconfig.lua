return {
  "neovim/nvim-lspconfig",
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    opts.servers.vtsls.settings.typescript.locale = "en"
    opts.inlay_hints.enabled = false
  end,
}
