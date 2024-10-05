local function asset_path(filename)
    return Cartomancer.path.."/assets/"..G.SETTINGS.GRAPHICS.texture_scaling.."x/"..filename
end

local assets = {
    {name = 'cart_modicon', path = asset_path('modicon.png'), px = 32, py = 32},
    {name = 'cart_settings', path = asset_path('settings.png'), px = 80, py = 80},
}

local game_set_render_settings = Game.set_render_settings

function Game:set_render_settings()
    game_set_render_settings(self)

    for i=1, #assets do
        G.ASSET_ATLAS[assets[i].name] = {}
        G.ASSET_ATLAS[assets[i].name].name = assets[i].name
        -- File load method using steamodded's code
        local file_data = assert(Cartomancer.nfs.newFileData(assets[i].path), 'Failed to collect file data for '..assets[i].name)
        local image_data = assert(love.image.newImageData(file_data), 'Failed to initialize image data for '..assets[i].name)
        G.ASSET_ATLAS[assets[i].name].image = love.graphics.newImage(image_data, {mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling})
        G.ASSET_ATLAS[assets[i].name].px = assets[i].px
        G.ASSET_ATLAS[assets[i].name].py = assets[i].py
    end
end
