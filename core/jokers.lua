-- TODO : popup below joker to hide it

-- TODO : 

local JOKER_RARITY = {
    'common',
    'uncommon',
    'rare',
    'legendary',
}

function Cartomancer.add_visibility_controls()
    if not G.jokers then
        return
    end

    if not Cartomancer.SETTINGS.jokers_visibility_buttons then
        return
    end

    if not G.jokers.children.cartomancer_controls then
        local settings = Sprite(0,0,0.425,0.425,G.ASSET_ATLAS["cart_settings"], {x=0, y=0})
        settings.states.drag.can = false

        G.jokers.children.cartomancer_controls = UIBox {
            definition = {
                n = G.UIT.ROOT,
                func = function ()
                    return Cartomancer.SETTINGS.jokers_visibility_buttons
                end,
                config = { align = 'cm', padding = 0.07, colour = G.C.CLEAR, },
                nodes = {
                    {n=G.UIT.R, config={align = 'tm', padding = 0.07, no_fill = true}, nodes={
                        {n=G.UIT.C, config={align = "cm"}, nodes={
                            UIBox_button({id = 'hide_all_jokers', button = 'cartomancer_hide_all_jokers', label ={localize('carto_jokers_hide')},
                                                                      minh = 0.45, minw = 1, col = false, scale = 0.3,
                                                                      colour = G.C.CHIPS,
                                                                      })
                        }},
                        {n=G.UIT.C, config={align = "cm"}, nodes={
                            UIBox_button({id = 'show_all_jokers', button = 'cartomancer_show_all_jokers', label = {localize('carto_jokers_show')},
                                                                      minh = 0.45, minw = 1, col = false, scale = 0.3,
                                                                      })
                        }},
                        Cartomancer.INTERNAL_jokers_menu and {n=G.UIT.C, config={align = "cm"}, nodes={
                            {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, hover = true, colour = G.C.BLUE, button = 'cartomancer_joker_visibility_settings', shadow = true}, nodes={
                                {n=G.UIT.O, config={object = settings}},
                              }},
                        }} or nil,
                    }}
                }
            },
            config = {
                align = 't',
                
                bond = 'Strong',
                parent = G.jokers
            },
        }
    end

    G.jokers.children.cartomancer_controls:draw()
end

G.FUNCS.cartomancer_hide_all_jokers = function(e)
    Cartomancer.hide_all_jokers()
end

G.FUNCS.cartomancer_show_all_jokers = function(e)
    Cartomancer.show_all_jokers()
end

G.FUNCS.cartomancer_joker_visibility_settings = function(e)

    G.CARTO_JOKER_VISIBILITY = UIBox{
        definition = Cartomancer.jokers_visibility_standalone_menu(),
        config = {align="cm", offset = {x=0,y=10},major = G.ROOM_ATTACH, bond = 'Weak', instance_type = "POPUP"}
    }
    G.CARTO_JOKER_VISIBILITY.alignment.offset.y = 0
    G.ROOM.jiggle = G.ROOM.jiggle + 1
    G.CARTO_JOKER_VISIBILITY:align_to_major()
    -- TODO : REMOVE WHEN APPLY/CANCEL IS PRESSED
end

local function hide_card(card)
    card.states.visible = false
end

function Cartomancer.hide_hovered_joker(controller)
    if not G.jokers then
        return
    end

    local selected = controller.focused.target or controller.hovering.target
    
    if not selected or not selected:is(Card) then
        return
    end

    if selected.area ~= G.jokers then
        return
    end

    hide_card(selected)
end

-- Returns true if joker should be hidden due to settings 
function Cartomancer.should_hide_joker(card)
    
    
end

function Cartomancer.update_jokers_visibility()
    if not G.jokers then
        return
    end

    local settings = Cartomancer.SETTINGS.hide_jokers

    local total_jokers = #G.jokers.cards

    for i = 1, total_jokers do
        local joker = G.jokers.cards[i]
        if not settings.enabled then
            joker.states.visible = true
        else
            local hide = false

            if settings.all then
                hide = true

            elseif total_jokers >= settings.hide_after_total then
                hide = true

            elseif settings.rarities[JOKER_RARITY[joker.config.center.rarity]] then
                print("hiding joker with rarity " .. JOKER_RARITY[joker.config.center.rarity])
                hide = true
            
            elseif joker.edition and settings.editions[next(joker.edition)] then
                print("hiding joker with edition " .. next(joker.edition))
                hide = true
            end

            if hide then
                hide_card(joker)
            end
        end
    end
end


function Cartomancer.hide_all_jokers()
    if not G.jokers then
        print("no jokers")
        return
    end

    local total_jokers = #G.jokers.cards

    for i = 1, total_jokers do
        hide_card(G.jokers.cards[i])
    end
end

function Cartomancer.show_all_jokers()
    if not G.jokers then
        print("no jokers")
        return
    end

    local total_jokers = #G.jokers.cards

    for i = 1, total_jokers do
        G.jokers.cards[i].states.visible = true
    end

end