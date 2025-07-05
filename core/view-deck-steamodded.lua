

Cartomancer.get_visible_suits_smods = function (unplayed_only, page)

  local SUITS = {}
  -- Init all suits visible in deck
  for _, v in ipairs(G.playing_cards) do
	  if v.base.suit then
	  local greyed = unplayed_only and not ((v.area and v.area == G.deck) or v.ability.wheel_flipped)
	
	  if greyed and Cartomancer.SETTINGS.deck_view_hide_drawn_cards then
	  -- Ignore this card.
	  elseif not SUITS[v.base.suit] then
      SUITS[v.base.suit] = true
	  end
	  end
	end

  -- Now create a table with all visible suits
  -- sorted in the same order as the deck view
  local visible_suits = {}
	for i = #SMODS.Suit.obj_buffer, 1, -1 do
    if SUITS[SMODS.Suit.obj_buffer[i]] then
      table.insert(visible_suits, SMODS.Suit.obj_buffer[i])
    end
	end

	local deck_start_index = (page - 1) * 4 + 1
	local deck_end_index = math.min(deck_start_index + 4 - 1, #visible_suits)

  local result_suits = {}
  for i = deck_start_index, deck_end_index do
    result_suits[visible_suits[i]] = true
  end
  return result_suits
end


