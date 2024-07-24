

function Cartomancer.fix_flames(value)
    if not Cartomancer.SETTINGS.fixed_flames.enabled then
        return value
    end

    return math.max(
        math.min(value, Cartomancer.SETTINGS.fixed_flames.max_intensity),
        Cartomancer.SETTINGS.fixed_flames.min_intensity
    )
end

