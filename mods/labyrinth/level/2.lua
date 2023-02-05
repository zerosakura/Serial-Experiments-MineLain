local modpath = minetest.get_modpath("labyrinth")
dofile(modpath .. "/level/2_editable.lua")

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
    local book = minetest.get_content_id("homedecor:book_red")

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
    data[a:index(2, 2, 3)] = book    
    data[a:index(center_x, 2, width)] = air
    data[a:index(center_x, 1, width)] = door        
    param2[a:index(2, 2, 3)] = minetest.dir_to_facedir({x=1,y=0,z=0})

    local meta = minetest.get_meta({ x = 2, y = 2, z = 3 })
    
    meta:set_string("title", "RM-100")
    meta:set_string("text", "本手册是关于RM-100计算机所搭载的特殊精神分析系统使用手册。本系统能利用微弱电流对大脑前额叶周边周边意识脑区进行刺激，使被分析者的意识进入被设定好幻境之中。再通过读取被分析者在幻境中活动所产生的生物电流及脑电波对被分析者的记忆及意识进行深度读取。被分析者在受试过程中可能会产生记忆混乱等症状。但当被分析者对幻境进行修改时，会产生自系统底层发生的混乱，可能会导致分析系统产生漏洞。")

    minetest.register_globalstep(
        function(dtime)
            if player then                
                local node = minetest.get_node(player:get_pos())                
                -- minetest.chat_send_all(dump(node))
                if string.find(node.name, "door") == 1 then
                    next_level()
                end      

                local node2 = minetest.get_node({x=2,y=2,z=3})
                if story == 0 and node2.name == "homedecor:book_open_red" then
                    minetest.chat_send_all("阿米娅：嗯...书上好像记录了底层系统的某个操控方法，好像还有一些文字。（PS：这个文字我想放博士会被读取记忆的相关内容，这个我后面分一个文档写）。")
                    minetest.chat_send_all("凯尔希：既不可创生，又不可死去，只能重建新的秩序了吗？")
                    minetest.chat_send_all("阿米娅：博士，试着修改代码移动场景内的物品吧。")                    
                    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：修改源代码以逃出房间。"))
                    story = story + 1
                end
            end
        end
    )    

    vm:set_data(data)
    vm:set_param2_data(param2)
    vm:write_to_map(true)

    draw()
    if (not verify()) then
        minetest.chat_send_all("Error!")
        minetest.chat_send_all("Check failed! ")
        go_level(level.."_editable")
        go_level(level)
    end
end

local function init_story() 
    story = 0
    minetest.chat_send_all("博士：怎么回事？我们又回到了这个房间。")
    minetest.chat_send_all("阿米娅：（果然整合运动对系统底层的加密不止一层。）")
    minetest.chat_send_all("阿米娅：博士，我们得继续前进了。")
    minetest.chat_send_all("阿米娅：那边的桌子上好像有一本书，打开看看吧。")    
    minetest.chat_send_all(minetest.colorize("#ffff22", "任务更新：查看桌上的神秘书本。"))
end

init_level()
init_story()




