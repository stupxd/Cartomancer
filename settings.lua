Cartomancer = {}

Cartomancer.SETTINGS = {
    compact_deck = {
        enabled = true,
        visible_cards = 100,
    },

    deck_view = {
        stacked_cards = {
            enabled = true,
            -- [top center bottom]
            pos_vertical = 't',
            -- [left middle right]
            pos_horizontal = 'm',
            -- Hex color code for x (before amount)
            x_color = 'ed7575',
            -- Opacity in %
            background_opacity = '60',
        },

        hide_drawn_cards = true,
        -- todo: maybe custom shader for drawn cards to adjust opacity
    },

    draw_shaders = true,

    custom_flames = {
        enabled = true,
        min_intensity = 0.5,
        max_intensity = 8,
    },


    --------- WIP / concepting

    -- stacked cards in hand? 

    -- Hidden cards in hand
    hide_cards = {
        enabled = true,
        hide_after_total = 100,
    },

    -- stacked jokers?
    hide_jokers = {
        enabled = true,
        rarities = {
            common = true,
            uncommon = true,
            rare = false,
        },
        all = true,
        editions = {
            negative = true,
        },
        -- When total reaches this number, matching jokers will be hidden TODO : make sure to show jokers once the number's back down :)
        hide_after_total = 100,
    },

}
