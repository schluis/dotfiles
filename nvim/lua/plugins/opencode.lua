---@type LazySpec
return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      ---@module "snacks"
      "folke/snacks.nvim",
      optional = false,
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
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

    local function opencode_toggle_and_insert()
      local oc = require "opencode"
      oc.toggle()
      -- After toggle, find the opencode terminal window and enter insert mode in it
      vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "terminal" then
            local name = vim.api.nvim_buf_get_name(buf)
            if name:match "opencode" then
              vim.api.nvim_set_current_win(win)
              vim.cmd "startinsert"
              return
            end
          end
        end
      end)
    end

    vim.keymap.set({ "n", "x", "t" }, "<C-k>", opencode_toggle_and_insert, { desc = "Toggle opencode window" })
    vim.keymap.set(
      { "n", "x" },
      "<leader>k",
      function() require("opencode").start() end,
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
    vim.keymap.set({ "n", "t" }, "<C-.>", opencode_toggle_and_insert, { desc = "Toggle opencode" })

    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  end,
}
