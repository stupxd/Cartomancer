local function asset_path(filename)
    return Cartomancer.path.."/assets/"..G.SETTINGS.GRAPHICS.texture_scaling.."x/"..filename
end

local assets = {
    {name = 'cartomancer_modicon', path = asset_path('modicon.png'), px = 32, py = 32},
    {name = 'cartomancer_settings', path = asset_path('settings.png'), px = 80, py = 80},
}

local game_set_render_settings = Game.set_render_settings

function Game:set_render_settings()
    game_set_render_settings(self)

    for i=1, #assets do
        G.ASSET_ATLAS[assets[i].name] = {}
        G.ASSET_ATLAS[assets[i].name].name = assets[i].name
        G.ASSET_ATLAS[assets[i].name].image = love.graphics.newImage(assets[i].path, {mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling})
        G.ASSET_ATLAS[assets[i].name].px = assets[i].px
        G.ASSET_ATLAS[assets[i].name].py = assets[i].py
    end
end
