--Variables
local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)

--Follow
followlist = {}
backtracklist = {}

local function register_follow(target_name, follower_name)
	if followlist[target_name] == nil then
		followlist[target_name] = {}
	end
	followlist[target_name][follower_name] = true
	backtracklist[follower_name] = target_name
end

-- calculate distance
local get_distance = function(a, b)

	if not a or not b then return 50 end -- nil check

	return vector.distance(a, b)
end

local start_follow = function(t, s)
	register_follow(t, s)
	minetest.chat_send_player(s, "you have started following " .. t)
	minetest.chat_send_player(t, s .. " starts to follow you")
end

minetest.register_globalstep(function(dtime)
	for target_name, follower_list in pairs(followlist) do
		local target = minetest.get_player_by_name(target_name)
		for follower_name, v in pairs(follower_list) do
			local follower = minetest.get_player_by_name(follower_name)
			if follower:get_player_control_bits() ~= 0 then
				if followlist[target_name][follower_name] ~= nil then
					followlist[target_name][follower_name] = nil
				end
				if backtracklist[follower_name] ~= nil then
					backtracklist[follower_name] = nil
				end
				minetest.chat_send_player(target_name, follower_name .. " stop following you")
				minetest.chat_send_player(follower_name, "you have stopped following " .. target_name)
			elseif get_distance(follower:get_pos(), target:get_pos()) > 5 then
				follower:set_pos(target:get_pos())
			end
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	if followlist[player_name] ~= nil and backtracklist[player_name] ~= nil then
		followlist[player_name] = nil
		followlist[backtracklist[player_name]][player_name] = nil
		backtracklist[player_name] = nil
	end
end)

minetest.register_on_rightclickplayer(function(player, clicker)
	local s = clicker:get_player_name()
	local t = player:get_player_name()
	local controls = clicker:get_player_control()
	if get_distance(clicker:get_pos(), player:get_pos()) > web3.settings["distance"] then
		minetest.chat_send_player(s, S("Target too far."))
		return
	end
	minetest.after(0.5, start_follow, t, s)
end)