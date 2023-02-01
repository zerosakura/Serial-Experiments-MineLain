function level_init()
    local file = io.open("../mods/labyrinth/level/1.lua", "r")
    local code = file:read("a")
    return code
end