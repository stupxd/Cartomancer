
function Card:cart_to_string(args)
    local args = args or {}

    -- With deck stacking disabled, sort_id should make all cards unstacked in deck view.
    if args.deck_view and not Cartomancer.SETTINGS.deck_view_stack_enabled then
        return tostring(self.sort_id)
    end

    local suit = self.base and (
        -- if has base, check for stone / no_suit
        -- only use NoSuit for unique_count, deck view displays every stone card in respective suit area
        (self.ability.effect == 'Stone Card' or self.config.center.no_suit) and args.unique_count and 'NoSuit' or self.base.suit
        -- otherwise empty string
    ) or ''

    local rank = self.base and (
            -- if has base, check for stone / no_rank
            (self.ability.effect == 'Stone Card' or self.config.center.no_rank) and 'NoRank' or self.base.value
            -- otherwise empty string
    ) or ''

    if not Cartomancer.SETTINGS.deck_view_stack_chips then
        rank = rank .. tostring(self:get_chip_bonus())
    end

    if args.deck_view and Cartomancer.SETTINGS.deck_view_stack_modifiers then
        return string.format(
            "%s%s",
            suit,
            rank,
            self.greyed and 'Greyed' or ''
        )
    end

    return string.format(
        "%s%s%s%s%s%s%s%s%s%s",
        suit,
        rank,
        self.ability and self.ability.name or '',
        self.edition and (self.edition.type or next(self.edition)) or '',
        self.seal or '',
        -- TODO : steamodded stickers compatibility
        self.eternal and 'Eternal' or '',
        self.perishable and 'Perishable' or '',
        self.rental and 'Rental' or '',
        self.debuff and 'Debuff' or '',

        self.greyed and 'Greyed' or ''
    )
end

-- Util
function Cartomancer.tablecopy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

function Cartomancer.table_size(t)
    local size = 0
    for _, _ in pairs(t) do
        size = size + 1
    end

    return size
end

-- Compatibility with old settings ;-; 
-- should have made this properly at the very beginning :(
local legacy_vertical = {
    top = 1,
    center = 2,
    bottom = 3,
}
local legacy_horizontal = {
    left = 1,
    middle = 2,
    right = 3,
}
local function fix_settings_values()
    if type(Cartomancer.SETTINGS.deck_view_stack_pos_vertical) == "string" then
        Cartomancer.SETTINGS.deck_view_stack_pos_vertical = legacy_vertical[Cartomancer.SETTINGS.deck_view_stack_pos_vertical]
    end
    if type(Cartomancer.SETTINGS.deck_view_stack_pos_vertical) ~= "number" then
        Cartomancer.SETTINGS.deck_view_stack_pos_vertical = 1
    end
    
    if type(Cartomancer.SETTINGS.deck_view_stack_pos_horizontal) == "string" then
        Cartomancer.SETTINGS.deck_view_stack_pos_horizontal = legacy_horizontal[Cartomancer.SETTINGS.deck_view_stack_pos_horizontal]
    end
    if type(Cartomancer.SETTINGS.deck_view_stack_pos_horizontal) ~= "number" then
        Cartomancer.SETTINGS.deck_view_stack_pos_horizontal = 2
    end

end

local vertical_options = {
    "t", -- top
    "c", -- center
    "b"  -- bottom
}
local horizontal_options = {
    "l", -- left
    "m", -- middle
    "r"  -- right
}

local function get_align_from_settings()
    fix_settings_values()

    local vertical = vertical_options[Cartomancer.SETTINGS.deck_view_stack_pos_vertical]
    local horizontal = horizontal_options[Cartomancer.SETTINGS.deck_view_stack_pos_horizontal]

    return vertical .. horizontal
end

function Cartomancer.add_unique_count()
    local unique_count = 0

    local all_keys = {}

    for i = 1, #G.playing_cards do
        local key = G.playing_cards[i]:cart_to_string{ unique_count=true }
        if not all_keys[key] then
            all_keys[key] = true
            unique_count = unique_count + 1
        end
    end

    -- for _, cards in pairs(SUITS_SORTED) do
    --     unique_count = unique_count + #cards
    -- end
    
    return {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.T, config={text = localize('carto_deck_view_unique_cards')..' '..tostring(unique_count), colour = G.C.WHITE, scale = 0.3}},
      }}
