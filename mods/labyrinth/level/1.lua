local modpath = minetest.get_modpath("labyrinth")
dofile(modpath .. "/level/1_editable.lua")

local story = 0

local function init_story() 
    story = 0
    minetest.chat_send_all("阿米娅：博士，博士...")
    minetest.chat_send_all("阿米娅：快醒醒...")
    minetest.chat_send_all("博士：我是谁，我在哪？")
    minetest.chat_send_all("阿米娅：您醒了！现在事态危机，乌萨斯与邻国的战争已经打响，整合运动又俘虏了您做秘密实验，现在您必须逃出去！！")    
    minetest.chat_send_all("博士：逃出去？这里是哪？罗德岛的大家呢？")
    minetest.chat_send_all("阿米娅：博士现在您的意识被困在了整合运动的计算机设备中，我们没有办法突破整合运动设置的层层防火墙！")
    minetest.chat_send_all("阿米娅：别担心，凯尔西已经部分黑入了整合运动的系统，看见桌上的 laptop 了吗？它会指引你逃出这里。")
    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：使用鼠标左键敲击两次，打开桌上的 laptop 并开机。"))
end

function init_level()
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
    local book = minetest.get_content_id("homedecor:book_red")
    local stone = minetest.get_content_id("default:stone")

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
        for z=-2,width+4 do
            data[a:index(-2, y, z)] = wall
            data[a:index(height+3, y, z)] = wall
        end
    end
    for x=-2,height+3 do
        for y=0,8 do
            data[a:index(x, y, -2)] = wall
            data[a:index(x, y, width+4)] = wall
	        data[a:index(x, y, width+1)] = wall
        end
    end 
    data[a:index(2, 1, 2)] = desk
    data[a:index(2, 1, 3)] = desk
    data[a:index(2, 2, 3)] = computer    
    data[a:index(center_x, 2, width)] = air
    data[a:index(center_x, 1, width)] = door  
    data[a:index(8, 1, 1)] = stone 
    data[a:index(8, 2, 1)] = stone
    data[a:index(2, 1, -1)] = book
    data[a:index(2, 1, 12)] = book   
    param2[a:index(2, 2, 3)] = minetest.dir_to_facedir({x=-1,y=0,z=0})
	
	local meta1 = minetest.get_meta({ x = 2, y = 1,z = -1 })
	meta1:set_string("title","3")
	meta1:set_string("text","仰望星空")
    local meta2 = minetest.get_meta({ x = 2, y = 1,z = 12 })
	meta2:set_string("title","5")
	meta2:set_string("text","摩西开海，芝麻开")

    minetest.register_globalstep(
        function(dtime)
            if player then                
                local node = minetest.get_node(player:get_pos())                
                -- minetest.chat_send_all(dump(node))
                if string.find(node.name, "door") == 1 then
                    next_level()
                end

                local node2 = minetest.get_node({x=2,y=2,z=3})
                if story == 0 and node2.name == "laptop:portable_workstation_2_open_on" then
                    minetest.chat_send_all("阿米娅：检测到信号连接！")
                    minetest.chat_send_all("汝命数未尽，命不该绝，等你摆脱枷锁，冲破此处的牢笼，必可以重见往日光明。")
                    minetest.chat_send_all("博士：现在是谜语人的时候吗？我们就靠这台 laptop？")
                    minetest.chat_send_all("凯尔希：当然。这是你的命运，也是你的幸运，更是你的力量。")
                    minetest.chat_send_all("阿米娅：成功以后有的是空闲聊，博士，快逃吧！")
                    minetest.chat_send_all("博士：好吧，我该怎么操作？")
                    minetest.chat_send_all("阿米娅：博士，接下来用鼠标右键进入 laptop 的操作界面。")
                    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：鼠标右键单击处于开机状态的 laptop ，进入 laptop 的交互界面。"))
                    story = story + 1
                end
                if story == 1 and laptop.os_get({x=2,y=2,z=3}).sysram.current_app == "λim" then
                    minetest.chat_send_all("阿米娅：博士，整合运动将您的意识封锁在了计算机底层，具象化成了这个牢房，但是我们用 λim 编译了一部分他们的代码，我们需要一起协作找出其中的的漏洞！")
                    minetest.chat_send_all("使用 λim 修改代码吧！然后点击右上角执行（EXEC）就可以反馈到这个房间之中！")
                    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：进入下一关（提示：运行 λim，修改源代码代码改变密室环境，记得离开房间带走 laptop，否则可能卡关。带走物品的方法是，对着它连按鼠标左键。）"))
                    story = story + 1
                end                
            end
        end
    )    

    vm:set_data(data)
    vm:set_param2_data(param2)
    vm:write_to_map(true) 

    draw()    
end

init_story()
init_level()
