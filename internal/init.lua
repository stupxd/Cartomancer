Cartomancer = {}
Cartomancer.INTERNAL_debugging = false

Cartomancer.SETTINGS = {}

Cartomancer.nfs = require "cartomancer.nfs"
local lovely = require "lovely"

Cartomancer.use_smods = function ()
    return SMODS and not (MODDED_VERSION == "0.9.8-STEAMODDED")
end


Cartomancer.find_self = function (target_filename)
    local mods_path = lovely.mod_dir

	local mod_folders = Cartomancer.nfs.getDirectoryItems(mods_path)
    for _, folder in pairs(mod_folders) do
        local path = string.format('%s/%s', mods_path, folder)
        local files = Cartomancer.nfs.getDirectoryItems(path)

        for _, filename in pairs(files) do
            if filename == target_filename then
                return path
            end
        end
    end
end

Cartomancer.load_mod_file = function (path, name)
    name = name or path

    local file, err = Cartomancer.nfs.read(Cartomancer.path..'/'..path)

    assert(file, string.format([=[[Cartomancer] Failed to load mod file %s (%s).:
%s

Get latest release here: https://github.com/stupxd/Cartomancer/releases ]=], path, name, tostring(err)))

    return load(file, string.format(" Cartomancer - %s ", name))()
end

Cartomancer.log = function (msg)
    if Cartomancer.INTERNAL_debugging then
        local msg = type(msg) == "string" and msg or Cartomancer.dump(msg)

        print("[Cartomancer] "..msg)
    end
end


return Cartomancer