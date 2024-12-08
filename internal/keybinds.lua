Cartomancer.INTERNAL_keybinds = {}

-- Lock for activated keybinds to not trigger multiple times
local activated = {}

-- Check if a specific keybind can
local function is_keybind_pressed(controller, name)
    local required_keys = Cartomancer.SETTINGS.keybinds[name]

    for key, _ in pairs(required_keys) do
        if not controller.held_keys[key] then
            return false
        end
    end
    return true
end

-- On key press, check keybinds that can activate 
local function check_keybinds_activation(controller)
    for name, func in pairs(Cartomancer.INTERNAL_keybinds) do
        if not activated[name] and is_keybind_pressed(controller, name) then
            func(controller)
            activated[name] = true
        end
    end
end

-- On key unpress, check active keybinds and remove the ones that should deactivate
local function check_keybinds_deactivation(controller)
    local to_remove = {}
    for name, _ in pairs(activated) do
        if not is_keybind_pressed(controller, name) then
            table.insert(to_remove, name)
        end
    end

    for _, name in pairs(to_remove) do
        activated[name] = nil
    end
end

--
-- Public functions to handle keybinds
--

function Cartomancer.register_keybind(args)
    assert(type(args.name) == "string", 'keybind args `name` is missing or not a string')
    assert(type(args.func) == "function", 'keybind args `func` is missing or not a function')
    
    assert(Cartomancer.SETTINGS.keybinds[args.name], 'invalid keybind name: '..args.name)

    Cartomancer.INTERNAL_keybinds[args.name] = args.func
end

function Cartomancer.record_keybind(args)
    Cartomancer.log "Starting to record keybind"
    if Cartomancer._recording_keybind then
        Cartomancer.log "Already recording keybind, resetting that one!"
        local existing_keybind = Cartomancer.SETTINGS.keybinds[Cartomancer._recording_keybind.name]
        Cartomancer._recording_keybind.callback(existing_keybind)
        Cartomancer._recording_keybind = nil
        --return
    end
    assert(type(args.name) == "string", "missing keybind name")
    
    if not args.callback then
        args.callback = function (new_keys)
            Cartomancer.SETTINGS.keybinds[args.name] = new_keys
        end
    end
    assert(type(args.callback) == "function", 'arg `callback` must be a function')
    -- optional arg display pressed keys live
    args.press_callback = args.press_callback or Cartomancer.do_nothing
    assert(type(args.press_callback) == "function", 'arg `press_callback` must be a function')
    Cartomancer._recording_keybind = {
        name = args.name,
        pressed = {},
        callback = args.callback,
        press_callback = args.press_callback
    }
end

-- 
-- Handle key press / release
-- 

local on_press = Controller.key_press
function Controller:key_press(key)
    if key == 'escape' and Cartomancer._recording_keybind then
        -- Reset keybind completely
        Cartomancer.log "Resetting keybind"
        local empty_keybind = {['[none]'] = true}
        Cartomancer._recording_keybind.callback(empty_keybind)
        Cartomancer._recording_keybind = nil
        return
    end

    local ret = on_press(self, key)

    if Cartomancer._recording_keybind then
        Cartomancer.log("Adding key "..key)
        Cartomancer._recording_keybind.pressed[key] = true
        Cartomancer._recording_keybind.press_callback(Cartomancer._recording_keybind.pressed)
    else
        -- Only check activation if not recording
        check_keybinds_activation(self)
    end

    return ret
end

local on_release = Controller.key_release
function Controller:key_release(key)
    local ret = on_release(self, key)

    -- Only callback if key was pressed during keybind recording
    if Cartomancer._recording_keybind and Cartomancer._recording_keybind.pressed[key] then
        Cartomancer.log "Saving keybind"
        Cartomancer._recording_keybind.callback(Cartomancer._recording_keybind.pressed)
        Cartomancer._recording_keybind = nil
    end
    -- Keybinds should still deactivate even during recording
    check_keybinds_deactivation(self)

    return ret
end


