local modpath = minetest.get_modpath("labyrinth")
dofile(modpath .. "/level/4_editable.lua")

function init_level()
    local player = minetest.get_player_by_name("singleplayer")
    safe_clear(31, 31)
    width = 31
    height = 9

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=-50,z=0}, {x=height*2,y=50,z=width*2})
    local data = vm:get_data()
    local param2 = vm:get_param2_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local wall = minetest.get_content_id("default:silver_sandstone_block")
    local air = minetest.get_content_id("air")
    local door = minetest.get_content_id("doors:door_steel_a")
    local desk = minetest.get_content_id("homedecor:table_mahogany")

    --player target coords
    center_x = math.floor((height+1)/2)
    center_z = math.floor((width+1)/2)

    --Set up the level itself        
    for x=1,height do --x
        for z=1,width do --z 
            for y=-4,0,1 do
                data[a:index(x, y, z)] = wall
            end
        end
    end        
    for y=-4,8,1 do
        for z=1,width do
            data[a:index(1, y, z)] = wall
            data[a:index(height, y, z)] = wall
        end
    end
    for x=1,height do
        for y=-4,8,1 do
            data[a:index(x, y, 1)] = wall
            data[a:index(x, y, width)] = wall
        end
    end 

    for x=2,height-1 do
        for z=2,width-1 do
            for y=-3,0 do
                if((z<center_z+13)and(z>center_z-13)) then
                    data[a:index(x, y, z)] = air
                end
            end
        end
    end

    data[a:index(2, 1, 2)] = desk
    data[a:index(2, 1, 3)] = desk    
    -- param2[a:index(center_x-3, 2, center_z-2)] = minetest.dir_to_facedir({x=-1,y=0,z=0})

    data[a:index(center_x, 1, 5)] = wall
    data[a:index(center_x, 1, 8)] = wall
    data[a:index(center_x, 1, width)] = door
    data[a:index(center_x, 2, width)] = air

    minetest.register_globalstep(
        function(dtime)
            if player then                
                local node = minetest.get_node(player:get_pos())                
                if node.name == "doors:door_steel_a" then
                    next_level()
                end                
            end
        end
    )    

    vm:set_data(data)
    vm:set_param2_data(param2)
    vm:write_to_map(true)

    draw()
end

init_level()


