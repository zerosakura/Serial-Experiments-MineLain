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

local player = minetest.get_player_by_name("singleplayer")
    safe_clear(300, 300)
    --local maze = GenMaze(math.floor(gwidth/2)*2+((gwidth+1)%2),math.floor(gheight/2)*2+(gheight+1)%2)
    --local loc_maze = maze
    width = 40
    height = 40

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=0,z=0}, {x=height*2,y=10,z=width*2})
    local data = vm:get_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local club_ground  = minetest.get_content_id("labyrinth:club_ground")
    local club_wall    = minetest.get_content_id("labyrinth:club_wall")
    local club_ceiling = minetest.get_content_id("labyrinth:club_ceiling")
    local club_light   = minetest.get_content_id("labyrinth:club_light")
    local club_walkway = minetest.get_content_id("labyrinth:club_walkway")
    local club_edge    = minetest.get_content_id("labyrinth:club_edge")
    local air    =   minetest.get_content_id("air")
    local computer = minetest.get_content_id("laptop:portable_workstation_2_closed")
    local glass = minetest.get_content_id("default:obsidian_glass")

    minetest.set_timeofday(0.8)

    --player target coords
    player_x = (math.floor(height/2)+(math.floor(height/2)+1)%2)*2
    player_z = (math.floor(width/2)+(math.floor(width/2)+1)%2)*2
    --Finally, move  the player
    player:set_physics_override({gravity=0})
    player:set_physics_override({gravity=0})
    player:set_velocity({x=0,y=0,z=0})
    player:set_pos({x=player_x,y=1.5,z=player_z})

    --Set up the level itself
    for z=1, width do --z
        for x=1, height do --x
            if ((z ~= 1 and z ~= width) and (x ~= 1 and x ~= height))   then
                data[a:index(x*2, 0, z*2)]     = club_walkway
                data[a:index(x*2+1, 0, z*2)]   = club_walkway
                data[a:index(x*2+1, 0, z*2+1)] = club_walkway
                data[a:index(x*2, 0, z*2+1)]   = club_walkway
            else
                data[a:index(x*2, 0, z*2)]     = club_ground
                data[a:index(x*2+1, 0, z*2)]   = club_ground
                data[a:index(x*2+1, 0, z*2+1)] = club_ground
                data[a:index(x*2, 0, z*2+1)]   = club_ground

                data[a:index(x*2,   1, z*2)]   = club_wall
                data[a:index(x*2+1, 1, z*2)]   = club_wall
                data[a:index(x*2+1, 1, z*2+1)] = club_wall
                data[a:index(x*2,   1, z*2+1)] = club_wall
            end
            data[a:index(x*2,   10, z*2)]   = club_light
            --data[a:index(x*2+1, 10, z*2)]   = club_ceiling
            --data[a:index(x*2+1, 10, z*2+1)] = club_ceiling
            --data[a:index(x*2,   10, z*2+1)] = club_ceiling
        end
    end
    for z=1, width do
        for y=3,9 do
            data[a:index(1, y, z*2)] = club_ceiling
            data[a:index(1, y, z*2+1)] = club_ceiling
            data[a:index(height*2+1, y, z*2)] = club_ceiling
            data[a:index(height*2+1, y, z*2+1)] = club_ceiling
        end
        for y=0,2 do
            data[a:index(1, y, z*2)] = club_edge
            data[a:index(1, y, z*2+1)] = club_edge
            data[a:index(height*2+1, y, z*2)] = club_edge
            data[a:index(height*2+1, y, z*2+1)] = club_edge
        end
    end
    for x=1, height do
        for y=3,9 do
            data[a:index(x*2, y, 1)] = club_ceiling
            data[a:index(x*2+1, y, 1)] = club_ceiling
            data[a:index(x*2, y, width*2+1)] = club_ceiling
            data[a:index(x*2+1, y, width*2+1)] = club_ceiling
        end
        for y=0,2 do
            data[a:index(x*2, y, 1)] = club_edge
            data[a:index(x*2+1, y, 1)] = club_edge
            data[a:index(x*2, y, width*2+1)] = club_edge
            data[a:index(x*2+1, y, width*2+1)] = club_edge
        end
    end
    for y=1, 10 do
        for z=1, width do
            data[a:index(25, y, z*2)] = glass
            data[a:index(25, y, z*2+1)] = glass
        end
    end

    data[a:index(player_x, 1, player_z+2)] = computer
    vm:set_data(data)
    vm:write_to_map(true)