end

-- Handle amount display


local function copy_values(to, from)
    for k, v in pairs(from) do
        to[k] = v
    end
end

local old_opacity
local background_color = {}

local old_color
local x_color = {}

----- Copied from incantation
G.FUNCS.cartomancer_deck_view_quantity = function(e)
    local preview_card = e.config.ref_table
    e.states.visible = preview_card.stacked_quantity > 1

    if Cartomancer.INTERNAL_in_config then
        if old_opacity ~= Cartomancer.SETTINGS.deck_view_stack_background_opacity then
            old_opacity = Cartomancer.SETTINGS.deck_view_stack_background_opacity
            copy_values(background_color, adjust_alpha(darken(G.C.BLACK, 0.2), Cartomancer.SETTINGS.deck_view_stack_background_opacity / 100))
        end
        if old_color ~= Cartomancer.SETTINGS.deck_view_stack_x_color then
            old_color = Cartomancer.SETTINGS.deck_view_stack_x_color
            copy_values(x_color, Cartomancer.hex_to_color(Cartomancer.SETTINGS.deck_view_stack_x_color))
        end
    end
end

function Card:create_quantity_display()
    if not Cartomancer.SETTINGS.deck_view_stack_enabled then
        return
    end

    if not self.children.stack_display and self.stacked_quantity > 1 then
        copy_values(background_color, adjust_alpha(darken(G.C.BLACK, 0.2), Cartomancer.SETTINGS.deck_view_stack_background_opacity / 100))
        copy_values(x_color, Cartomancer.hex_to_color(Cartomancer.SETTINGS.deck_view_stack_x_color))
        self.children.stack_display = UIBox {
            definition = {
                n = G.UIT.ROOT,
                config = {
                    minh = 0.5,
                    maxh = 1.2,
                    minw = 0.43,
                    maxw = 2,
                    r = 0.001,
                    padding = 0.1,
                    align = 'cm',
                    colour = background_color,
                    shadow = false,
                    func = 'cartomancer_deck_view_quantity',
                    ref_table = self
                },
                nodes = {
                    {
                        n = G.UIT.T, -- node type
                        config = { text = 'x', scale = 0.35, colour = x_color }
                        , padding = -1
                    },
                    {
                        n = G.UIT.T, -- node type
                        config = {
                            ref_table = self, ref_value = 'stacked_quantity',
                            scale = 0.35, colour = G.C.UI.TEXT_LIGHT
                        }
                    }
                }
            },
            config = {
                align = get_align_from_settings(),
                bond = 'Strong',
                parent = self
            },
            states = {
                collide = { can = false },
                drag = { can = true }
            }
        }
    end
end

function Cartomancer.get_view_deck_preview_area()
    if not Cartomancer.view_deck_preview_area then
        local preview = CardArea(
        G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
        G.CARD_W,
        G.CARD_H,
        {card_limit = 1, type = 'title', view_deck = true, highlight_limit = 0, card_w = G.CARD_W*0.7, draw_layers = {'card'}})
        local card = Card(preview.T.x + preview.T.w/2, preview.T.y, G.CARD_W*0.7, G.CARD_H*0.7, G.P_CARDS.S_A, G.P_CENTERS.m_gold)

        card.stacked_quantity = 69
        card.no_ui = true
        card:create_quantity_display()

        card:hard_set_T()
        preview:emplace(card)

        Cartomancer.view_deck_preview_area = preview
    end

    return Cartomancer.view_deck_preview_area
end

Cartomancer.update_view_deck_preview = function ()
    if not Cartomancer.view_deck_preview_area then
        return
    end
    for _, card in pairs(Cartomancer.view_deck_preview_area.cards) do
        if card.children.stack_display then
            card.children.stack_display:remove()
            card.children.stack_display = nil
        end
        card:create_quantity_display()
    end
end