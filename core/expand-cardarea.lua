
local function find_hovered_card_index(area)
    for index, card in ipairs(area.cards) do
        if card.states.hover.is or card.states.drag.is then 
            return index
        end
    end
end

-- fix flickering when selecting cards it's pretty annoying to select cards in hand!!!
function Cartomancer.expand_cardarea(area)
    if true or area ~= G.hand and area ~= G.jokers and area ~= G.consumeables then
        return false
    end
    -- config amount, min value should be 5
    if not area or #area.cards < 10 then
        return false
    end

    local hovered_card_index = find_hovered_card_index(area)
    if not hovered_card_index then
        return false
    end

    local area_T_w = area.T.w
    local area_T_x = area.T.x

    local to_expand = 3
    local from_one_side = (to_expand - 1) / 2
    local total_cards = #area.cards

    local hovered_x = area_T_x + (area_T_w-area.card_w)*((hovered_card_index-1)/(#area.cards-1)) + 0.5*(area.card_w - area.cards[hovered_card_index].T.w)

    local hover_expand_w = 0.3 * area_T_w

    for k, card in ipairs(area.cards) do
        if card.states.drag.is then
        else
            -- G.jokers logic
            card.T.r = 0.1*(-#area.cards/2 - 0.5 + k)/(#area.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)
            card.T.x = area_T_x + (area_T_w-area.card_w)*((k-1)/(#area.cards-1)) + 0.5*(area.card_w - card.T.w)

            if k < hovered_card_index - from_one_side or k > hovered_card_index + from_one_side then
                if k > hovered_card_index then
                    card.T.x = card.T.x + (total_cards - k - 1)/(total_cards - hovered_card_index - 1) * area.card_w * 0.4
                    -- somehow try to make edges dynamically expand as you get closer to 
                    if (total_cards - hovered_card_index) / total_cards < 0.2 then
                        card.T.x = card.T.x + area.card_w * 0.2
                    end
                else
                    card.T.x = card.T.x - (k - 1)/(hovered_card_index - 1) * area.card_w * 0.4
                    if (hovered_card_index) / total_cards < 0.2 then
                        card.T.x = card.T.x - area.card_w * 0.2
                    end
                end
                --card.T.x = card.T.x - area.card_w * 0.4
            
            elseif k == hovered_card_index then
            else
                card.T.x = card.T.x - (hovered_card_index - k)/from_one_side * area.card_w *0.25
            end

            local highlight_height = G.HIGHLIGHT_H/2
            if not card.highlighted then highlight_height = 0 end
            card.T.y = area.T.y + area.T.h/2 - card.T.h/2 - highlight_height+ (G.SETTINGS.reduced_motion and 0 or 1)*0.03*math.sin(0.666*G.TIMERS.REAL+card.T.x)
            card.T.x = card.T.x + card.shadow_parrallax.x/30
        end
    end

    return true
end