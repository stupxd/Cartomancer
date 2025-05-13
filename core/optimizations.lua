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
