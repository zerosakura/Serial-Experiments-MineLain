story = 0

local function init_level()
    local player = minetest.get_player_by_name("singleplayer")
    safe_clear(20, 20)
    width = 9
    height = 9

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=-5,y=-5,z=-5}, {x=height+5,y=15,z=width+5})
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

    minetest.set_timeofday(0.2)
    --player target coords
    center_x = math.floor((height+1)/2)
    center_z = math.floor((width+1)/2)

    --Set up the level itself        
    for x=-3,height+3 do --x
        for z=-3,width+3 do --z        
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
 for y=0,8 do
        for z=-2,width do
            data[a:index(-2, y, z)] = wall
            data[a:index(height+3, y, z)] = wall
        end
    end
    for x=-2,height+3 do
        for y=0,8 do
            data[a:index(x, y, -2)] = wall
            data[a:index(x, y, width)] = wall
        end
    end 
    data[a:index(2, 1, 2)] = desk
    data[a:index(2, 1, 3)] = desk
    data[a:index(2, 2, 3)] = computer    
    data[a:index(center_x, 2, width)] = air
    data[a:index(center_x, 1, width)] = door        
    param2[a:index(2, 2, 3)] = minetest.dir_to_facedir({x=-1,y=0,z=0})


    for y=1,3 do
        for x=2,height-1 do
            data[a:index(x, y, center_z)] = glass
        end
    end

    minetest.register_globalstep(
        function(dtime)
            if player then                
                local node = minetest.get_node(player:get_pos())                
                -- minetest.chat_send_all(dump(node))
                if node.name == "doors:door_steel_a" then
                    next_level()
                end

                local node2 = minetest.get_node({x=2,y=2,z=3})
                if story == 0 and node2.name == "laptop:portable_workstation_2_open_on" then
                    minetest.chat_send_all("阿米娅：网络连上了！")
	    minetest.chat_send_all("凯尔希：你终于在跌落谷底之前重获新生……")
	minetest.chat_send_all("阿米娅：凯尔希阿姨！")
	 minetest.chat_send_all("凯尔希：所幸，汝命数未尽，命不该绝。等你摆脱枷锁，冲破牢笼，必可以重建光明。")
	 minetest.chat_send_all("博士：就靠这台电脑？")
	 minetest.chat_send_all("凯尔希：当然……非也，一生二，二生四。")
	minetest.chat_send_all("阿米娅：你俩以后有的是空，博士，快")
                    minetest.chat_send_all("阿米娅：博士，接下来用鼠标右键进入 laptop 的操作界面。")
                    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：使用鼠标右键，打开处于开机状态的 laptop。"))
                    story = story + 1
                end


            end
        end
    )    

    vm:set_data(data)
    vm:set_param2_data(param2)
    vm:write_to_map(true) 
end

local function init_story() 
    minetest.chat_send_all("阿米娅：博士，博士...")
    minetest.chat_send_all("阿米娅：快醒醒...")
    minetest.chat_send_all("博士：我是谁，我在哪？之前我……")
    minetest.chat_send_all("阿米娅：您醒了！快逃出来吧！")
    minetest.chat_send_all("博士：到底发生了什么事情！")
    minetest.chat_send_all("阿米娅：说来话长，您不幸落到了整合运动的人的手里，！我们冲不进您的保护圈。您现在只能自救了。")
    minetest.chat_send_all("博士：可恶，那个看报纸的摸鱼怪！你说自救，我怎么个救法？")
    minetest.chat_send_all("阿米娅：我们进不去，您就自己出来咯？")
   minetest.chat_send_all("博士：我是博士，又不是武士！")
    minetest.chat_send_all("阿米娅：别担心，关押你的监狱用上了最先进的的数控系统，连一块地板，一块瓷砖都受这个系统的监视，我一定会让您平安归队的！")	
   minetest.chat_send_all("博士：呵，可都是好消息。")
    minetest.chat_send_all("阿米娅：别担心，凯尔西已经黑入了整合运动的系统，看见桌上的 laptop 了吗？")
    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：使用鼠标左键敲击两次，打开桌上的 laptop 并开机。"))
end

init_level()
init_story()


