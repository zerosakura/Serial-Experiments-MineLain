local modpath = minetest.get_modpath("labyrinth")
dofile(modpath .. "/level/4_editable.lua")

local story = 0
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
    local ipad = minetest.get_content_id("computers:piepad")
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
    data[a:index(2, 2, 2)] = ipad
    -- param2[a:index(center_x-3, 2, center_z-2)] = minetest.dir_to_facedir({x=-1,y=0,z=0})

    data[a:index(center_x, 1, width)] = door
    data[a:index(center_x, 2, width)] = air

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

function init_story()
    story = 0
    minetest.chat_send_all("凯尔希：这就是命运的最后了，历史沉浮，成王败寇。博士，您会成为怎样的人呢？")
    minetest.chat_send_all("阿米娅：博士...您还好吗？")
    minetest.chat_send_all("博士：......")
    minetest.chat_send_all("凯尔希：敌人也抵达了最期的命运，眼前这座桥，或许是通往自由的天梯，又或许是前往冥土的奈何……生老病死，循环不息，生者死去为新路，新生者亦会蹈复辙。")
    minetest.chat_send_all("阿米娅：博士，坚持住！就差最后一点了...他们要追上来了，博士，博士！")
    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：抵达「门」。"))
end

init_level()


