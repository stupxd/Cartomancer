
function Card:cart_to_string(args)
    local args = args or {}

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

    if not args.unique_count and Cartomancer.SETTINGS.deck_view_stack_modifiers then
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

----- Copied from incantation
G.FUNCS.disable_quantity_display = function(e)
    local preview_card = e.config.ref_table
    e.states.visible = preview_card.stacked_quantity > 1
end


function Card:create_quantity_display()
    if not Cartomancer.SETTINGS.deck_view_stack_enabled then
        return
    end

    local X_COLOR = HEX(Cartomancer.SETTINGS.deck_view_stack_x_color)

    if not self.children.stack_display and self.stacked_quantity > 1 then
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
                    colour = adjust_alpha(darken(G.C.BLACK, 0.2), Cartomancer.SETTINGS.deck_view_stack_background_opacity / 100),
                    shadow = false,
                    func = 'disable_quantity_display',
                    ref_table = self
                },
                nodes = {
                    {
                        n = G.UIT.T, -- node type
                        config = { text = 'x', scale = 0.35, colour = X_COLOR }
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
                align = (Cartomancer.SETTINGS.deck_view_stack_pos_vertical:sub(1, 1)) .. (Cartomancer.SETTINGS.deck_view_stack_pos_horizontal:sub(1, 1)),
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
