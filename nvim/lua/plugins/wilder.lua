return {
    'gelguy/wilder.nvim',
    config = function()
        require('wilder').setup {
            modes = {
                '/',
                '?',
                ':',
                '!',
            },
            history = false,
            quick_ref_commands = {
                'Ag',
                'Rg',
                'Rg!',
                'Rg?',
                'Files',
                'Buffers',
                'BLines',
                'Marks',
                'Colors',
                'GFiles'
            }
        }
    end
}