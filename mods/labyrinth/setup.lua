--dofile(modpath .. "/message.lua")

level = 1
new_level = true

function level_code(level)
    local file = io.open("../mods/labyrinth/level/"..tostring(level)..".lua", "r")
    return file:read("a")    
end

function go_level(level)
    new_level = true
    local func = {loadstring(level_code(level))}
    if (func[1] ~= nil) then
        func[1]()
    else 
        minetest.chat_send_all("Error!")
        minetest.chat_send_all(func[2])
    end
end

function prev_level()
    level = level - 1
    this_level(level)
end

function next_level()
    level = level + 1
    this_level(level)    
end

function this_level()
    local player = minetest.get_player_by_name("singleplayer")    
    player:set_pos({x=5,y=1.5,z=2})
    go_level(level)
end

function place(xx,yy,zz,ss)
    if ss == "glass" then 
        ss = "xpanes:obsidian_pane_flat"
    elseif ss == "stone" then 
        ss = "default:silver_sandstone_block"
    end

    minetest.set_node({x=xx,y=yy,z=zz}, {name = ss})
end