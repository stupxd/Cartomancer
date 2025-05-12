if Cartomancer.use_smods() then return end

-- Credits: Steamodded
-- I was lazy and it's not like I'm going to code anything different from this anyways~
local function recurse(target, ref_table)
    if type(target) ~= 'table' then return end --this shouldn't happen unless there's a bad return value
    for k, v in pairs(target) do
        if not ref_table[k] or (type(v) ~= 'table') then
            ref_table[k] = v
        else
            recurse(v, ref_table[k])
        end
    end
end

local function load_localization()
    local default_table = Cartomancer.load_mod_file('localization/en-us.lua', 'localization')

    local loc_file = Cartomancer.path.."/localization/"..G.SETTINGS.language..".lua"

    local loc_table
    if Cartomancer.nfs.fileExists(loc_file) then
        loc_table = load(Cartomancer.nfs.read(loc_file), "Cartomancer - Localization")()

        -- Use english strings for missing localization
        for k, v in pairs(default_table) do
            if not loc_table[k] then
                loc_table[k] = v
            end
        end
    else
        loc_table = default_table
    end

    recurse(loc_table, G.localization)
end

load_localization()

local init_localization_ref = init_localization
function init_localization(...)
    load_localization()
    return init_localization_ref(...)
end

