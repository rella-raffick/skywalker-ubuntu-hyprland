-- SRE/SDE language support
return {
  -- ── LazyVim language extras ──────────────────────────────────────────
  { import = "lazyvim.plugins.extras.lang.python" },     -- pyright + ruff
  { import = "lazyvim.plugins.extras.lang.go" },         -- gopls + tools
  { import = "lazyvim.plugins.extras.lang.typescript" }, -- ts_ls
  { import = "lazyvim.plugins.extras.lang.rust" },       -- rust-analyzer
  { import = "lazyvim.plugins.extras.lang.docker" },     -- dockerls + compose
  { import = "lazyvim.plugins.extras.lang.yaml" },       -- yamlls + schemas
  { import = "lazyvim.plugins.extras.lang.terraform" },  -- terraformls + tflint
  { import = "lazyvim.plugins.extras.lang.json" },       -- jsonls + schemastore
  { import = "lazyvim.plugins.extras.lang.toml" },       -- taplo
  { import = "lazyvim.plugins.extras.lang.markdown" },   -- markdownlint + preview
  { import = "lazyvim.plugins.extras.lang.ansible" },    -- ansiblels

  -- ── Extra Treesitter parsers ──────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "dockerfile",
        "go", "gomod", "gosum", "gowork",
        "hcl",        -- terraform/HCL
        "helm",
        "json", "json5", "jsonc",
        "python",
        "rust",
        "sql",
        "toml",
        "typescript", "tsx",
        "yaml",
      })
    end,
  },

  -- ── Mason tools ───────────────────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua", "prettier", "black", "isort",
        "shfmt", "gofumpt", "sql-formatter",
        -- Linters
        "shellcheck", "ruff", "hadolint",
        "golangci-lint", "yamllint",
        -- LSP / extras
        "bash-language-server",
        "helm-ls",
        "ansible-language-server",
        "sqls",
        "tflint",
      },
    },
  },

  -- ── LSP servers not covered by extras ────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        helm_ls = {},
        sqls = {},
      },
    },
  },
}
