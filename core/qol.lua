
--#region Show high scores when hovering Blind Score

local g_igo = Game.init_game_object
function Game:init_game_object()
    local g = g_igo(self)
    g.carto_high_scores = {
        highest_text = "0",
        latest_text = "0",
    }
    return g
end

-- Add high scores table to runs started before this was added
local g_sr = Game.start_run
function Game:start_run(args)
    g_sr(self, args)

    if not G.GAME.carto_high_scores then
        G.GAME.carto_high_scores = {
            highest_text = "0",
            latest_text = "0",
        }
    end
end

function Cartomancer.score_hover()
    local stake_sprite = get_stake_sprite(2, 0.15)
    local stake_sprite2 = get_stake_sprite(2, 0.15)

    return {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={padding = 0.05, r = 0.12, colour = G.C.DYN_UI.MAIN, emboss = 0.07}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0.07, r = 0.1, colour = lighten(G.C.BLACK, 0.1)}, nodes={

            {n=G.UIT.R, config={align = "cm", padding = 0.01, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.T, config={align="cm", scale = 0.4, colour = G.C.WHITE, text = localize('carto_score_highest'), }}
            }},
            {n=G.UIT.R, config={align = "cm", colour = G.C.UI.BACKGROUND_WHITE, r = 0.1, padding = 0.04, minw = 2.5, minh = 0.6, emboss = 0.05, filler = true}, nodes={
              {n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes={
                {n=G.UIT.O, config={w=0.5,h=0.5 , object = stake_sprite, hover = true, can_collide = false}},
                {n=G.UIT.B, config={w=0.1,h=0.1}},
                {n=G.UIT.T, config={align="cm", colour = G.C.GREY, scale = 0.5, ref_table = G.GAME.carto_high_scores, ref_value = "highest_text", func = 'carto_highest_score', }}
              }}
            }},

            {n=G.UIT.R, config={align = "cm", padding = 0.01, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.T, config={align="cm", scale = 0.4, colour = G.C.WHITE, text = localize('carto_score_last'), }}
            }},
            {n=G.UIT.R, config={align = "cm", colour = G.C.UI.BACKGROUND_WHITE, r = 0.1, padding = 0.04, minw = 2.5, minh = 0.6, emboss = 0.05, filler = true}, nodes={
              {n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes={
                {n=G.UIT.O, config={w=0.5,h=0.5 , object = stake_sprite2, hover = true, can_collide = false}},
                {n=G.UIT.B, config={w=0.1,h=0.1}},
                {n=G.UIT.T, config={align="cm", colour = G.C.GREY, scale = 0.5, ref_table = G.GAME.carto_high_scores, ref_value = "latest_text", func = 'carto_latest_score', }}
              }}
            }},
          }}
        }}
      }}
end

-- Update hand score
local cashs = check_and_set_high_score
function check_and_set_high_score(score, amt)
    if score == 'hand' then
        if amt == math.huge then
            G.GAME.carto_high_scores.latest = "inf"
            G.GAME.carto_high_scores.highest = "inf"
        else
            G.GAME.carto_high_scores.latest = amt

            local highest = G.GAME.carto_high_scores.highest == "inf" and math.huge or G.GAME.carto_high_scores.highest or 0
            if amt > highest then
                G.GAME.carto_high_scores.highest = amt
            end
        end
    end
    cashs(score, amt)
end

-- Update scale for highest score
G.FUNCS.carto_highest_score = function(e)
    local score = G.GAME.carto_high_scores.highest == "inf" and math.huge or G.GAME.carto_high_scores.highest or 0
    local new_chips_text = number_format(score)
    if G.GAME.carto_high_scores.highest_text ~= new_chips_text then
        e.config.scale = math.min(0.8, scale_number(score, 1.1)) / 0.8 * 0.5
        G.GAME.carto_high_scores.highest_text = new_chips_text
    end
end

-- Update scale for latest score
G.FUNCS.carto_latest_score = function(e)
    local score = G.GAME.carto_high_scores.latest == "inf" and math.huge or G.GAME.carto_high_scores.latest or 0
    local new_chips_text = number_format(score)
    if G.GAME.carto_high_scores.latest_text ~= new_chips_text then
        e.config.scale = math.min(0.8, scale_number(score, 1.1)) / 0.8 * 0.5
        G.GAME.carto_high_scores.latest_text = new_chips_text
    end
