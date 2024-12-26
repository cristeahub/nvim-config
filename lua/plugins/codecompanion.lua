return {
  {
    "olimorris/codecompanion.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          llama3 = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "llama3", -- Give this adapter a different name to differentiate it from the default ollama adapter
              schema = {
                model = {
                  default = "qwen2.5-coder:32b",
                },
                num_ctx = {
                  default = 4096,
                },
                num_predict = {
                  default = -1,
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = "llama3",
          },
          inline = {
            adapter = "llama3",
          },
          agent = {
            adapter = "llama3",
          },
        },
        display = {
          chat = {
            window = {
              layout = "vertical", -- float|vertical|horizontal|buffer
            },
          },
        },
        opts = {
          system_prompt = function()
            return "You are a world-class programmer in all programming languages. You will be asked various questions about various code bases and you will answer them accurately."
          end,
        },
      })
    end,
    init = function()
      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd([[cab cc CodeCompanion]])
    end,
    keys = {
      { "<leader>a", group = "codecompanion", desc = "CodeCompanion" },
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "Toggle CodeCompanion",
      },
      {
        "<C-a>",
        "<cmd>CodeCompanionActions<cr>",
        desc = "Run CodeCompanion actions",
      },
      {
        "<leader>ag",
        "<cmd>CodeCompanionChat Add<cr>",
        desc = "Add to CodeCompanionChat",
      },
    },
  },
}
