return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_bt_ft = {
        lua = "lua-format",
        python = "black",
        rust = "rustfmt",
        sh = "shfmt",
        typescript = "prettier",
      },
    })
  end,
}
