-- EXPAND JOKERS CARDAREA


function Cartomancer.align_G_jokers()
    if not G or not G.jokers then
        return
    end
    -- Refresh controls
    if G.jokers.children.cartomancer_controls then
        G.jokers.children.cartomancer_controls:remove()
        G.jokers.children.cartomancer_controls = nil
    end
    G.jokers:align_cards()
    G.jokers:hard_set_cards()
end

local old_slider_value = 0
local slide_speedup = nil

function Cartomancer.expand_G_jokers()
    G.jokers.cart_zoom_slider = G.jokers.cart_zoom_slider or 0

    local self_T_w = math.max(4.9*G.CARD_W, 0.6*#G.jokers.cards * G.CARD_W)
    local self_T_x = G.jokers.T.x - (self_T_w- 4.9*G.CARD_W) * G.jokers.cart_zoom_slider / 100

    local self = G.jokers

    for k, card in ipairs(self.cards) do
        if card.states.drag.is then
            local sign = nil
            if card.T.x < -1 then
                sign = -1
            elseif card.T.x > G.TILE_W then
                sign = 1
            end
            
            if sign then
                slide_speedup = (slide_speedup or 1) + 0.01
                local shift = math.min(
                    self_T_w / 3,
                    4 * (slide_speedup ^ 1.7)
                )
                G.jokers.cart_zoom_slider = math.max(0, math.min(100, G.jokers.cart_zoom_slider + sign * shift / self_T_w))
                
                local slider = G.jokers.children.cartomancer_controls:get_UIE_by_ID('joker_slider')
                -- Only relevant part, copied from G.FUNCS.slider
                local rt = slider.config.ref_table
                slider.T.w = (G.jokers.cart_zoom_slider - rt.min)/(rt.max - rt.min)*rt.w
                slider.config.w = slider.T.w
            else
                slide_speedup = nil
            end
        else
            card.T.r = 0.1*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)
            local max_cards = math.max(#self.cards, self.config.temp_limit)
            card.T.x = self_T_x + (self_T_w-self.card_w)*((k-1)/math.max(max_cards-1, 1) - 0.5*(#self.cards-max_cards)/math.max(max_cards-1, 1)) + 0.5*(self.card_w - card.T.w)
            if #self.cards > 2 or (#self.cards > 1 and self == G.consumeables) or (#self.cards > 1 and self.config.spread) then
                card.T.x = self_T_x + (self_T_w-self.card_w)*((k-1)/(#self.cards-1)) + 0.5*(self.card_w - card.T.w)
            elseif #self.cards > 1 and self ~= G.consumeables then
                card.T.x = self_T_x + (self_T_w-self.card_w)*((k - 0.5)/(#self.cards)) + 0.5*(self.card_w - card.T.w)
            else
                card.T.x = self_T_x + self_T_w/2 - self.card_w/2 + 0.5*(self.card_w - card.T.w)
            end
            local highlight_height = G.HIGHLIGHT_H/2
            if not card.highlighted then highlight_height = 0 end
            card.T.y = self.T.y + self.T.h/2 - card.T.h/2 - highlight_height+ (G.SETTINGS.reduced_motion and 0 or 1)*0.03*math.sin(0.666*G.TIMERS.REAL+card.T.x)
            card.T.x = card.T.x + card.shadow_parrallax.x/30
        end
    end
    if not (old_slider_value == G.jokers.cart_zoom_slider) then
        old_slider_value = G.jokers.cart_zoom_slider
        return true
    end
end




--*--------------------------
--*------HIDE JOKERS
--*--------------------------
-- TODO : popup below joker to hide it

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

    
    if not (Cartomancer.SETTINGS.jokers_controls_buttons and #G.jokers.cards >= Cartomancer.SETTINGS.jokers_controls_show_after) then
        G.jokers.cart_jokers_expanded = false
        if G.jokers.children.cartomancer_controls then
            Cartomancer.align_G_jokers()
        end
        return
    end

    if not G.jokers.children.cartomancer_controls then
        local settings = Sprite(0,0,0.425,0.425,G.ASSET_ATLAS["cart_settings"], {x=0, y=0})
        settings.states.drag.can = false

        local joker_slider = nil
        if G.jokers.cart_jokers_expanded then
            joker_slider = create_slider({id = 'joker_slider', w = 6, h = 0.4,
                ref_table = G.jokers, ref_value = 'cart_zoom_slider', min = 0, max = 100,
                decimal_places = 1,
                hide_val = true,
                colour = G.C.CHIPS,
            })
            joker_slider.config.padding = 0
        end

        G.jokers.children.cartomancer_controls = UIBox {
            definition = {
                n = G.UIT.ROOT,
                config = { align = 'cm', padding = 0.07, colour = G.C.CLEAR, },
                nodes = {
                    {n=G.UIT.R, config={align = 'tm', padding = 0.07, no_fill = true}, nodes={

                        G.jokers.cart_hide_all and 
                        {n=G.UIT.C, config={align = "cm"}, nodes={
                            UIBox_button({id = 'show_all_jokers', button = 'cartomancer_show_all_jokers', label = {localize('carto_jokers_show')},
                                                                      minh = 0.45, minw = 1, col = false, scale = 0.3,
                                                                      colour = G.C.CHIPS, --func = function ()return Cartomancer.SETTINGS.jokers_visibility_controls end
                            })
                        }}
                        or
                        {n=G.UIT.C, config={align = "cm", }, nodes={
                            UIBox_button({id = 'hide_all_jokers', button = 'cartomancer_hide_all_jokers', label ={localize('carto_jokers_hide')},
                                                                      minh = 0.45, minw = 1, col = false, scale = 0.3,-- func = function ()return Cartomancer.SETTINGS.jokers_visibility_controls end
                            })
                        }},

                        {n=G.UIT.C, config={align = "cm"}, nodes={
                            UIBox_button({id = 'zoom_jokers', button = 'cartomancer_zoom_jokers', label = {localize('carto_jokers_zoom')},
                                                                      minh = 0.45, minw = 1, col = false, scale = 0.3,
                            })
                        }},
                        joker_slider,
                        
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

    -- This makes sure UIBox is drawn every frame 
    G.jokers.children.cartomancer_controls:draw()
end

G.FUNCS.cartomancer_hide_all_jokers = function(e)
    Cartomancer.hide_all_jokers()
    G.jokers.cart_hide_all = true
    Cartomancer.align_G_jokers()
end

G.FUNCS.cartomancer_show_all_jokers = function(e)
    Cartomancer.show_all_jokers()
    G.jokers.cart_hide_all = false
    Cartomancer.align_G_jokers()
end

G.FUNCS.cartomancer_zoom_jokers = function(e)
    G.jokers.cart_jokers_expanded = not G.jokers.cart_jokers_expanded
    Cartomancer.align_G_jokers()
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

function Cartomancer.handle_joker_added(card)
    

    if G.jokers.cart_hide_all then
        hide_card(card)
    end
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
        Cartomancer.log("no jokers")
        return
    end

    local total_jokers = #G.jokers.cards

    for i = 1, total_jokers do
        G.jokers.cards[i].states.visible = true
    end

end