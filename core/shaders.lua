
local essential_shaders = {
    background = true,
    CRT = true,
    flame = true,
    flash = true,
    dissolve = true,
    vortex = true,
    voucher = true,
    booster = true,
    hologram = true,
    debuff = true,
    played = true,
    skew = true,
    splash = true,
}

local sprite_draw_shader = Sprite.draw_shader
function Sprite:draw_shader(_shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    if not Cartomancer.SETTINGS.draw_non_essential_shaders and _shader == 'negative' then
        _shader = 'dissolve'
        _send = nil
    end

    if Cartomancer.SETTINGS.draw_non_essential_shaders or essential_shaders[_shader] then
        return sprite_draw_shader(self, _shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    end
end
