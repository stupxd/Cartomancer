StackedCard = {}
StackedCard._metatable = {__index = StackedCard}

function StackedCard:new(o)
    return setmetatable(o or {}, self._metatable)
end

function StackedCard:init(card, quantity)
    self.card = card
    self.quantity = quantity or 1
end

function StackedCard:add(amount)
    self.quantity = self.quantity + amount
end

function Card:to_string()
    local result = (self.base and self.base.suit .. self.base.value) or ''

    if self.ability.name then
        -- enhancement?
        result = result .. self.ability.name
    end
    if self.edition then
        -- Should only have 1 edition, but they're implemented in a weird way.
        for edition, _ in pairs(self.edition) do
            result = result .. tostring(edition)
        end
    end
    if self.seal then
        -- self.seal == 'Gold'
        result = result .. self.seal
    end
    if self.ability.eternal then
        result = result .. "Eternal"
    end
    if self.ability.perishable then
        result = result .. "Perishable"
    end
    if self.ability.rental then
        result = result .. "Rental"
    end

    if self.debuff then
        result = result .. "Debuff"
    end
    
    if self.greyed then
        result = result .. "Greyed" -- greyed should be last!
    end

    return result
end

-- Util
function tablecopy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

-- Handle amount display

----- Copied from incantation
G.FUNCS.disable_quantity_display = function(e)
    local preview_card = e.config.ref_table
    e.states.visible = preview_card.quantity > 1
end

local X_COLOR = HEX('ed7575')

function StackedCard:create_quantity_display(copy)
    if not copy.children.stack_display and self.quantity > 1 then
        copy.children.stack_display = UIBox {
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
                    colour = adjust_alpha(darken(G.C.BLACK, 0.2), 0.4),
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
                            ref_table = self, ref_value = 'quantity',
                            scale = 0.35, colour = G.C.UI.TEXT_LIGHT
                        }
                    }
                }
            },
            config = {
                align = STACK_AMOUNT_POSITION .. 'm',
                bond = 'Strong',
                parent = copy
            },
            states = {
                collide = { can = false },
                drag = { can = true }
            }
        }
    end
end
