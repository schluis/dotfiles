---@type LazySpec
return {
  "nickjvandyke/opencode.nvim",
  enabled = vim.g.ai_provider == "opencode",
  version = "*",
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
    local service_json = vim.fn.expand "~/.config/opencode/service.json"
    local password
    if vim.fn.filereadable(service_json) == 1 then
      local ok, data = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(service_json), ""))
      if ok and data and data.password then password = data.password end
    end

    vim.g.opencode_opts = {
      server = {
        username = "opencode",
        password = password,
        start = function()
          vim.cmd("vsplit term://opencode --standalone | wincmd p")
        end,
      },
    }
    vim.o.autoread = true

    vim.api.nvim_create_autocmd("WinEnter", {
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].buftype == "terminal" then
          local name = vim.api.nvim_buf_get_name(buf)
          if name:match "opencode" then vim.cmd "startinsert" end
        end
      end,
    })

    vim.keymap.set(
      { "n", "x" },
      "<leader>k",
      function() require("opencode").ask() end,
      { desc = "Open opencode window" }
    )
    vim.keymap.set(
      { "n", "x" },
      "<C-a>",
      function() require("opencode").ask("@this: ", { submit = true }) end,
      { desc = "Ask opencode…" }
    )
    vim.keymap.set(
      { "n", "x" },
      "<C-x>",
      function() require("opencode").select() end,
      { desc = "Execute opencode action…" }
    )
  end,
}
