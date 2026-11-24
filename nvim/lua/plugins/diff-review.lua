---@type LazySpec
return {
  "talldan/nvim-diff-review-opencode-plugin",
  enabled = vim.g.ai_provider == "opencode",
  dependencies = { "sindrets/diffview.nvim" },
  config = function()
    require("diff-review").setup()
  end,
}
