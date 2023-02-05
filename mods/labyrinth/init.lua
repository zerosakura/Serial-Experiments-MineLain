-- ██╗      █████╗ ██████╗ ██╗   ██╗██████╗ ██╗███╗   ██╗████████╗██╗  ██╗
-- ██║     ██╔══██╗██╔══██╗╚██╗ ██╔╝██╔══██╗██║████╗  ██║╚══██╔══╝██║  ██║
-- ██║     ███████║██████╔╝ ╚████╔╝ ██████╔╝██║██╔██╗ ██║   ██║   ███████║
-- ██║     ██╔══██║██╔══██╗  ╚██╔╝  ██╔══██╗██║██║╚██╗██║   ██║   ██╔══██║
-- ███████╗██║  ██║██████╔╝   ██║   ██║  ██║██║██║ ╚████║   ██║   ██║  ██║
-- ╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
-- Ascii art font: ANSI Shadow, All acii art from patorjk.com/software/taag/
--
-- The code for labyrinth is licensed as follows:
-- MIT License, ExeVirus (c) 2021
--
-- Please see the LICENSE file for texture licenses


--Settings Changes --
--BE VERY CAREFUL WHEN PLAYING WITH OTHER PEOPLES SETTINGS--
--minetest.settings:set("enable_damage","false")
--[[
local max_block_send_distance = minetest.settings:get("max_block_send_distance")
local block_send_optimize_distance = minetest.settings:get("block_send_optimize_distance")
if max_block_send_distance == 31 then -- no one would set these to 31, so it must have been a crash,
    max_block_send_distance = 8       -- and we should revert to defaults on proper shutdown
end
if block_send_optimize_distance == 31 then
    block_send_optimize_distance = 4
end
minetest.settings:set("max_block_send_distance","30")
minetest.settings:set("block_send_optimize_distance","30")
minetest.register_on_shutdown(function()
    minetest.settings:set("max_block_send_distance",tostring(max_block_send_distance))
    minetest.settings:set("block_send_optimize_distance",tostring(block_send_optimize_distance))
end)
--]]
--End Settings Changes--

--Load our Settings--
local function handleColor(settingtypes_name, default)
    return minetest.settings:get(settingtypes_name) or default
end
local primary_c              = handleColor("laby_primary_c",              "#06EF")
local hover_primary_c        = handleColor("laby_hover_primary_c",        "#79B1FD")
local on_primary_c           = handleColor("laby_on_primary_c",           "#FFFF")
local secondary_c            = handleColor("laby_secondary_c",            "#FFFF")
local hover_secondary_c      = handleColor("laby_hover_secondary_c",      "#AAAF")
local on_secondary_c         = handleColor("laby_on_secondary_c",         "#000F")
local background_primary_c   = handleColor("laby_background_primary_c",   "#F0F0F0FF")
local background_secondary_c = handleColor("laby_background_secondary_c", "#D0D0D0FF")
--End Settings Load

local modpath = minetest.get_modpath("labyrinth")


-- Set mapgen to singlenode if not already

minetest.set_mapgen_params('mgname', 'singlenode', true)


-- Compatibility aliases

for _, node in ipairs({
	"inv",
	"cave_ground", "cave_torch", "cave_rock",
	"classic_ground", "classic_wall",
	"club_walkway", "club_wall", "club_ceiling", "club_edge", "club_light", "club_ground",
	"glass_glass",
	"grassy_dirt", "grassy_hedge", "grassy_grass",
}) do
	minetest.register_alias("game:" .. node, "labyrinth:" .. node)
end


--Style registrations

local numStyles = 0
local styles = {}
local music = nil

--Common node between styles, used for hidden floor to fall onto
minetest.register_node("labyrinth:inv",
{
  description = "Ground Block",
  drawtype = "airlike",
  tiles = {"blank.png"},
  light_source = 11,
})

--Style Registrations
dofile(modpath .. "/message.lua")
dofile(modpath .. "/setup.lua")

function safe_clear(w, l)
    local vm         = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map({x=0,y=0,z=0}, {x=w,y=10,z=l})
    local data = vm:get_data()
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local air = minetest.get_content_id("air")
    
    for x=0,w do
        for y=-10,10 do
            for z=0,l do   
                local node = minetest.get_node({x=x,y=y,z=z})
                -- minetest.chat_send_all(dump(node))
                if string.find(node.name,"laptop") ~= 1 then         
                    data[a:index(x, y, z)] = air
                end
            end
        end
    end
    vm:set_data(data)
    vm:write_to_map(true)
end

minetest.register_chatcommand("init", {	
    func = function()        
        this_level()
    end,
})

minetest.register_chatcommand("go", {	
    func = function(target_level)
        level = target_level
        this_level()
    end,
})

minetest.register_chatcommand("go", {
    params = "<int>",
    func = function(_, target)    
        level = target or level
        this_level()
    end,
})

minetest.register_on_joinplayer(
    function(player)
        safe_clear(300, 300)        
        minetest.set_timeofday(0.2)
        skins.set_player_skin(player, "character_arknights_doctor")
        this_level()
    end
)