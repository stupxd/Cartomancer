--- STEAMODDED HEADER
--- MOD_NAME: Cartomancer
--- MOD_ID: cartomancer
--- MOD_AUTHOR: [stupxd aka stupid]
--- MOD_DESCRIPTION: Quality of life features and optimizations
--- PRIORITY: 69
--- BADGE_COLOR: FFD700
--- DISPLAY_NAME: Cartomancer
--- VERSION: 3.0

----------------------------------------------
------------MOD CODE -------------------------

Cartomancer.SETTINGS = SMODS.current_mod.config

SMODS.Atlas{
    key = "modicon",
    path = "modicon.png",
    px = 32,
    py = 32
}

-- ========================================================
--                   Mod config menu
-- ========================================================

local color = HEX('FFD700')

local create_column_tabs, create_inline_slider, create_toggle_option, create_input_option

local function is_chosen(tab)
  return Cartomancer.LAST_OPEN_TAB == tab
end

Cartomancer.LAST_OPEN_TAB = "compact_deck"

SMODS.current_mod.config_tab = function()

    local vertical_tabs = {}

    Cartomancer.LAST_OPEN_TAB = "compact_deck"

    local tab_config = {r = 0.1, align = "t", padding = 0.1, colour = G.C.MONEY, minw = 8.5, minh = 6}

    table.insert(vertical_tabs, {
        label = "Compact deck",
        chosen = is_chosen("compact_deck"),
        tab_definition_function = function (...)
            Cartomancer.LAST_OPEN_TAB = "compact_deck"
            -- Yellow node. Align changes the position of modes inside
            return {n = G.UIT.ROOT, config = tab_config, nodes = {
                create_toggle_option('compact_deck_enabled', 'carto_compact_deck_enabled'),
                create_inline_slider('compact_deck_visible_cards', 'carto_compact_deck_visible_cards', {max_value = 999}),
            }}
        end
    })

    table.insert(vertical_tabs, {
        label = "Deck view",
        chosen = is_chosen("deck_view"),
        tab_definition_function = function (...)
            Cartomancer.LAST_OPEN_TAB = "deck_view"
            return {n = G.UIT.ROOT, config = tab_config, nodes = {
                create_toggle_option('deck_view_stack_enabled', 'carto_deck_view_stack_enabled'),
                create_toggle_option('deck_view_hide_drawn_cards', 'carto_deck_view_hide_drawn_cards'),
                create_inline_slider('deck_view_stack_background_opacity', 'carto_deck_view_stack_background_opacity'),
                create_input_option('deck_view_stack_x_color', 'carto_deck_view_stack_x_color', 6),
            }}
        end
    })

    table.insert(vertical_tabs, {
        label = "Optimizations",
        chosen = is_chosen("optimizations"),
        tab_definition_function = function (...)
            Cartomancer.LAST_OPEN_TAB = "optimizations"
            return {n = G.UIT.ROOT, config = tab_config, nodes = {
                create_toggle_option('draw_non_essential_shaders', 'carto_draw_non_essential_shaders'),
                -- 
            }}
        end
    })

    table.insert(vertical_tabs, {
        label = "Flames",
        chosen = is_chosen("flames"),
        tab_definition_function = function (...)
            Cartomancer.LAST_OPEN_TAB = "flames"
            return {n = G.UIT.ROOT, config = tab_config, nodes = {
                create_toggle_option('flames_intensity_enabled', 'carto_flames_intensity_enabled'),
                create_inline_slider('flames_intensity_min', 'carto_flames_intensity_min', {max_value = 20, decimal_places = 1}),
                create_inline_slider('flames_intensity_max', 'carto_flames_intensity_max', {max_value = 30, decimal_places = 1}),
                create_inline_slider('flames_volume', 'carto_flames_volume'),
                -- 
            }}
        end
    })

    return create_UIBox_generic_options_custom({
        bg_colour = G.C.BLUE,
        contents = {
            {
                n = G.UIT.R,
                config = { padding = 0, align = "tl", minw = 10, colour = color },
                nodes = {
                    create_column_tabs({
                        tab_alignment = 'tl',
                        tab_w = 8,
                        tab_h = 4.3,-- this seems to not do shit?
                        text_scale = 0.4,
                        snap_to_nav = true,
                        colour =  G.C.RED,
                        tabs = vertical_tabs
                    })
                }
            },
        }
    })
