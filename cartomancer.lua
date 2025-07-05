require 'cartomancer.init'

Cartomancer.path = assert(
    Cartomancer.find_self('cartomancer.lua'),
    "Failed to find mod folder. Make sure that `Cartomancer` folder has `cartomancer.lua` file!"
)

Cartomancer.load_mod_file('internal/config.lua', 'cartomancer.config')
Cartomancer.load_mod_file('internal/atlas.lua', 'cartomancer.atlas')
Cartomancer.load_mod_file('internal/ui.lua', 'cartomancer.ui')
Cartomancer.load_mod_file('internal/keybinds.lua', 'cartomancer.keybinds')

Cartomancer.load_mod_file('core/view-deck.lua', 'cartomancer.view-deck')
Cartomancer.load_mod_file('core/flames.lua', 'cartomancer.flames')
Cartomancer.load_mod_file('core/optimizations.lua', 'cartomancer.optimizations')
Cartomancer.load_mod_file('core/jokers.lua', 'cartomancer.jokers')
Cartomancer.load_mod_file('core/hand.lua', 'cartomancer.hand')
Cartomancer.load_mod_file('core/blinds_info.lua', 'cartomancer.blinds_info')
if SMODS then
    Cartomancer.load_mod_file('core/view-deck-steamodded.lua', 'cartomancer.view-deck-steamodded')
end

Cartomancer.load_config()

Cartomancer.INTERNAL_jokers_menu = false

-- TODO dedicated keybinds file? keybinds need to load after config
Cartomancer.register_keybind {
    name = 'hide_joker',
    func = function (controller)
        Cartomancer.hide_hovered_joker(controller)
    end
}

Cartomancer.register_keybind {
    name = 'toggle_tags',
    func = function (controller)
        Cartomancer.SETTINGS.hide_tags = not Cartomancer.SETTINGS.hide_tags
        Cartomancer.update_tags_visibility()
    end
}

Cartomancer.register_keybind {
    name = 'toggle_consumables',
    func = function (controller)
        Cartomancer.SETTINGS.hide_consumables = not Cartomancer.SETTINGS.hide_consumables
    end
}

Cartomancer.register_keybind {
    name = 'toggle_deck',
    func = function (controller)
        Cartomancer.SETTINGS.hide_deck = not Cartomancer.SETTINGS.hide_deck
    end
}

Cartomancer.register_keybind {
    name = 'toggle_jokers',
    func = function (controller)
        if not (G and G.jokers) then
            return
        end
        G.jokers.cart_hide_all = not G.jokers.cart_hide_all

        if G.jokers.cart_hide_all then
            Cartomancer.hide_all_jokers()
        else
            Cartomancer.show_all_jokers()
        end
        Cartomancer.align_G_jokers()
    end
}

Cartomancer.register_keybind {
    name = 'toggle_jokers_buttons',
    func = function (controller)
        Cartomancer.SETTINGS.jokers_controls_buttons = not Cartomancer.SETTINGS.jokers_controls_buttons
    end
}
