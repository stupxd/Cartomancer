
Cartomancer.save_config = function ()
    Cartomancer.log "Saving cartomancer config..."
    love.filesystem.write('config/cartomancer.jkr', "return " .. Cartomancer.dump(Cartomancer.SETTINGS))
end

-- Logic for keeping config tables up to date
local function remove_unused_keys(from_table, template)
    for k, v in pairs(from_table) do
        if template[k] == nil then
            Cartomancer.log("Removing setting `"..k.. "` because it is not in default config")
            from_table[k] = nil
        end
    end
end

local function add_missing_keys(to_table, template)
    for k, v in pairs(template) do
        if to_table[k] == nil then
            Cartomancer.log("Adding setting `"..k.. "` because it is missing in latest config")
            to_table[k] = v
        end
    end
end

Cartomancer.load_config = function ()
    Cartomancer.log "Starting to load config"
    if not love.filesystem.getInfo('config') then
        Cartomancer.log("Creating config folder...")
        love.filesystem.createDirectory('config')
    end

    -- Steamodded config file location
    local config_file = love.filesystem.read('config/cartomancer.jkr')
    local latest_default_config = Cartomancer.load_mod_file('config.lua', 'default-config')

    if config_file then
        Cartomancer.log "Reading config file: "
        Cartomancer.log(config_file)
        Cartomancer.SETTINGS = STR_UNPACK(config_file) -- Use STR_UNPACK to avoid code injectons via config files
    else
        Cartomancer.log "Creating default settings"
        Cartomancer.SETTINGS = latest_default_config
        Cartomancer.save_config()
    end

    remove_unused_keys(Cartomancer.SETTINGS, latest_default_config)
    add_missing_keys(Cartomancer.SETTINGS, latest_default_config)

    remove_unused_keys(Cartomancer.SETTINGS.keybinds, latest_default_config.keybinds)
    add_missing_keys(Cartomancer.SETTINGS.keybinds, latest_default_config.keybinds)

    Cartomancer.log "Successfully loaded config: "
    Cartomancer.log(Cartomancer.SETTINGS)
end

local cart_options_ref = G.FUNCS.options
G.FUNCS.options = function(e)
    if Cartomancer.INTERNAL_in_config then
        Cartomancer.INTERNAL_in_config = false
        if Cartomancer._recording_keybind then
            Cartomancer.log "Quit config, stopping to record keybind"
            Cartomancer._recording_keybind = nil
        end
        Cartomancer.save_config()
    end
    return cart_options_ref(e)
end

local settings_tab_ref = G.UIDEF.settings_tab
function G.UIDEF.settings_tab(tab)
    if Cartomancer._recording_keybind then
        Cartomancer.log "Changed settings tab, stopping to record keybind"
        Cartomancer._recording_keybind = nil
    end
    -- Maybe I should port cartomancer settings to use this function as well? but it would still not work with other mods that add custom tabs :sob:
    return settings_tab_ref(tab)
end