end
--#endregion


--#region Juice jokers logic

-- Card Sharp
function Cartomancer.highlighted_hand_played_this_round(joker)
    if joker.debuff then
        return false
    end
    if joker.facing ~= "front" then
        return false
    end
    if not (G.STATE == G.STATES.SELECTING_HAND) then
        return false
    end

    local highlighted_hand = G.GAME.current_round.current_hand.handname
    return G.GAME.hands[highlighted_hand] and G.GAME.hands[highlighted_hand].played_this_round >= 1
end

-- Obelisk
function Cartomancer.highlighted_hand_most_played(joker)
    if joker.debuff then
        return false
    end
    if joker.facing ~= "front" then
        return false
    end
    if not (G.STATE == G.STATES.SELECTING_HAND) then
        return false
    end

    local highlighted_hand = G.GAME.current_round.current_hand.handname

    if G.GAME.hands[highlighted_hand] and joker.ability and joker.ability.x_mult and joker.ability.x_mult > 1 then
        local reset = true
        local play_more_than = (G.GAME.hands[highlighted_hand].played or 0)
        for k, v in pairs(G.GAME.hands) do
            if k ~= highlighted_hand and v.played > play_more_than and v.visible then
                reset = false
            end
        end
        return reset
    end
end

-- Madness + Dagger
function Cartomancer.juice_joker_during_blind_select(joker)
    local madness = joker.config.center.name == "Madness"
    if joker.debuff then
        return false
    end
    if joker.facing ~= "front" then
        return false
    end

    if madness then
        return G.GAME.round_resets.blind_states.Small == "Select" or G.GAME.round_resets.blind_states.Big == "Select"
    end

    return G.STATE == G.STATES.BLIND_SELECT
end

-- Burnt Joker
function Cartomancer.juice_joker_before_discard(joker)
    if joker.debuff then
        return false
    end
    if joker.facing ~= "front" then
        return false
    end

    return G.STATE == G.STATES.SELECTING_HAND and G.GAME.current_round.discards_used <= 0 and G.GAME.current_round.discards_left > 0
end

-- Sixth Sense
function Cartomancer.juice_joker_before_hand(joker)
    if joker.debuff then
        return false
    end
    if joker.facing ~= "front" then
        return false
    end

    -- Maybe check if your deck has any 6s?
    -- I guess you could have a rock 6 or a 5 that could be strengthened, so probably shouldn't
    return G.STATE == G.STATES.SELECTING_HAND and G.GAME.current_round.hands_played <= 0
end

local function juice_jokers_permanently()
    if not G.jokers then
        return "stop"
    end
    if not Cartomancer.SETTINGS.jokers_jiggling then
        return
    end

    for _, v in pairs(G.jokers.cards) do
        local name = v.config.center.name

        local jiggle = false
        if name == 'Card Sharp' then
            jiggle = Cartomancer.highlighted_hand_played_this_round(v)
        elseif name == 'Obelisk' then
            jiggle = Cartomancer.highlighted_hand_most_played(v)
        elseif name == 'Ceremonial Dagger' then
            jiggle = Cartomancer.juice_joker_during_blind_select(v)
        elseif name == 'Madness' then
            jiggle = Cartomancer.juice_joker_during_blind_select(v)
        elseif name == 'Burnt Joker' then
            jiggle = Cartomancer.juice_joker_before_discard(v)
        elseif name == 'Sixth Sense' then
            jiggle = Cartomancer.juice_joker_before_hand(v)
        end

        if jiggle then
            v:juice_up(0.1, 0.1)
        end
    end

end

local g_sr = Game.start_run
function Game:start_run(args)
    g_sr(self, args)

    Cartomancer.run_permanently("jiggle_jokers", juice_jokers_permanently, 0.8)
end

--#endregion



--#region run_permanently
local identifiers = {}

local function run_permanently(func, delay)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',delay = delay or 0.1, blocking = false, blockable = false, timer = 'REAL',
        func = (function()
            local res = func()
            if res == "stop" then
                return true
            end
            run_permanently(func, delay or 0.8)
            return true
        end)
    }))
end

function Cartomancer.run_permanently(identifier, func, delay)
    assert(identifier, "unspecified identifier")
    if identifiers[identifier] then
        return
    end
    run_permanently(func, delay)
end
--#endregion