end

create_inline_slider = function (ref_value, localization, args)
    local args = args or {}

    local slider = create_slider({label = localize(localization), label_scale = 0.36, w = 4, h = 0.3, 
                                  ref_table = Cartomancer.SETTINGS, ref_value = ref_value, min = 0, max = args.max_value or 100,
                                  decimal_places = args.decimal_places})

    slider.nodes[1].config.align = "cl"
    -- slider.nodes[2].nodes[1].n = G.UIT.R
    return slider
end

create_toggle_option = function (ref_value, localization)
    return {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
        {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
            { n = G.UIT.T, config = { text = localize(localization), scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
        }},
        {n = G.UIT.C, config = { align = "cr", padding = 0.05 }, nodes = {
            create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = Cartomancer.SETTINGS, ref_value = ref_value },
        }},
      }}
end

create_input_option = function (ref_value, localization, max_length)
    return { n = G.UIT.R, config = {align = "cl", minw = 4, minh = 0.5, colour = G.C.CLEAR}, nodes = {
            { n = G.UIT.T, config = {text = localize(localization), scale = .36, minw = 4, minh = 0.5, colour = G.C.WHITE} },
            create_text_input({ id = 'Input:'..ref_value, w = 2, max_length = max_length or 3, prompt_text = tostring(Cartomancer.SETTINGS[ref_value]), ref_table = Cartomancer.SETTINGS, ref_value = ref_value})
    }}
end

create_column_tabs = function (args)
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
        UIBox_button({id = id, ref_table = v, button = 'cartomancer_settings_change_tab', label = {v.label},
                                                  minh = 0.8*args.scale, minw = 2.5*args.scale, col = true, choice = true, scale = args.text_scale,
                                                  chosen = v.chosen and 'vert', func = v.func, focus_args = {type = 'none'}})
      }}
    end

    -- Tabs + Contents
    return {n=G.UIT.R, config={padding = 0.0, align = "cl", colour = args.colour,},

        nodes={
          -- Tabs
          {n=G.UIT.ROOT, config={align = "cm", padding = 0.1, colour = G.C.CLEAR}, nodes=tab_buttons},
          
          -- Tab contents
          {n=G.UIT.R, config={align = args.tab_alignment, padding = args.padding or 0.1, no_fill = true, minh = args.tab_h, minw = args.tab_w}, nodes={
              {n=G.UIT.O, config={id = 'cartomancer_settings_tab_contents',
                                  old_chosen = tab_buttons[1].nodes[1].nodes[1],
                                  object = UIBox{definition = args.current.v.tab_definition_function(args.current.v.tab_definition_function_args),
                                                config = {offset = {x=0,y=0}}}}
              }
          }},
        }
    }
end

G.FUNCS.cartomancer_settings_change_tab = function(e)
    if not e then return end
  
    local tab_contents = e.UIBox:get_UIE_by_ID('cartomancer_settings_tab_contents')
    if not tab_contents then return end
    -- Same tab, don't rebuild it.
    if tab_contents.config.oid == e.config.id then return end
    
    if tab_contents.config.old_chosen then tab_contents.config.old_chosen.config.chosen = nil end
    
    tab_contents.config.old_chosen = e
    e.config.chosen = 'vert'

    tab_contents.config.oid = e.config.id
    tab_contents.config.object:remove()
    tab_contents.config.object = UIBox{
        definition = e.config.ref_table.tab_definition_function(e.config.ref_table.tab_definition_function_args),
        config = {offset = {x=0,y=0}, parent = tab_contents, type = 'cm'}
      }
    tab_contents.UIBox:recalculate()
  end

  
function create_UIBox_generic_options_custom(args)
    args = args or {}

    return {n=G.UIT.ROOT, config = {align = "cl", minw = G.ROOM.T.w*0.6, padding = 0.1, r = 0.1, 
                                    colour = args.bg_colour or {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}},
            nodes = {
              {n=G.UIT.C, config={align = "cl", padding = 0, minw = args.minw or 5, minh = args.minh or 3},
                nodes = args.contents
              },
            }
    }
end

----------------------------------------------
------------MOD CODE END----------------------
