
function Card:to_string()
    return string.format(
        "%s%s%s%s%s%s%s%s%s%s",
        self.base and self.base.suit or '',
        self.base and self.base.value or '',
        self.ability and self.ability.name or '',
        self.edition and next(self.edition) or '',
        self.seal or '',
        self.eternal and 'Eternal' or '',
        self.perishable and 'Perishable' or '',
        self.rental and 'Rental' or '',
        self.debuff and 'Debuff' or '',
        self.greyed and 'Greyed' or ''
    )
end

-- Util
function tablecopy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

function format_ui_value(value)
    if type(value) ~= "number" then
        return tostring(value)
    end

    return number_format(value, 1000000)
  end

-- Handle amount display

----- Copied from incantation
G.FUNCS.disable_quantity_display = function(e)
    local preview_card = e.config.ref_table
    e.states.visible = preview_card.stacked_quantity > 1
end

local X_COLOR = HEX(Cartomancer.SETTINGS.stack_x_color)

function Card:create_quantity_display()
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
                    colour = adjust_alpha(darken(G.C.BLACK, 0.2), Cartomancer.SETTINGS.stack_background_opacity / 100),
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
                align = Cartomancer.SETTINGS.stack_amount_position .. 'm',
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
