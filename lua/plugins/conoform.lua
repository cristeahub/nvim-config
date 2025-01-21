return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = {
      rust = { "rustfmt" },
      python = { "ruff" },
      typescript = { "prettierd", "prettier" },
    }
  end,
}
