
function Cartomancer.create_vert_tabs(args)
      args = args or {}
    args.colour = args.colour or G.C.CLEAR
    args.tab_alignment = args.tab_alignment or 'cl'
    args.opt_callback = args.opt_callback or nil
    args.scale = args.scale or 1
    args.tab_w = args.tab_w or 0
    args.tab_h = args.tab_h or 0
    args.text_scale = (args.text_scale or 0.5)
  
    local tab_buttons = {}
  
    for k, v in ipairs(args.tabs) do
      if v.chosen then args.current = {k = k, v = v} end
      local id = 'tab_but_'..(v.label or '')
      tab_buttons[#tab_buttons+1] = {n=G.UIT.R, config={align = "cm"}, nodes={
        UIBox_button({id = id, ref_table = v, button = 'cartomancer_settings_change_tab', label = {v.label}, colour = lighten(G.C.GREY, 0.115),
                                                  padding = 0.1, minh = 2.8*args.scale, minw = 0.8*args.scale, col = true, choice = true, scale = args.text_scale,
                                                  vert = true, chosen = v.chosen and 'vert', func = v.func, focus_args = {type = 'none'}})
      }}
    end

    -- Tabs + Contents
    return {n=G.UIT.R, config={padding = 0, align = "cl", colour = args.colour,},

        nodes={
          -- Tabs
          {n=G.UIT.C, config={align = "cl", padding = 0.2, colour = G.C.CLEAR}, nodes=tab_buttons},
          
          -- Tab contents
          {n=G.UIT.C, config={align = args.tab_alignment, padding = args.padding or 0.1, no_fill = true, minh = args.tab_h, minw = args.tab_w}, nodes={
              {n=G.UIT.O, config={id = 'cartomancer_settings_tab_contents',
                                  old_chosen = tab_buttons[1].nodes[1].nodes[1],
                                  object = UIBox{definition = args.current.v.tab_definition_function(args.current.v.tab_definition_function_args),
                                                config = {offset = {x=0,y=0}}}}
              }
          }},
        }
    }
end




function Cartomancer.blinds_info_icon()
    local icon = AnimatedSprite(0,0,0.75,0.75, G.ANIMATION_ATLAS['blind_chips'], {x=0, y=1})
        icon.states.drag.can = false
        return {n=G.UIT.C, config={align = "cm", padding = 0.05, r = 0.1, button = 'change_tab'}, nodes={
            {n=G.UIT.O, config={object = icon}},
          }}
end

local gnb = get_new_boss
function get_new_boss(...)
    local ret = gnb(...)

    G.GAME.cartomancer_bosses_list = G.GAME.cartomancer_bosses_list or {}
    G.GAME.cartomancer_bosses_list[#G.GAME.cartomancer_bosses_list+1] = ret

    return ret
end

function Cartomancer.view_blinds_info()
  local blind_matrix = {
    {},{},{}, {}, {}, {}
  }
  G.GAME.cartomancer_bosses_list = G.GAME.cartomancer_bosses_list or {}

  local bosses_list_size = #G.GAME.cartomancer_bosses_list
  local bosses_to_show = 25

  local blind_tab = {}
  -- Go from last generated boss blind until first
  for i = bosses_list_size, (bosses_list_size - bosses_to_show), -1 do
    local blind_key = G.GAME.cartomancer_bosses_list[i]
    local blind = G.P_BLINDS[blind_key]

    if blind then
        blind_tab[#blind_tab+1] = blind
    else
        blind_tab[#blind_tab+1] = G.b_undiscovered
    end
  end

  for k, v in ipairs(blind_tab) do
    local discovered = v.discovered
    local temp_blind = AnimatedSprite(0,0,0.9,0.9, G.ANIMATION_ATLAS[v.atlas or 'blind_chips'], v.pos)
    temp_blind:define_draw_steps({
      {shader = 'dissolve', shadow_height = 0.05},
      {shader = 'dissolve'}
    })
    if k == 1 then 
      G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
          G.CONTROLLER:snap_to{node = temp_blind}
            return true
        end)
      }))
    end
    temp_blind.float = true
    temp_blind.states.hover.can = true
    temp_blind.states.drag.can = false
    temp_blind.states.collide.can = true
    temp_blind.config = {blind = v, force_focus = true}
    if v ~= G.b_undiscovered then
      temp_blind.hover = function()
        if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
            if not temp_blind.hovering and temp_blind.states.visible then
              temp_blind.hovering = true
              temp_blind.hover_tilt = 3
              temp_blind:juice_up(0.05, 0.02)
              play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
              temp_blind.config.h_popup = create_UIBox_blind_popup(v, discovered)
              temp_blind.config.h_popup_config ={align = 'cl', offset = {x=-0.1,y=0},parent = temp_blind}
              Node.hover(temp_blind)
              if temp_blind.children.alert then 
                temp_blind.children.alert:remove()
                temp_blind.children.alert = nil
                temp_blind.config.blind.alerted = true
                G:save_progress()
              end
            end
        end
        temp_blind.stop_hover = function() temp_blind.hovering = false; Node.stop_hover(temp_blind); temp_blind.hover_tilt = 0 end
      end
    end
    blind_matrix[math.ceil((k-1)/5+0.001)][1+((k-1)%5)] = {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
      --(k==6 or k ==16 or k == 26) and {n=G.UIT.B, config={h=0.2,w=0.5}} or nil,
      {n=G.UIT.O, config={object = temp_blind, focus_with_object = true}},
      --(k==5 or k ==15 or k == 25) and {n=G.UIT.B, config={h=0.2,w=0.5}} or nil,
    }}
  end

