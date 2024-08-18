

function Cartomancer.get_flames_intensity()
    local value
    if Cartomancer.SETTINGS.flames_relative_intensity then
        -- Scale intensity relative to the required score
        value = math.max(0., math.log(G.ARGS.score_intensity.earned_score/G.ARGS.score_intensity.required_score + 5, 5))
    else
        value = math.max(0., math.log(G.ARGS.score_intensity.earned_score, 5) - 2)
    end

    if Cartomancer.SETTINGS.flames_intensity_max >= Cartomancer._INTERNAL_max_flames_intensity then
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

local function intensity_for_big_scores(real_intensity)
    local power = 0.55

    real_intensity = math.max(0, real_intensity)

    return math.max(0, math.min(6, real_intensity) + math.max(1, math.log(real_intensity)) ^ power) - 1.
end

function Cartomancer.handle_flames_timer(timer, intensity)
    if not Cartomancer.SETTINGS.flames_slower_speed then
        return timer + G.real_dt*(1 + intensity*0.2)
    end

    return timer + G.real_dt*(1 + intensity_for_big_scores(intensity)*0.7)
end
