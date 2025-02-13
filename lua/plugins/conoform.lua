return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = {},
      rust = { "rustfmt" },
      python = { "ruff_format", "ruff" },
      typescript = { "prettierd", "prettier" },
    },
  },
}
