
Cartomancer.save_config = function ()
    Cartomancer.log "Saving cartomancer config..."
    Cartomancer.nfs.write('config/cartomancer.jkr', "return " .. Cartomancer.dump(Cartomancer.SETTINGS))
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

    -- Remove unused settings
    for k, v in pairs(Cartomancer.SETTINGS) do
        if latest_default_config[k] == nil then
            Cartomancer.log("Removing setting `"..k.. "` because it is not in default config")
            Cartomancer.SETTINGS[k] = nil
        end
    end

    for k, v in pairs(latest_default_config) do
        if Cartomancer.SETTINGS[k] == nil then
            Cartomancer.log("Adding setting `"..k.. "` because it is missing in latest config")
            Cartomancer.SETTINGS[k] = v
        end
    end

    Cartomancer.log "Successfully loaded config: "
    Cartomancer.log(Cartomancer.SETTINGS)
end

local cart_options_ref = G.FUNCS.options
G.FUNCS.options = function(e)
    if Cartomancer.INTERNAL_in_config then
        Cartomancer.INTERNAL_in_config = false
        Cartomancer.save_config()
    end
    return cart_options_ref(e)
end
