if Cartomancer.use_smods() then return end

-- Vanilla will only support default loc cuz yes.
local loc_table = Cartomancer.load_mod_file('localization/en-us.lua', 'localization')

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
recurse(loc_table, G.localization)

--local cas = CardArea.sort
--function CardArea:sort(method)
--    if method == 'sort_id' and self.cards[1] and self.cards[1].sort_id then
--        table.sort(self.cards, function (a, b) return a.sort_id > b.sort_id end )
--        return
--    end
--
--    return cas(self, method)
--end
