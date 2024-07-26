--- STEAMODDED HEADER
--- MOD_NAME: Cartomancer
--- MOD_ID: cartomancer
--- MOD_AUTHOR: [stupxd aka stupid]
--- MOD_DESCRIPTION: Quality of life features and optimizations
--- PRIORITY: 69
--- BADGE_COLOR: FFD700
--- DISPLAY_NAME: Cartomancer
--- VERSION: 3.0

----------------------------------------------
------------MOD CODE -------------------------

Cartomancer.SETTINGS = SMODS.current_mod.config

SMODS.current_mod.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, align = "t", padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6}, nodes = {
        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = Cartomancer.SETTINGS, ref_value = "compact_deck_enabled" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = localize('carto_compact_deck_enabled'), scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = Cartomancer.SETTINGS, ref_value = "deck_view_stack_enabled" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = localize('carto_deck_view_stack_enabled'), scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = Cartomancer.SETTINGS, ref_value = "deck_view_hide_drawn_cards" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = localize('carto_deck_view_hide_drawn_cards'), scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = Cartomancer.SETTINGS, ref_value = "draw_non_essential_shaders" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = localize('carto_draw_non_essential_shaders'), scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = Cartomancer.SETTINGS, ref_value = "flames_intensity_enabled" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = localize('carto_flames_intensity_enabled'), scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        -- {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
        --     {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
        --         create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = Cartomancer.SETTINGS, ref_value = "instant_deck_reshuffle" },
        --     }},
        --     {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
        --         { n = G.UIT.T, config = { text = localize('carto_instant_deck_reshuffle'), scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
        --     }},
        -- }},

    }}
end

SMODS.Atlas{
    key = "modicon",
    path = "modicon.png",
    px = 32,
    py = 32
}

----------------------------------------------
------------MOD CODE END----------------------
