Cartomancer = {}

Cartomancer.SETTINGS = {}

Cartomancer.find_self = function (target_filename)
	local mod_folders = love.filesystem.getDirectoryItems('Mods')
    for _, folder in pairs(mod_folders) do
        local path = string.format('Mods/%s', folder)
        local files = love.filesystem.getDirectoryItems(path)

        for _, filename in pairs(files) do
            if filename == target_filename then
                return path
            end
        end
    end
end

Cartomancer.path = Cartomancer.find_self('cartomancer.lua')

Cartomancer.read_file = function (file_path)
    local file_data = love.filesystem.getInfo(file_path)
    if file_data ~= nil then
        return love.filesystem.read(file_path)
    end
end

Cartomancer.load_mod_file = function (path, name)
    name = name or path

    local file, err = Cartomancer.read_file(Cartomancer.path..'/'..path)

    if not file then
        print("[Cartomancer] Failed to load file "..path.." ("..name.."): "..tostring(err))
        return
    end

    return load(file, "Cartomancer/"..name)()
end


return Cartomancer