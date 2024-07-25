

function Cartomancer.fix_flames(value)
    if not Cartomancer.SETTINGS.custom_flames.enabled then
        return value
    end

    return math.max(
        math.min(value, Cartomancer.SETTINGS.custom_flames.max_intensity),
        Cartomancer.SETTINGS.custom_flames.min_intensity
    )
end

