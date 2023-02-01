

function level_init()
    local file = io.open("D:/Dev/Github/minetest-5.6.1-win64/mods/labyrinth/level/1.lua", "r")
    local code = file:read("a")
    return code
end