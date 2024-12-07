require 'cartomancer.init'

Cartomancer.path = assert(
    Cartomancer.find_self('cartomancer.lua'),
    "Failed to find mod folder. Make sure that `Cartomancer` folder has `cartomancer.lua` file!"
)

Cartomancer.load_mod_file('internal/config.lua', 'internal.config')
Cartomancer.load_mod_file('internal/atlas.lua', 'internal.atlas')
Cartomancer.load_mod_file('internal/ui.lua', 'internal.ui')
Cartomancer.load_mod_file('internal/keybinds.lua', 'internal.keybinds')

Cartomancer.load_mod_file('core/view-deck.lua', 'core.view-deck')
Cartomancer.load_mod_file('core/flames.lua', 'core.flames')
Cartomancer.load_mod_file('core/optimizations.lua', 'core.optimizations')
Cartomancer.load_mod_file('core/jokers.lua', 'core.jokers')
Cartomancer.load_mod_file('core/hand.lua', 'core.hand')

Cartomancer.load_config()

Cartomancer.INTERNAL_jokers_menu = false

-- TODO dedicated keybinds file? keybinds need to load after config
Cartomancer.register_keybind {
    name = 'hide_joker',
    func = function (controller)
        Cartomancer.log("hiding joker")
        Cartomancer.hide_hovered_joker(controller)
    end
}

Cartomancer.register_keybind {
    name = 'toggle_tags_visibility',
    func = function (controller)
        Cartomancer.SETTINGS.hide_tags = not Cartomancer.SETTINGS.hide_tags
        Cartomancer.update_tags_visibility()
    end
}

--[=[
    Cartomancer.SETTINGS.keybinds.ouroboros = {
        lctrl = true,
        o = true
    }
Cartomancer.register_keybind {
    name = 'ouroboros',
    func = function (controller)
        Cartomancer.record_keybind {
            name = 'ouroboros',
            callback = function (keys)
                Cartomancer.log("Recorded keybind: ")
                Cartomancer.log(keys)
                Cartomancer.SETTINGS.keybinds.ouroboros = keys
            end,
            press_callback = function (keys)
                local inline
                for k, _ in pairs(keys) do
                    inline = (inline and inline..", " or "") .. k
                end

                Cartomancer.log("Pressed keys: "..inline)
            end
        }
    end
}]=]--