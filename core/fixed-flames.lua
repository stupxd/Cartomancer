

function Cartomancer.fix_flames(value)
    if not Cartomancer.SETTINGS.fixed_flames.enabled then
        return value
    end

    return math.min(value, Cartomancer.SETTINGS.fixed_flames.intensity_cap)
end

