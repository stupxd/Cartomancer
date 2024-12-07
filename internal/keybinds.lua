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

function Cartomancer.register_keybind(args)
    assert(type(args.name) == "string", 'keybind args `name` is missing or not a string')
    assert(type(args.func) == "function", 'keybind args `func` is missing or not a function')
    
    assert(Cartomancer.SETTINGS.keybinds[args.name], 'invalid keybind name: '..args.name)

    Cartomancer.INTERNAL_keybinds[args.name] = args.func
end

local recording_keybind = nil

function Cartomancer.record_keybind(args)
    if recording_keybind then
        Cartomancer.log "Already recording keybind, ignoring another call."
        return
    end

    if not args.callback then
        assert(type(args.name) == "string", "missing callback or keybind name")
        args.callback = function (new_keys)
            Cartomancer.SETTINGS.keybinds[args.name] = new_keys
        end
    end
    assert(type(args.callback) == "function", 'arg `callback` must be a function')
    -- optional arg display pressed keys live
    if args.press_callback then
        assert(type(args.press_callback) == "function", 'arg `press_callback` must be a function')
    end
    recording_keybind = {
        pressed = {},
        callback = args.callback,
        press_callback = args.press_callback
    }
end

local on_press = Controller.key_press
function Controller:key_press(key)
    local ret = on_press(self, key)

    if recording_keybind then
        recording_keybind.pressed[key] = true
        if recording_keybind.press_callback then
            recording_keybind.press_callback(recording_keybind.pressed)
        end
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
    if recording_keybind and recording_keybind.pressed[key] then
        recording_keybind.callback(recording_keybind.pressed)
        recording_keybind = nil
    end
    -- Keybinds should still deactivate even during recording
    check_keybinds_deactivation(self)

    return ret
end


