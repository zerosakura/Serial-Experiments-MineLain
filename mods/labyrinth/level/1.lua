local modpath = minetest.get_modpath("labyrinth")
dofile(modpath .. "/level/1_editable.lua")

story = 0

local function init_story() 
    story = 0
    minetest.chat_send_all("阿米娅：博士，博士...")
    minetest.chat_send_all("阿米娅：快醒醒...")
    minetest.chat_send_all("博士：我是谁，我在哪？")
    minetest.chat_send_all("阿米娅：博士，我是阿米娅，你被整合运动抓走了，霜星要拿你做实验 ...")
    minetest.chat_send_all("博士：什么。")
    minetest.chat_send_all("阿米娅：别担心，凯尔西已经黑入了整合运动的系统，看见桌上的 laptop 了吗？")
    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：使用鼠标左键敲击两次，打开桌上的 laptop 并开机。"))
end

function init_level()
    local player = minetest.get_player_by_name("singleplayer")
    safe_clear(10, 10)
    width = 9
    height = 9

    --Copy to the map
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=0,z=0}, {x=height,y=10,z=width})
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
    data[a:index(2, 2, 3)] = computer    
    data[a:index(center_x, 2, width)] = air
    data[a:index(center_x, 1, width)] = door        
    param2[a:index(2, 2, 3)] = minetest.dir_to_facedir({x=-1,y=0,z=0})

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
                    minetest.chat_send_all("阿米娅：做的好，检测到 laptop 已在运行。")
                    minetest.chat_send_all("阿米娅：博士，接下来用鼠标右键进入 laptop 的操作界面。")
                    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：使用鼠标右键，打开处于开机状态的 laptop。"))
                    story = story + 1
                end
                if story == 1 and laptop.os_get({x=2,y=2,z=3}).sysram.current_app == "λim" then
                    minetest.chat_send_all("阿米娅：博士，正如你所见，这些代码控制了关押您的房间。")
                    minetest.chat_send_all("阿米娅：尝试修改代码，使用右上角得 exec 按钮执行。")                    
                    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：进入下一关（提示：运行 λim，修改源代码代码改变密室环境。）"))
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

