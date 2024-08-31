
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
            s = s .. string.format(format, prefix, k, Cartomancer.dump(v, level + 1, prefix..'  '))
        end
        return s .. '}'
    else
        if type(o) == "string" then
            return string.format('"%s"', o)
        end

       return tostring(o)
    end
end

Cartomancer.save_config = function ()
    love.filesystem.write('config/cartomancer.jkr', "return " .. Cartomancer.dump(Cartomancer.SETTINGS))
end


Cartomancer.load_config = function ()
    if not love.filesystem.getInfo('config') then
        love.filesystem.createDirectory('config')
    end

    -- Steamodded config file location
    local config_file = Cartomancer.read_file('config/cartomancer.jkr')

    local latest_default_config = Cartomancer.load_mod_file('config.lua', 'default-config')

    if config_file then
        Cartomancer.SETTINGS = load(config_file)()
    else
        Cartomancer.SETTINGS = latest_default_config
        Cartomancer.save_config()
    end

    -- Remove unused settings
    local to_remove = {}

    for k, v in pairs(Cartomancer.SETTINGS) do
        if not latest_default_config[k] then
            Cartomancer.SETTINGS[k] = nil
        end
    end
end
