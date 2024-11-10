require 'cartomancer.init'

Cartomancer.path = assert(
    Cartomancer.find_self('cartomancer.lua'),
    "Failed to find mod folder. Make sure that `Cartomancer` folder has `cartomancer.lua` file!"
)

Cartomancer.load_mod_file('internal/config.lua', 'internal.config')
Cartomancer.load_mod_file('internal/atlas.lua', 'internal.atlas')
Cartomancer.load_mod_file('internal/ui.lua', 'internal.ui')

Cartomancer.load_mod_file('core/view-deck.lua', 'core.view-deck')
Cartomancer.load_mod_file('core/flames.lua', 'core.flames')
Cartomancer.load_mod_file('core/optimizations.lua', 'core.optimizations')
Cartomancer.load_mod_file('core/jokers.lua', 'core.jokers')
Cartomancer.load_mod_file('core/hand.lua', 'core.hand')

Cartomancer.load_config()

Cartomancer.INTERNAL_jokers_menu = false


