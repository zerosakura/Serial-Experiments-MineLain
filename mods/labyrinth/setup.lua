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
    id = player:hud_add({
        hud_elem_type = "text",
        position  = {x = 0.5, y = 0.40},
        offset    = {x = 0, y = 0},
        text      = "Level "..level,
        alignment = 0,
        scale     = {x = 120, y = 50},
        number    = 0xFFFFFF,
        size      = {x = 5, y = 2},
    })
    minetest.after(3, function ()
        player:hud_remove(id)
    end)
    go_level(level.."_editable")
    go_level(level)
end

function place(xx,yy,zz,ss)
    if ss == "glass" then 
        ss = "xpanes:obsidian_pane_flat"
    elseif ss == "stone" then 
        ss = "default:silver_sandstone_block"
    end

    if (minetest.get_node({x=xx,y=yy,z=zz}).name ~= "default:silver_sandstone_block") then
        minetest.set_node({x=xx,y=yy,z=zz}, {name = ss})
    else
        minetest.chat_send_all("Error!")
        minetest.chat_send_all("Cannot replace the stone!")
    end
end

function check(node, numberA, comparator)
    if node == "glass" then 
        node = "xpanes:obsidian_pane_flat"
    elseif node == "stone" then 
        node = "default:silver_sandstone_block"
    end
    local numberB = 0
    for x=0,31 do
        for y=-10,10 do
            for z=0,31 do
                if(minetest.get_node({x=x,y=y,z=z}).name == node) then
                    numberB = numberB+1
                end
            end
        end
    end
    return comparator(numberA,numberB)
end