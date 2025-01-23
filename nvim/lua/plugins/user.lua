vim.api.nvim_set_keymap("i", "<C-L>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-H>", "copilot#Previous()", { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-K>", "copilot#Next()", { silent = true, expr = true })
vim.g.copilot_no_tab_map = true

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
-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

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
    "sQVe/sort.nvim",
    event = "BufRead",
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
    "akinsho/nvim-toggleterm.lua",
    config = require("toggleterm").setup {
      direction = "float",
      persist_mode = true,
    },
  },

  {
    "ranjithshegde/ccls.nvim",
    lazy = false,
  },

  {
    "akinsho/toggleterm.nvim",
    opts = {
      direction = "float",
    },
  },

  { "kaarmu/typst.vim", ft = { "typst" } },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "tinymist" })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "tinymist" })
    end,
  },

  {
    "chomosuke/typst-preview.nvim",
    cmd = { "TypstPreview", "TypstPreviewToggle", "TypstPreviewUpdate" },
    build = function() require("typst-preview").update() end,
    opts = {
      dependencies_bin = {
        tinymist = "tinymist",
      },
    },
  },
}
