local nan = math.huge/math.huge
local big_numbah = 1e308

function Cartomancer.get_flames_intensity(preview)
    local value
    if preview then
        value = Cartomancer._INTERNAL_gasoline
    elseif Cartomancer.SETTINGS.flames_relative_intensity then
        -- Scale intensity relative to the required score
        value = math.max(0., math.log(G.ARGS.score_intensity.earned_score/G.ARGS.score_intensity.required_score + 5, 5))
    else
        value = math.max(0., math.log(G.ARGS.score_intensity.earned_score, 5) - 2)
    end

    if value == math.huge or not value or value == nan then
        value = big_numbah
    end

    if Cartomancer.SETTINGS.flames_intensity_vanilla then
        return value
    end

    return math.max(
        math.min(value, Cartomancer.SETTINGS.flames_intensity_max),
        Cartomancer.SETTINGS.flames_intensity_min
    )
end

function Cartomancer.handle_flames_volume(value)
    return Cartomancer.SETTINGS.flames_volume/100. * value
end

function Cartomancer.init_setting_flames()
    G.ARGS.flame_handler.chips_cart = G.ARGS.flame_handler.chips_cart or {
        id = 'flame_chips_cart',
        arg_tab = 'chip_flames_cart',
        colour = G.C.UI_CHIPS,
        accent = G.C.UI_CHIPLICK or SMODS and SMODS.Scoring_Parameters and SMODS.Scoring_Parameters.chips and SMODS.Scoring_Parameters.chips.lick or {1, 1, 1, 1}
    }

    G.ARGS.flame_handler.mult_cart = G.ARGS.flame_handler.mult_cart or {
        id = 'flame_mult_cart',
        arg_tab = 'mult_flames_cart',
        colour = G.C.UI_MULT,
        accent = G.C.UI_MULTLICK or SMODS and SMODS.Scoring_Parameters and SMODS.Scoring_Parameters.mult and SMODS.Scoring_Parameters.mult.lick or {1, 1, 1, 1}
    }
end
