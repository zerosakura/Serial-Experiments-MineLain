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
    width = 10
    height = 10

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=0,z=0}, {x=height*2,y=10,z=width*2})
    local data = vm:get_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local wall = minetest.get_content_id("default:silver_sandstone_block")
    local air    =   minetest.get_content_id("air")
    local computer = minetest.get_content_id("laptop:portable_workstation_2_closed")
    local glass = minetest.get_content_id("xpanes:obsidian_pane_flat")
    local door = minetest.get_content_id("doors:door_steel_a")
    local desk = minetest.get_content_id("homedecor:table_mahogany")

    minetest.set_timeofday(0.8)

    --player target coords
    center_x = (math.floor(height/2)+(math.floor(height/2)+1)%2)*2
    center_z = (math.floor(width/2)+(math.floor(width/2)+1)%2)*2    
    player:set_velocity({x=0,y=0,z=0})
    player:set_pos({x=center_x,y=1.5,z=center_z-3})

    --Set up the level itself
    for z=1, width do --z
        for x=1, height do --x
            if ((z ~= 1 and z ~= width) and (x ~= 1 and x ~= height))   then
                data[a:index(x*2, 0, z*2)]     = wall
                data[a:index(x*2+1, 0, z*2)]   = wall
                data[a:index(x*2+1, 0, z*2+1)] = wall
                data[a:index(x*2, 0, z*2+1)]   = wall
            else
                data[a:index(x*2, 0, z*2)]     = wall
                data[a:index(x*2+1, 0, z*2)]   = wall
                data[a:index(x*2+1, 0, z*2+1)] = wall
                data[a:index(x*2, 0, z*2+1)]   = wall
            end
        end
    end
    for z=1, width do
        for y=3,9 do
            data[a:index(1, y, z*2)] = wall
            data[a:index(1, y, z*2+1)] = wall
            data[a:index(height*2+1, y, z*2)] = wall
            data[a:index(height*2+1, y, z*2+1)] = wall
        end
        for y=0,2 do
            data[a:index(1, y, z*2)] = wall
            data[a:index(1, y, z*2+1)] = wall
            data[a:index(height*2+1, y, z*2)] = wall
            data[a:index(height*2+1, y, z*2+1)] = wall
        end
    end
    for x=1, height do
        for y=3,9 do
            data[a:index(x*2, y, 1)] = wall
            data[a:index(x*2+1, y, 1)] = wall
            data[a:index(x*2, y, width*2+1)] = wall
            data[a:index(x*2+1, y, width*2+1)] = wall
        end
        for y=0,2 do
            data[a:index(x*2, y, 1)] = wall
            data[a:index(x*2+1, y, 1)] = wall
            data[a:index(x*2, y, width*2+1)] = wall
            data[a:index(x*2+1, y, width*2+1)] = wall
        end
    end
    for y=1, 10 do
        for x=1, height do
            data[a:index(x*2, y, center_z+1)] = glass
            if(x ~= height) then
                data[a:index(x*2+1, y, center_z+1)] = glass
            end
        end
    end

    data[a:index(center_x-8, 1, center_z-5)] = desk
    data[a:index(center_x-8, 1, center_z-6)] = desk
    data[a:index(center_x-8, 2, center_z-5)] = computer    
    
    local param2 = vm:get_param2_data()
    local rotation = minetest.dir_to_facedir({x=-1,y=0,z=0})
    param2[a:index(center_x-8, 2, center_z-5)] = rotation

    data[a:index(center_x, 1, width*2+1)] = air
    data[a:index(center_x, 2, width*2+1)] = air
    data[a:index(center_x, 1, width*2+1)] = door

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