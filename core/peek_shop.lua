
G.FUNCS.carto_can_peek_shop = function (e)
    if not G.shop or G.CONTROLLER.locks.toggle_shop then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.GREY
        e.config.button = 'carto_peek_shop'
    end
end

G.FUNCS.carto_peek_shop = function (e)

    G.FUNCS.overlay_menu {
        definition = create_UIBox_peek_shop(),
        config = {offset = {x=0,y=10}}
    }

end

function create_UIBox_peek_shop()
    local tabs = create_tabs {
        snap_to_nav = true,
        tabs = Cartomancer.get_shop_tabs()
    }

    return create_UIBox_generic_options {
        contents = {tabs}
    }
end

local function add_card_price(card)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.43,
        blocking = false,
        blockable = false,
        func = (function()
          -- Copied from create_shop_card_ui in vanilla
            if card.opening then return true end
            local t1 = {
                n=G.UIT.ROOT, config = {minw = 0.6, align = 'tm', colour = darken(G.C.BLACK, 0.2), shadow = true, r = 0.05, padding = 0.05, minh = 1}, nodes={
                    {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.BLACK, 0.1), r = 0.1, minw = 1, minh = 0.55, emboss = 0.05, padding = 0.03}, nodes={
                      {n=G.UIT.O, config={object = DynaText({string = {{prefix = localize('$'), ref_table = card, ref_value = 'cost'}}, colours = {G.C.MONEY},shadow = true, silent = true, bump = true, pop_in = 0, scale = 0.5})}},
                    }}
                }}
              
            card.children.price = UIBox{
                definition = t1,
                config = {
                  align="tm",
                  offset = {x=0,y=1.5},
                  major = card,
                  bond = 'Weak',
                  parent = card
                }
            }
            card.children.price.alignment.offset.y = card.ability.set == 'Booster' and 0.5 or 0.38
            return true
        end)
    }))
end

local function copy_cards(from, to)
    for _, card in pairs(from.cards) do
        local _card = copy_card(card)
        _card:start_materialize()
        _card:add_to_deck()
        to:emplace(_card)

        add_card_price(_card)
    end
end

function Cartomancer.get_shop_tabs()
    local tabs = {}

    table.insert(tabs, {
        chosen = true,
        label = localize('carto_peek_shop_vanilla_label'),
        tab_definition_function = function()
          
          local shop_area = CardArea(
            G.hand.T.x+0,
            G.hand.T.y+G.ROOM.T.y + 9,
            G.GAME.shop.joker_max*1.02*G.CARD_W,
            1.05*G.CARD_H, 
            {card_limit = G.GAME.shop.joker_max, type = 'shop', highlight_limit = 0})
          copy_cards(G.shop_jokers, shop_area)

          local vouchers_area = CardArea(
            G.hand.T.x+0,
            G.hand.T.y+G.ROOM.T.y + 9,
            2.1*G.CARD_W,
            1.05*G.CARD_H, 
            {card_limit = 1, type = 'shop', highlight_limit = 0})
          copy_cards(G.shop_vouchers, vouchers_area)

          local boosters_area = CardArea(
            G.hand.T.x+0,
            G.hand.T.y+G.ROOM.T.y + 9,
            2.4*G.CARD_W,
            1.15*G.CARD_H, 
            {card_limit = 2, type = 'shop', highlight_limit = 1, card_w = 1.27*G.CARD_W})
          copy_cards(G.shop_booster, boosters_area)

          local tab = {
              n = G.UIT.ROOT,
              config = {
                  emboss = 0.05,
                  minh = 6,
                  r = 0.1,
                  minw = 10,
                  align = "cm",
                  padding = 0.2,
                  colour = G.C.BLACK
              },
              nodes = {
                    {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                      {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                        {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
                            {n=G.UIT.O, config={object = shop_area}},
                        }},
                      }},
                      {n=G.UIT.R, config={align = "cm", minh = 0.2}, nodes={}},
                      {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                        {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                          {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.BLACK, maxh = vouchers_area.T.h+0.4}, nodes={
                            {n=G.UIT.O, config={object = vouchers_area}},
                          }},
                        }},
                        {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                          {n=G.UIT.O, config={object = boosters_area}},
                        }},
                      }}
                  }
                },
              }
            }
            return tab
            end
    })

    return tabs
end

