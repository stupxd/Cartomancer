local nan = math.huge/math.huge
local big_numbah = 1e308

function Cartomancer.get_flames_intensity()
    local value
    if Cartomancer.SETTINGS.flames_relative_intensity then
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

function Cartomancer.handle_flames_timer(timer, intensity)
    return timer + G.real_dt*(1 + intensity*0.2)
end
