local function safe_clear(w, l)
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=-10,y=-11,z=-10}, {x=w,y=10,z=l})
    local data = vm:get_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local invisible = minetest.get_content_id("labyrinth:inv")
    local air = minetest.get_content_id("air")

    for z=0, l-10 do --z
        for y=0,10 do --y
            for x=0, w-10 do --x
                data[a:index(x, y, z)] = air
            end
        end
    end

    for z=-10, l do --z
        for x=-10, w do --x
            data[a:index(x, -11, z)] = invisible
        end
    end
    vm:set_data(data)
    vm:write_to_map(true)
end

local function init_level()
    local player = minetest.get_player_by_name("singleplayer")
    safe_clear(300, 300)
    width = 9
    height = 9

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=0,z=0}, {x=height*2,y=10,z=width*2})
    local data = vm:get_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local wall = minetest.get_content_id("default:silver_sandstone_block")
    local air = minetest.get_content_id("air")
    local computer = minetest.get_content_id("laptop:portable_workstation_2_closed")
    local glass = minetest.get_content_id("xpanes:obsidian_pane_flat")
    local door = minetest.get_content_id("doors:door_steel_a")
    local desk = minetest.get_content_id("homedecor:table_mahogany")

    minetest.set_timeofday(0.8)

    --player target coords
    center_x = (math.floor(height/2)+(math.floor(height/2)+1)%2)
    center_z = (math.floor(width/2)+(math.floor(width/2)+1)%2)
    player:set_velocity({x=0,y=0,z=0})
    player:set_pos({x=center_x,y=1.5,z=center_z-3})

    --Set up the level itself
    for z=1, width do --z
        for x=1, height do --x
                data[a:index(x, 0, z)] = wall
        end
    end
    for z=1, width do
        for y=0,8 do
            data[a:index(1, y, z)] = wall
            data[a:index(height, y, z)] = wall
        end
    end
    for x=1, height do
        for y=0,8 do
            data[a:index(x, y, 1)] = wall
            data[a:index(x, y, width)] = wall
        end
    end
    for y=1, 8 do
        for x=2, height-1 do
            data[a:index(x, y, center_z)] = glass
        end
    end

    data[a:index(center_x-3, 1, center_z-2)] = desk
    data[a:index(center_x-3, 1, center_z-3)] = desk
    data[a:index(center_x-3, 2, center_z-2)] = computer    
    
    local param2 = vm:get_param2_data()
    local rotation = minetest.dir_to_facedir({x=-1,y=0,z=0})
    param2[a:index(center_x-3, 2, center_z-2)] = rotation

    data[a:index(center_x, 1, width)] = air
    data[a:index(center_x, 2, width)] = air
    data[a:index(center_x, 1, width)] = door

    minetest.register_globalstep(
        function(dtime)
            local player = minetest.get_player_by_name("singleplayer")
            if player then
                local pos = player:get_pos()
                if pos.y < -10 then
                    minetest.sound_play("win")
                    minetest.chat_send_all(minetest.colorize(primary_c,"Congrats on finishing ".. styles[selectedStyle].name).. "!")
                    to_game_menu(player)
                end
            end
        end
    )

    vm:set_data(data)
    vm:set_param2_data(param2)
    vm:write_to_map(true)
end

init_level()