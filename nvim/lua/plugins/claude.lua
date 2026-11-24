---@type LazySpec
return {
  "coder/claudecode.nvim",
  enabled = vim.g.ai_provider == "claude",
  dependencies = {
    {
      ---@module "snacks"
      "folke/snacks.nvim",
      optional = false,
      opts = {
        input = {},
        picker = {},
      },
    },
  },
  config = function()
    local is_windows = vim.fn.has "win32" == 1
    -- Ink (Claude Code's UI framework) auto-detects kitty keyboard protocol
    -- support via $TERM_PROGRAM. Inside Neovim's conpty on Windows the variable
    -- is unset, so detection fails and Ctrl+Enter is ignored. Force it (Windows only) so
    -- Ink enables the protocol and interprets \x1b[13;5u as Ctrl+Enter.
    if is_windows then vim.env.TERM_PROGRAM = "xterm-kitty" end

    require("claudecode").setup {
      terminal = {
        provider = "snacks",
      },
      diff_opts = {
        layout = "unified",
        keep_terminal_focus = true,
      },
    }
    vim.o.autoread = true

    vim.keymap.set("n", "<leader>k", function() vim.cmd "ClaudeCodeFocus" end, { desc = "Focus Claude Code" })
    vim.keymap.set("x", "<leader>k", "<Esc><cmd>ClaudeCodeFocus<CR>", { desc = "Focus Claude Code" })
  end,
}
