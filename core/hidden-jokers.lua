-- TODO : popup below joker to hide it

-- TODO : 

local JOKER_RARITY = {
    'common',
    'uncommon',
    'rare',
    'legendary',
}

function Cartomancer.update_jokers_visibility()
    local settings = Cartomancer.SETTINGS.hide_jokers

    local total_jokers = #G.jokers.cards

    for i = 1, total_jokers do
        local joker = G.jokers.cards[i]
        if not settings.enabled then
            joker.states.visible = true
        else
            local hide = false

            if settings.all then
                print("hiding all jokers")
                hide = true

            elseif total_jokers >= settings.hide_after_total then
                print("hiding all jokers because theres A LOT OF THEM")
                hide = true

            elseif settings.rarities[JOKER_RARITY[joker.config.center.rarity]] then
                print("hiding joker with rarity " .. JOKER_RARITY[joker.config.center.rarity])
                hide = true
            
            elseif joker.edition and settings.editions[next(joker.edition)] then
                print("hiding joker with edition " .. next(joker.edition))
                hide = true
            end

            if hide then
                joker.states.visible = false
            end
        end
    end
end

function Cartomancer.hide_joker(joker)
    joker.states.visible = false
end


function Cartomancer.show_all_jokers()
    for i = 1, #G.jokers.cards do
        G.jokers.cards[i].states.visible = true
    end

end