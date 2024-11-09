return {
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.mypy,
      })
    end,
  },
}
