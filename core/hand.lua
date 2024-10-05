-- Hand sorting

G.FUNCS.cartomancer_sort_hand_off = function(e)
    if G.hand.cart_sorting == false then
        G.hand.cart_old_sorting = G.hand.config.sort
        G.hand:sort('off')
    else
        G.hand.config.sort = G.hand.cart_old_sorting
        G.hand:sort()
    end
end

local function is_desc(method)
    return string.find(method, "desc")
end

local function is_suit(method)
    return string.find(method, "suit")
end

local function is_sorted()
    -- TODO : check if hand is already sorted with current method
    return true
end

local g_func_sort_hand_suit = G.FUNCS.sort_hand_suit
G.FUNCS.sort_hand_suit = function(e)
    G.hand.cart_sorting = true
    if not Cartomancer.SETTINGS.improved_hand_sorting then
        return g_func_sort_hand_suit(e)
    end

    local current = G.hand.config.sort
    local new = 'suit desc'

    -- If already sorted by suit, toggle ascending/descending order
    if is_suit(current) and is_sorted() then
        if is_desc(current) then
            new = 'suit asc'
        else
            new = 'suit desc'
        end
    end

    G.hand:sort(new)
    play_sound('paper1')
end

local g_func_sort_hand_value = G.FUNCS.sort_hand_value
G.FUNCS.sort_hand_value = function(e)
    G.hand.cart_sorting = true
    if not Cartomancer.SETTINGS.improved_hand_sorting then
        return g_func_sort_hand_value(e)
    end

    local current = G.hand.config.sort
    local new = 'desc'

    -- If already sorted by value, toggle ascending/descending order
    if not is_suit(current) and is_sorted() then
        if is_desc(current) then
            new = 'asc'
        else
            new = 'desc'
        end
    end

    G.hand:sort(new)
    play_sound('paper1')
end
