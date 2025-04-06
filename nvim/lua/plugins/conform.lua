return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                html = { "prettier" },
                json = { "prettier" },
                lua = { "stylua" },
                python = { "black" },
                sh = { "shfmt" },
                yaml = { "prettier" },
            },
        },
    },
}
