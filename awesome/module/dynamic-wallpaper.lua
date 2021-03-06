----------------------------------------------------------------------------
--- Wallpaper changer module
--
-- @author Gerome Matilla &lt;gerome.matilla07@gmail.com&gt;
-- @copyright 2019 Gerome Matilla
-- @module wallchange
--
--- Nevermind this. Do what you want.
----------------------------------------------------------------------------

-- This module changes wallpaper based on declared time
-- It checks the difference between the current time and the next scheduled time
-- Then convert it to seconds to set it as a timeout value

-- Limitations: 
-- Timeout paused when laptop/pc is suspended or in sleep mode, and there's probably some bugs too so whatever

local awful = require('awful')
local filesystem = require('gears.filesystem')
local gears = require('gears')
local beautiful = require('beautiful')


--  ========================================
-- 				Configuration
--	     Change your preference here
--  ========================================

-- Wallpaper directory. The default is:
local wall_dir = filesystem.get_configuration_dir() .. 'theme/wallpapers/'
-- local wall_dir = os.getenv('HOME') .. 'Pictures/Wallpapers/'


-- Wallpapers filename
-- Note:
-- Default image format is jpg
wallpaper_morning = 'arthas_3.jpg'
wallpaper_noon = 'tirion.jpg'
wallpaper_night = 'tirion_vs_lich.jpg'
wallpaper_midnight = 'tirion_lich.jpg'


-- Change the wallpaper on scheduled time
morning_schedule = '06:22:00'
noon_schedule = '12:00:00'
night_schedule = '17:58:00'
midnight_schedule = '22:00:00'


-- Update lockscreen background
local update_ls_bg = false

-- Update lockscreen background command
local update_ls_cmd = 'mantablockscreen --image'



--  ========================================
-- 				   Processes
--	    Don't touch it if it's working
--  ========================================


-- Get current time
local current_time = function()
  	return os.date("%H:%M:%S")
end


-- Countdown variable
-- In seconds
the_countdown = nil


-- We will use an array for hour change and wallpaper string
-- Element 0 errm 1 will store the incoming/next scheduled time
-- Geez why the f is lua's array starts with `1`? lol
-- Element 2 will have the wallpaper file name
local wall_data = {}
-- > Why array, you say? 
-- Because why not? I'm new to lua and I'm experimenting with it


-- Parse HH:MM:SS to seconds
local parse_to_seconds = function(time)

  	-- Convert HH in HH:MM:SS
  	hour_sec = tonumber(string.sub(time, 1, 2)) * 3600

  	-- Convert MM in HH:MM:SS
  	min_sec = tonumber(string.sub(time, 4, 5)) * 60

	-- Get SS in HH:MM:SS
	get_sec = tonumber(string.sub(time, 7, 8))

	-- Return computed seconds
    return (hour_sec + min_sec + get_sec)

end


-- Get time difference
local time_diff = function(current, schedule)
	local diff = parse_to_seconds(current) - parse_to_seconds(schedule)
	return diff
end


-- Update wallpaper (used by the manage_timer function)
-- I think the gears.wallpaper.maximized is too fast or being ran asynchronously
-- So the wallpaper is not being updated on awesome (re)start without this timer
-- We need some delay.
-- Hey it's working, so whatever
local update_wallpaper = function(wall_name)
	gears.timer.start_new(0, function()

		local wall_dir = wall_dir .. wall_name

		gears.wallpaper.maximized (wall_dir, s)

		-- Overwrite the default wallpaper
		-- This is important in case we add an extra monitor
		beautiful.wallpaper = wall_dir

		if update_ls_bg then
			awful.spawn.easy_async_with_shell(update_ls_cmd .. ' ' .. wall_dir, function() 
				--
			end)
		end
	end)
end

-- Updates variables
local manage_timer = function()

	-- Get current time
	local time_now = parse_to_seconds(current_time())

	-- Parse the schedules to seconds
	local parsed_morning = parse_to_seconds(morning_schedule)
	local parsed_noon = parse_to_seconds(noon_schedule)
	local parsed_night = parse_to_seconds(night_schedule)
	local parsed_midnight = parse_to_seconds('00:00:00')

	-- Note that we will use '00:00:00' instead of '24:00:00' as midnight
	-- As the latter causes an error. The time_diff() returns a negative value

	if time_now >= parsed_midnight and time_now < parsed_morning then
		-- Midnight time

		-- Update Wallpaper
		update_wallpaper(wallpaper_midnight)

		-- Set the data for the next scheduled time
		wall_data = {morning_schedule, wallpaper_morning}

	elseif time_now >= parsed_morning and time_now < parsed_noon then
		-- Morning time

		-- Update Wallpaper
		update_wallpaper(wallpaper_morning)

		-- Set the data for the next scheduled time
		wall_data = {noon_schedule, wallpaper_noon}

	elseif time_now >= parsed_noon and time_now < parsed_night then
		-- Noon time

		-- Update Wallpaper
		update_wallpaper(wallpaper_noon)

		-- Set the data for the next scheduled time
		wall_data = {night_schedule, wallpaper_night}

	else
		-- Night time

		-- Update Wallpaper
		update_wallpaper(wallpaper_night)

		-- Set the data for the next scheduled time
		wall_data = {midnight_schedule, wallpaper_midnight}

	end
  
	
	-- Get the time difference to set as timeout for the wall_updater timer below
	the_countdown = time_diff(wall_data[1], current_time())

end

-- Update values at startup
manage_timer()



local wall_updater = gears.timer {
	-- The timeout is the difference of current time and the scheduled time we set above.
	timeout   = the_countdown,
	autostart = true,
	call_now = true,
	callback  = function()

		-- Emit signal to update wallpaper
    	awesome.emit_signal("module::change_wallpaper")
  	
  	end
}

-- Update wallpaper here and update the timeout for the next schedule
awesome.connect_signal("module::change_wallpaper", function()

	-- Update wallpaper based on the data in the array
	gears.wallpaper.maximized (wall_dir .. wall_data[2], s)

	-- Update values for the next specified schedule
	manage_timer()

	-- Update timer timeout for the next specified schedule
	wall_updater.timeout = the_countdown

	-- Restart timer
	wall_updater:again()

end)