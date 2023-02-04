function init_level()
    local player = minetest.get_player_by_name("singleplayer")
    safe_clear(10, 10)
    width = 9
    height = 9

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=0,z=0}, {x=height*2,y=20,z=width*2})
    local data = vm:get_data()
    local param2 = vm:get_param2_data()
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
    local chest = minetest.get_content_id("default:chest")

    --player target coords
    center_x = math.floor((height+1)/2)
    center_z = math.floor((width+1)/2)
    --player:set_pos({x=center_x,y=1.5,z=center_z-3})

    --Set up the level itself        
    for x=1,height do --x
        for z=1,width do --z        
            data[a:index(x, 0, z)] = wall
        end
    end      
    for x=1,height do --x
        for z=1,width do --z        
            data[a:index(x, 15, z)] = wall
        end
    end   
   
 for y=0,8 do
        for z=1,width do
            data[a:index(1, y, z)] = wall
            data[a:index(height, y, z)] = wall
        end
    end
 
   for x=1,height do
        for y=0,8 do
            data[a:index(x, y, 1)] = wall
            data[a:index(x, y, width)] = wall
        end
    end 

    data[a:index(2, 1, 2)] = desk
    data[a:index(2, 1, 3)] = desk  
    -- param2[a:index(center_x-3, 2, center_z-2)] = minetest.dir_to_facedir({x=-1,y=0,z=0})

    data[a:index(center_x, 6, width)] = door
    data[a:index(center_x, 7, width)] = air
    data[a:index(center_x, 16, width)] = chest

    minetest.register_globalstep(
        function(dtime)
            if player then                
                local node = minetest.get_node(player:get_pos())                
                if string.find(node.name, "door") == 1 then
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


