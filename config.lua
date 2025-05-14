
return {
    compact_deck_enabled = true,
    compact_deck_visible_cards = 100,
    hide_deck = false,

    deck_view_stack_enabled = true,
    deck_view_stack_modifiers = false,
    deck_view_stack_chips = true,
    -- [top center bottom]
    deck_view_stack_pos_vertical = 't',
    -- [left middle right]
    deck_view_stack_pos_horizontal = 'm',
    -- Hex color code for x (before amount)
    deck_view_stack_x_color = 'ed7575',
    -- Opacity in %
    deck_view_stack_background_opacity = '60',

    deck_view_hide_drawn_cards = false,
    -- todo: maybe custom shader for drawn cards to adjust opacity

    blinds_info = true,
    improved_hand_sorting = false,
    dynamic_hand_align = false,
    hide_tags = false,
    hide_consumables = false,
    
    flames_intensity_min = 0.5,
    flames_intensity_max = 10,
    flames_relative_intensity = false,
    flames_intensity_vanilla = false,
    flames_volume = 100,

    jokers_controls_buttons = true,
    jokers_controls_show_after = 13,

    keybinds = {
        hide_joker = {
            lalt = true,
            h = true,
        },
        toggle_tags = {['[none]'] = true},
        toggle_consumables = {['[none]'] = true},
        toggle_deck = {['[none]'] = true},
        toggle_jokers = {['[none]'] = true},
        toggle_jokers_buttons = {['[none]'] = true},
    },
}

--[[
--------- WIP / concepting

    -- Stack cards in hand?
    hand_stack_enabled = true,
    hand_stack_after_total = 100,

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
]]
