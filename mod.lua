--- STEAMODDED HEADER
--- MOD_NAME: Cartomancer
--- MOD_ID: cartomancer
--- MOD_AUTHOR: [stupxd aka stupid]
--- MOD_DESCRIPTION: Quality of life features and optimizations
--- PRIORITY: 69
--- BADGE_COLOR: FFD700
--- DISPLAY_NAME: Cartomancer
--- VERSION: 4.17c

----------------------------------------------
------------MOD CODE -------------------------

if not SMODS.current_mod then
    return
end

assert(Cartomancer, [[

----------------------------------------
----------- READ -- THIS ---------------
----------------------------------------

Your Cartomancer folder seems to be nested in another folder!

Which means that path to the mod looks like Mods/Cartomancer/Cartomancer/mod.lua
instead of Mods/Cartomancer/mod.lua

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
----------------------------------------

]])

SMODS.current_mod.config_tab = Cartomancer.config_tab
SMODS.current_mod.save_mod_config = Cartomancer.save_config

----------------------------------------------
------------MOD CODE END----------------------
