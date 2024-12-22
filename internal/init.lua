Cartomancer = {}

Cartomancer.SETTINGS = {}

Cartomancer.nfs = require "cartomancer.nfs"
local lovely = require "lovely"

Cartomancer.INTERNAL_debugging = not not love.filesystem.getInfo('cartomancer_debugging')

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

Cartomancer.load_mod_file = function (path, name, as_txt)
    name = name or path

    local file, err = Cartomancer.nfs.read(Cartomancer.path..'/'..path)

    assert(file, string.format([=[[Cartomancer] Failed to load mod file %s (%s).:
%s

Get latest release here: https://github.com/stupxd/Cartomancer/releases ]=], path, name, tostring(err)))

    return as_txt and file or load(file, string.format(" Cartomancer - %s ", name))()
end

Cartomancer.log = function (msg)
    if Cartomancer.INTERNAL_debugging then
        local msg = type(msg) == "string" and msg or Cartomancer.dump(msg)

        print("[Cartomancer] "..msg)
    end
end

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

Cartomancer.table_join_keys = function (tab_, separator)
    local separator = separator or "" 
    local inline
    for k, _ in pairs(tab_) do
        inline = (inline and inline..separator or "") .. k
    end

    return inline or "[empty]"
end

Cartomancer.do_nothing = function (...) end


return Cartomancer