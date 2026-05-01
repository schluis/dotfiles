if vim.g.neovide then
  vim.api.nvim_set_keymap(
    "n",
    "<C-+>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<C-_>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })

  vim.g.neovide_cursor_vfx_mode = "sonicboom"
  -- vim.g.neovide_cursor_vfx_mode = "ripple"
  -- vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_cursor_trail_size = 0.5
end

vim.keymap.set("i", "<C-;>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.keymap.set("i", "<C-H>", "copilot#Previous()", { silent = true, expr = true })
vim.keymap.set("i", "<C-K>", "copilot#Next()", { silent = true, expr = true })
vim.g.copilot_no_tab_map = true

local function SuggestOneWord()
  local suggestion = vim.fn["copilot#Accept"] ""
  local bar = vim.fn["copilot#TextQueuedForInsertion"]()
  return vim.fn.split(bar, [[[ .]\zs]])[1]
end
vim.keymap.set("i", "<C-L>", SuggestOneWord, { expr = true, remap = false })

if vim.fn.exists "g:os" == 0 then
  local is_windows = vim.fn.has "win64" == 1 or vim.fn.has "win32" == 1 or vim.fn.has "win16" == 1
  if is_windows then
    vim.g.os = "Windows"
  else
    local uname_output = vim.fn.system "uname"
    vim.g.os = string.gsub(uname_output, "\n", "")
  end
end

if vim.g.os == "Windows" then
  vim.opt.shell = "powershell.exe"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = '\\"'
  vim.opt.shellxquote = ""
  vim.opt.shellpipe = "|"
  vim.opt.shellredir = "| Out-Host"
  -- vim.g.loaded_man = 1
end

vim.api.nvim_create_user_command("TypstPin", function()
  local tinymist_id = nil
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == "tinymist" then
      tinymist_id = client.id
      break
    end
  end

  if not tinymist_id then
    vim.notify("tinymist not running!", vim.log.levels.ERROR)
    return
  end

  local client = vim.lsp.get_client_by_id(tinymist_id)
  if client then
    client.request("workspace/executeCommand", {
      command = "tinymist.pinMain",
      arguments = { vim.api.nvim_buf_get_name(0) },
    }, function(err)
      if err then
        vim.notify("error pinning: " .. err, vim.log.levels.ERROR)
      else
        vim.notify("succesfully pinned", vim.log.levels.INFO)
      end
    end, 0)
  end
end, {})

---@type LazySpec
return {
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = "#DA4939" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = "#FF875F" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = "#FFC66D" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo4", { fg = "#00FF03" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo5", { fg = "#00AFFF" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo6", { fg = "#8800FF" })

      opts.section.header.type = "group"
      opts.section.header.val = {
        {
          type = "text",
          val = "   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
          opts = { hl = "NeovimDashboardLogo1", shrink_margin = false, position = "center" },
        },
        {
          type = "text",
          val = "   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
          opts = { hl = "NeovimDashboardLogo2", shrink_margin = false, position = "center" },
        },
        {
          type = "text",
          val = "   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
          opts = { hl = "NeovimDashboardLogo3", shrink_margin = false, position = "center" },
        },
        {
          type = "text",
          val = "   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
          opts = { hl = "NeovimDashboardLogo4", shrink_margin = false, position = "center" },
        },
        {
          type = "text",
          val = "   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
          opts = { hl = "NeovimDashboardLogo5", shrink_margin = false, position = "center" },
        },
        {
          type = "text",
          val = "   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
          opts = { hl = "NeovimDashboardLogo6", shrink_margin = false, position = "center" },
        },
      }
      return opts
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      vim.g.opencode_opts = {
        models = { "claude-sonnet-4-20250514" },
      }
      vim.o.autoread = true

      vim.keymap.set(
        { "n", "t" },
        "<leader>k",
        function() require("opencode").toggle() end,
        { desc = "Toggle opencode" }
      )
      vim.keymap.set(
        { "n", "x" },
        "<leader><space>",
        function() require("opencode").ask("@this: ", { submit = true }) end,
        { desc = "Ask opencode…" }
      )
      vim.keymap.set(
        { "n", "x" },
        "<leader>x",
        function() require("opencode").select() end,
        { desc = "Execute opencode action…" }
      )
    end,
  },

  {
    "github/copilot.vim",
    lazy = false,
  },

  {
    "2kabhishek/co-author.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "CoAuthor" },
  },

  {
    "ranjithshegde/ccls.nvim",
    lazy = false,
  },

  {
    "akinsho/toggleterm.nvim",
    opts = function(_, opts)
      opts.direction = "float"
      return opts
    end,
  },
}
