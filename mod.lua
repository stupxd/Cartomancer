
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
