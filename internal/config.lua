
Cartomancer.dump = function (o, level, prefix)
    level = level or 1
    prefix = prefix or '  '
    if type(o) == 'table' and level <= 5 then
        local s = '{ \n'
        for k, v in pairs(o) do
            local format
            if type(k) == 'number' then
                format = '%s[%d] = %s,\n'
            else
                format = '%s["%s"] = %s,\n'
            end
            s = s .. string.format(
                    format,
                    prefix,
                    k,
                    -- Compact parent & draw_major to avoid recursion and huge dumps.
                    (k == 'parent' or k == 'draw_major') and string.format("'%s'", tostring(v)) or Cartomancer.dump(v, level + 1, prefix..'  ')
            )
        end
        return s..prefix:sub(3)..'}'
    else
        if type(o) == "string" then
            return string.format('"%s"', o)
        end

        if type(o) == "function" or type(o) == "table" then
            return string.format("'%s'", tostring(o))
        end

        return tostring(o)
    end
end

Cartomancer.save_config = function ()
    Cartomancer.log "Saving cartomancer config..."
    love.filesystem.write('config/cartomancer.jkr', "return " .. Cartomancer.dump(Cartomancer.SETTINGS))
end


Cartomancer.load_config = function ()
    Cartomancer.log "Starting to load config"
    if not love.filesystem.getInfo('config') then
        Cartomancer.log("Creating config folder...")
        love.filesystem.createDirectory('config')
    end

    -- Steamodded config file location
    local config_file = Cartomancer.read_file('config/cartomancer.jkr')

    local latest_default_config = Cartomancer.load_mod_file('config.lua', 'default-config')

    if config_file then
        Cartomancer.log "Reading config file: "
        Cartomancer.log(config_file)
        Cartomancer.SETTINGS = load(config_file)()
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
end

local cart_options_ref = G.FUNCS.options
G.FUNCS.options = function(e)
    if Cartomancer.INTERNAL_in_config then
        Cartomancer.INTERNAL_in_config = false
        Cartomancer.save_config()
    end
    return cart_options_ref(e)
end