local min_ante = 1
local max_ante = 9
local spacing = 0.07
local current_ante = G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante or 1
local ante_scaling = G.GAME and G.GAME.starting_params and G.GAME.starting_params.ante_scaling or 1
if current_ante > 1 then
    min_ante = current_ante - 1
    max_ante = current_ante + 8
end
  local ante_amounts = {}
  for i = min_ante, max_ante do
    
    if spacing > 0 and i > 1 then 
      ante_amounts[#ante_amounts+1] = {n=G.UIT.R, config={minh = spacing}, nodes={}}
    end
    local blind_chip = Sprite(0,0,0.2,0.2,G.ASSET_ATLAS["ui_"..(G.SETTINGS.colourblind_option and 2 or 1)], {x=0, y=0})
      blind_chip.states.drag.can = false
      ante_amounts[#ante_amounts+1] = {n=G.UIT.R, config={align = "cm", padding = 0.07, colour = i == current_ante and G.C.GREY}, nodes={
        {n=G.UIT.C, config={align = "cm", minw = 0.7}, nodes={
          {n=G.UIT.T, config={text = i, scale = 0.4, colour = G.C.FILTER, shadow = true}},
        }},
        {n=G.UIT.C, config={align = "cr", minw = 2.8}, nodes={
          {n=G.UIT.O, config={object = blind_chip}},
          {n=G.UIT.C, config={align = "cm", minw = 0.03, minh = 0.01}, nodes={}},
          {n=G.UIT.T, config={text =number_format(get_blind_amount(i) * ante_scaling), scale = 0.4, colour = i <= G.PROFILES[G.SETTINGS.profile].high_scores.furthest_ante.amt and G.C.RED or G.C.JOKER_GREY, shadow = true}},
        }}
      }}
  end 

  return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR, padding = 0, minh = 7.615, minw = 11.5}, nodes={
    {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.BLACK, padding = 0.1, emboss = 0.05}, nodes={
    {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.L_BLACK, padding = 0.15, force_focus = true, focus_args = {nav = 'tall'}}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
          {n=G.UIT.C, config={align = "cm", minw = 0.7}, nodes={
            {n=G.UIT.T, config={text = localize('k_ante_cap'), scale = 0.4, colour = lighten(G.C.FILTER, 0.2), shadow = true}},
          }},
          {n=G.UIT.C, config={align = "cr", minw = 2.8}, nodes={
            {n=G.UIT.T, config={text = localize('k_base_cap'), scale = 0.4, colour = lighten(G.C.RED, 0.2), shadow = true}},
          }}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes=ante_amounts}
    }},
    {n=G.UIT.C, config={align = "cm", minw = 6.}, nodes={
      {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.B, config={h=0.2,w=0.5}}
      }},
      {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.C, config={align = "cm", outline = 1, outline_colour = G.C.GREY, colour = darken(G.C.GREY, 0.3), minw = 5.2, r = 0.1, padding = 0.07, line_emboss = 1}, nodes={
          {n=G.UIT.O, config={object = DynaText({string = localize('carto_blinds_info_title'), colours = {G.C.WHITE}, shadow = true, float = true, y_offset = -4, scale = 0.45, maxw =4.4})}},
        }},
      }},
      {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.B, config={h=0.2,w=0.5}}
      }},
      {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[1]},
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[2]},
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[3]},
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[4]},
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[5]},
      }}
    }},
  }}
  }}  
end
