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

local function add_defaults(default_table, target_table)
    if type(default_table) ~= 'table' then return end
    for k, v in pairs(default_table) do
        if target_table[k] then
            if type(v) == "table" then
                add_defaults(v, target_table[k])
            end
        else
            target_table[k] = v
        end
    end
end

local function load_localization()
    local default_table = Cartomancer.load_mod_file('localization/en-us.lua', 'cartomancer.localization')

    local loc_file = Cartomancer.path.."/localization/"..G.SETTINGS.language..".lua"

    local loc_table
    if Cartomancer.nfs.fileExists(loc_file) then
        loc_table = load(Cartomancer.nfs.read(loc_file), "Cartomancer - Localization")()

        -- Use english strings for missing localization strings
        if G.SETTINGS.language ~= "en-us" then
            add_defaults(default_table, loc_table)
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

