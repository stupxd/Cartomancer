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

    -- Hidden cards in hand
    hidden_cards_hand = {
        enabled = true,
        hide_after_total = 100,
    },

    hidden_jokers = {
        automatically_hide = {
            enabled = false,
            rarities = {
                common = true,
                uncommon = true,
                rare = false,
            },
            all = false,
            editions = {
                negative = true,
            },
            -- When total reaches this number, matching jokers will be hidden TODO : make sure to show jokers once the number's back down :)
            hide_after_total = 100,
        }
    },

}
