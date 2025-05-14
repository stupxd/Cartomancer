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

Cartomancer.empty_table = {}

Cartomancer.remove_empty_tables = function (list)
    local result = {}
    for _, v in ipairs(list) do
        if v ~= Cartomancer.empty_table then
            result[#result+1] = v
        end
    end

    return result
end

Cartomancer.do_nothing = function (...) end

Cartomancer.align_object = function (o)
    o:align_to_major()
    local x = (o.T.x)
    local y = (o.T.y)
    local w = (o.T.w)
    local h = (o.T.h)
    Moveable.hard_set_T(o,x, y, w, h)
    o:hard_set_T(x, y, w, h)
end

function Cartomancer.basen(n,b)
    n = math.floor(n)
    if not b or b == 10 then return tostring(n) end
    local digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local t = {}
    local sign = ""
    if n < 0 then
        sign = "-"
    n = -n
    end
    repeat
        local d = (n % b) + 1
        n = math.floor(n / b)
        table.insert(t, 1, digits:sub(d,d))
    until n == 0
    return sign .. table.concat(t,"")
end

local function is_valid_hex(letter)
    local byte_val = string.byte(string.upper(letter))
    -- Between A-F or 0-9
    return byte_val >= 65 and byte_val <= 70 or byte_val >= 48 and byte_val <= 57
end

function Cartomancer.hex_to_color(hex)
    -- Make sure string length is always 8
    while #hex < 8 do
        hex = hex.."F"
    end
    hex = string.sub(hex, 1, 8)
    -- Make sure string only contains 
    for i = 1, #hex do
        if not is_valid_hex(hex:sub(i,i)) then
            -- insane way to replace char at given index 
            hex = ("%sF%s"):format(hex:sub(1,i-1), hex:sub(i+1))
        end
    end
    local _,_,r,g,b,a = hex:find('(%x%x)(%x%x)(%x%x)(%x%x)')
    local color = {tonumber(r,16)/255,tonumber(g,16)/255,tonumber(b,16)/255,tonumber(a,16)/255 or 255}

    return color
end

function Cartomancer.color_to_hex(color)
    local hex = ""
    for i = 1, 3 do
        local base_16 = Cartomancer.basen(color[i] * 255, 16)
        -- Numbers below 16 need 0 in front
        if #base_16 == 1 then
            base_16 = "0"..base_16
        end
        -- How would we ever get numbers above 255 :3c
        base_16 = base_16:sub(#base_16 - 1, #base_16)

        hex = hex .. base_16
    end

    return hex
end

return Cartomancer