require 'cartomancer.init'

Cartomancer.load_mod_file('internal/config.lua', 'config')
Cartomancer.load_mod_file('internal/atlas.lua', 'atlas')
Cartomancer.load_mod_file('internal/ui.lua', 'ui')

Cartomancer.load_mod_file('core/view-deck.lua', 'view-deck')
Cartomancer.load_mod_file('core/flames.lua', 'flames')
Cartomancer.load_mod_file('core/shaders.lua', 'shaders')
Cartomancer.load_mod_file('core/jokers.lua', 'jokers')

Cartomancer.load_config()

Cartomancer.INTERNAL_jokers_menu = false
