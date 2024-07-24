Cartomancer = {}

Cartomancer.SETTINGS = {
    compact_deck = {
        enabled = true,
        visible_cards = 100,
    },

    deck_view = {
        stacked_cards = {
            enabled = true,
            -- first letter  - [top center bottom]
            -- second letter - [left middle right]
            amount_position = 'tm',
            -- Hex color code for x (before amount)
            x_color = 'ed7575',
            -- Opacity in %
            background_opacity = '60',    
        },
        drawn_cards = {
            hide = true,
            -- todo: maybe custom shader for drawn cards and ability to adjust opacity
        }
    },

    fixed_flames = {
        enabled = true,
        intensity_cap = 10,
    },

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
