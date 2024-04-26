return {
    "rcarriga/nvim-notify",
    opts = {
        top_down = false,
        stages = "slide",
        timeout = 3000,
        max_height = function()
            return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
            return math.floor(vim.o.columns * 0.75)
        end,
        on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
            -- if notification contains word "ipairs" then do leader+u+n
            -- if vim.api.nvim_win_get_var(win, "message"):find("ipairs") then
            --    vim.api.nvim_feedkeys("<leader>un", "n", true)
            --   vim.api.nvim_win_close(win, true)
            -- end
        end,
    },
}
