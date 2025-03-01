
-- THIS IS NO LONGER BEING USED
-- Leaving this in for sentimental value :)

local Cartomancer_replacements = {
    {
        find = [[
	for k, v in ipairs%(G%.playing_cards%) do
		if v%.base%.suit then table%.insert%(SUITS%[v%.base%.suit%], v%) end]],
    -- Steamodded<0917b
        find_alt = [[
	for k, v in ipairs%(G%.playing_cards%) do
		table%.insert%(SUITS%[v%.base%.suit%], v%)]],
        place = [[
local SUITS_SORTED = Cartomancer.tablecopy(SUITS)
for k, v in ipairs(G.playing_cards) do
  if v.base.suit then
  local greyed
  if unplayed_only and not ((v.area and v.area == G.deck) or v.ability.wheel_flipped) then
    greyed = true
  end
  local card_string = v:cart_to_string {deck_view = true}
  if greyed then
    card_string = card_string .. "Greyed" -- for some reason format doesn't work and final string is `sGreyed`
  end
  if greyed and Cartomancer.SETTINGS.deck_view_hide_drawn_cards then
  -- Ignore this card.
  elseif not SUITS[v.base.suit][card_string] then
    -- Initiate stack
    table.insert(SUITS_SORTED[v.base.suit], card_string)

    local _scale = 0.7
    local copy = copy_card(v, nil, _scale)

    copy.greyed = greyed
    copy.stacked_quantity = 1

    SUITS[v.base.suit][card_string] = copy
  else
    -- Stack cards
    local stacked_card = SUITS[v.base.suit][card_string]
    stacked_card.stacked_quantity = stacked_card.stacked_quantity + 1
  end
  end]]
    },

    {
        find = "card_limit = #SUITS%[suit_map%[j%]%],",
        place = "card_limit = #SUITS_SORTED[suit_map[j]],"
    },

    {
        find = [[
for i = 1%, %#SUITS%[suit_map%[j%]%] do
				if SUITS%[suit_map%[j%]%]%[i%] then
					local greyed%, _scale = nil%, 0%.7
					if unplayed_only and not %(%(SUITS%[suit_map%[j%]%]%[i%]%.area and SUITS%[suit_map%[j%]%]%[i%]%.area == G%.deck%) or SUITS%[suit_map%[j%]%]%[i%]%.ability%.wheel_flipped%) then
						greyed = true
					end
					local copy = copy_card%(SUITS%[suit_map%[j%]%]%[i%]%, nil%, _scale%)
					copy%.greyed = greyed
					copy%.T%.x = view_deck%.T%.x %+ view_deck%.T%.w %/ 2
					copy%.T%.y = view_deck%.T%.y

					copy:hard_set_T%(%)
					view_deck:emplace%(copy%)
				end
			end]],
        place = [[
for i = 1%, %#SUITS_SORTED%[suit_map%[j%]%] do
  local card_string = SUITS_SORTED%[suit_map%[j%]%]%[i%]
  local card = SUITS%[suit_map%[j%]%]%[card_string%]

  card%.T%.x = view_deck%.T%.x %+ view_deck%.T%.w%/2
  card%.T%.y = view_deck%.T%.y
  card:create_quantity_display%(%)

  card:hard_set_T%(%)
  view_deck:emplace%(card%)
end]]
    },
    
    {
      find = '			modded and {n = G.UIT.R, config = {align = "cm"}, nodes = {',
      place = [=[
      not unplayed_only and Cartomancer.add_unique_count() or nil,
			modded and {n = G.UIT.R, config = {align = "cm"}, nodes = {]=]
  },

}


--  Mom, can we have lovely patches for overrides.lua?
--  No, we have lovely patches at home

--  Lovely patches at home:

local Cartomancer_nfs_read
local Cartomancer_nfs_read_override = function (containerOrName, nameOrSize, sizeOrNil)
    local data, size = Cartomancer_nfs_read(containerOrName, nameOrSize, sizeOrNil)

    if type(containerOrName) ~= "string" then
        return data, size
    end
    local overrides = '/overrides.lua'
    if containerOrName:sub(-#overrides) ~= overrides then
        return data, size
    end

    local replaced = 0
    local total_replaced = 0
    for _, v in ipairs(Cartomancer_replacements) do
        data, replaced = string.gsub(data, v.find, v.place)

        if replaced == 0 and v.find_alt then
          data, replaced = string.gsub(data, v.find_alt, v.place)
        end

        if replaced == 0 then
          print("Failed to replace " .. v.find .. " for overrides.lua")
        else
          total_replaced = total_replaced + 1
        end
    end

    print("Totally applied " .. total_replaced .. " replacements to overrides.lua")

    -- We no longer need this override
    NFS.read = Cartomancer_nfs_read
    
    return data, size
end
