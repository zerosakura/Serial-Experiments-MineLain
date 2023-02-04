local modpath = minetest.get_modpath("labyrinth")
dofile(modpath .. "/level/3_editable.lua")

local story = 0
function init_level()
    local player = minetest.get_player_by_name("singleplayer")
    safe_clear(10, 10)
    width = 9
    height = 9

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=0,z=0}, {x=height*2,y=10,z=width*2})
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

    minetest.add_item({x=2,y=2,z=2}, "laptop:usbstick")
    vm:set_data(data)
    vm:set_param2_data(param2)
    vm:write_to_map(true)

    draw()
end

function init_story()
    story = 0
    minetest.chat_send_all("博士：嘶....头...好疼")
    minetest.chat_send_all("阿米娅：博士！您还好吗？")
    minetest.chat_send_all("凯尔希：敌人动手了，他们抓住了他动摇的瞬间，开始试图夺走他的记忆，想要把他最有价值的部分永远留在此处。")
    minetest.chat_send_all("阿米娅：怎么这样！凯尔希阿姨，怎么办啊？")
    minetest.chat_send_all("凯尔希：历史是滚动向前的，所有软弱与侥幸都会被命运的洪流所吞没。")
    minetest.chat_send_all("阿米娅：你是在说这里只能前进不能后退吗？")
    minetest.chat_send_all("凯尔希：不，敌人已经发现我们的越狱之旅了，敌人很快就会过来。")
    minetest.chat_send_all("博士：嘶……")
    minetest.chat_send_all("阿米娅：抱歉博士，我们只能加把劲了。快破解这里的代码逃出去吧，故技重施，一定难不倒您的吧？")
    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：尝试修改代码以逃出房间。"))
    story = story+1
end

init_level()
init_story()


