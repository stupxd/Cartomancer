
-- ============================
-- Hide non-essential shaders
-- ============================
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

-- ============================
-- Hide card areas
-- ============================
local cardarea_draw = CardArea.draw
function CardArea:draw()
    if Cartomancer.SETTINGS.hide_consumables and self == G.consumeables then
        return
    elseif Cartomancer.SETTINGS.hide_deck and self == G.deck then
        return
    end

    return cardarea_draw(self)
end

-- ============================
-- Hide tags
-- ============================
function Cartomancer.update_tags_visibility()
    for _, tag in pairs(G.GAME.tags) do
        tag.HUD_tag.states.visible = not Cartomancer.SETTINGS.hide_tags
    end
end
