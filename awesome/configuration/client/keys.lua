local awful = require('awful')
local gears = require('gears')
local helpers = require('helpers')
require('awful.autofocus')

local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey
local dpi = require('beautiful').xresources.apply_dpi

local clientKeys =
	awful.util.table.join(

	-- Default client focus
    awful.key({ altkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ altkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),


        -- By direction client focus with arrows
        awful.key({modkey }, "Down",
            function()
                awful.client.focus.global_bydirection("down")
                if client.focus then client.focus:raise() end
            end,
            {description = "focus down", group = "client"}),
        awful.key({modkey }, "Up",
            function()
                awful.client.focus.global_bydirection("up")
                if client.focus then client.focus:raise() end
            end,
            {description = "focus up", group = "client"}),
        awful.key({ modkey }, "Left",
            function()
                awful.client.focus.global_bydirection("left")
                if client.focus then client.focus:raise() end
            end,
            {description = "focus left", group = "client"}),
        awful.key({ modkey }, "Right",
            function()
                awful.client.focus.global_bydirection("right")
                if client.focus then client.focus:raise() end
            end,
            {description = "focus right", group = "client"}),



    

    -- Layout manipulation

awful.key({ modkey, 'Shift' }, "Down", function (c)
	helpers.move_client_dwim(c, "down")
end),
awful.key({ modkey, 'Shift' }, "Up", function (c)
	helpers.move_client_dwim(c, "up")
end),
awful.key({ modkey, 'Shift' }, "Left", function (c)
	helpers.move_client_dwim(c, "left")
end),
awful.key({ modkey, 'Shift' }, "Right", function (c)
	helpers.move_client_dwim(c, "right")
end),
awful.key({ modkey, 'Shift' }, "j", function (c)
	helpers.move_client_dwim(c, "down")
end),
awful.key({ modkey, 'Shift' }, "k", function (c)
	helpers.move_client_dwim(c, "up")
end),
awful.key({ modkey, 'Shift' }, "h", function (c)
	helpers.move_client_dwim(c, "left")
end),
awful.key({ modkey, 'Shift' }, "l", function (c)
	helpers.move_client_dwim(c, "right")
end),
    awful.key({ modkey }, ".", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey }, ",", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ altkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),


	-- toggle fullscreen
	awful.key(
		{modkey},
		'f',
		function(c)
			-- Toggle fullscreen
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = 'toggle fullscreen', group = 'client'}
	),

	-- close client
	awful.key(
		{modkey},
		'q',
		function(c)
			c:kill()
		end,
		{description = 'close', group = 'client'}
	),
	   -- Resize focused client or layout factor
	   awful.key({ modkey, 'Control'}, "Down", function (c)
        helpers.resize_dwim(client.focus, "down")
    end),
    awful.key({ modkey, 'Control'}, "Up", function (c)
        helpers.resize_dwim(client.focus, "up")
    end),
    awful.key({ modkey, 'Control'}, "Left", function (c)
        helpers.resize_dwim(client.focus, "left")
    end),
    awful.key({ modkey, 'Control'}, "Right", function (c)
        helpers.resize_dwim(client.focus, "right")
    end),
    awful.key({ modkey, 'Control'}, "j", function (c)
        helpers.resize_dwim(client.focus, "down")
    end),
    awful.key({ modkey, 'Control'}, "k", function (c)
        helpers.resize_dwim(client.focus, "up")
    end),
    awful.key({ modkey, 'Control'}, "h", function (c)
        helpers.resize_dwim(client.focus, "left")
    end),
    awful.key({ modkey, 'Control'}, "l", function (c)
        helpers.resize_dwim(client.focus, "right")
	end),
	-- No need for these (single screen setup)
    awful.key({ modkey}, "i", function () awful.screen.focus_relative( 1) end,
    {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey}, "u", function () awful.screen.focus_relative(-1) end,
    {description = "focus the previous screen", group = "screen"}),

	-- Default client focus
	awful.key(
		{altkey},
		'Tab',
		function()
			awful.client.focus.byidx(1)
		end,
		{description = 'focus next by index', group = 'client'}
	),
	awful.key(
		{modkey},
		'a',
		function()
			awful.client.focus.byidx(-1)
		end,
		{description = 'focus previous by index', group = 'client'}
	),
	awful.key(
		{ modkey, "Shift"  },
		"d",
		function ()
			awful.client.swap.byidx(1)
		end,
		{description = "swap with next client by index", group = "client"}
	),
	awful.key(
		{ modkey, "Shift" },
		"a",
		function ()
			awful.client.swap.byidx(-1)
		end,
		{description = "swap with next client by index", group = "client"}
	),

	awful.key(
		{modkey},
		'u',
		awful.client.urgent.jumpto,
		{description = 'jump to urgent client', group = 'client'}
	),
	awful.key(
		{modkey},
		'z',
		function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{description = 'go back', group = 'client'}
	),
    awful.key(
        {modkey},
        'n',
        function(c)
            c.minimized = true
        end,
        {description = "minimize client", group = 'client'}
    ),
	-- move floating client to center
	awful.key(
		{ modkey, "Shift" },
		"c",
		function(c)
			local focused = awful.screen.focused()

			awful.placement.centered(c, {
				honor_workarea = true
			})
		end,
		{description = 'align a client to the center of the focused screen.', group = "client"}
	),
	awful.key({ modkey }, "d",
	function()
		awful.spawn.with_shell("rofi -matching fuzzy -show combi")
	end,
	{description = "rofi launcher", group = "launcher"}),


	-- Set master
    awful.key({ modkey, 'Control'}, "Return", function (c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "client"}),


	-- Increasing floating client size
		awful.key(
			{modkey, 'Shift'},
			'Up',
			function(c)
				if c.floating then
					c:relative_move(0, dpi(-10), 0, dpi(10))
				end
			end,
			{description = 'increase floating client size vertically by 10 px up', group = 'client'}
		),
		awful.key(
			{modkey, 'Shift'},
			'Down',
			function(c)
				if c.floating then
					c:relative_move(0, 0, 0, dpi(10))
				end
			end,
			{description = 'increase floating client size vertically by 10 px down', group = 'client'}
		),
		awful.key(
			{modkey, 'Shift'},
			'Left',
			function(c)
				if c.floating then
					c:relative_move(dpi(-10), 0, dpi(10), 0)
				end
			end,
			{description = 'increase floating client size horizontally by 10 px left', group = 'client'}
		),
		awful.key(
			{modkey, 'Shift'},
			'Right',
			function(c)
				if c.floating then
					c:relative_move(0, 0, dpi(10), 0)
				end
			end,
			{description = 'increase floating client size horizontally by 10 px right', group = 'client'}
		),

		-- Decreasing floating client size
		awful.key(
			{modkey, 'Control'},
			'Up',
			function(c)
				if c.floating and c.height > 10 then
					c:relative_move(0, 0, 0, dpi(-10))
				end
			end,
			{description = 'decrease floating client size vertically by 10 px up', group = 'client'}
		),
		awful.key(
			{modkey, 'Control'},
			'Down',
			function(c)
				if c.floating then
					local c_height = c.height
					c:relative_move(0, 0, 0, dpi(-10))
					if c.height ~= c_height and c.height > 10 then
						c:relative_move(0, dpi(10), 0, 0)
					end
				end
			end,
			{description = 'decrease floating client size vertically by 10 px down', group = 'client'}
		),
		awful.key(
			{modkey, 'Control'},
			'Left',
			function(c)
				if c.floating and c.width > 10 then
					c:relative_move(0, 0, dpi(-10), 0)
				end
			end,
			{description = 'decrease floating client size horizontally by 10 px left', group = 'client'}
		),
		awful.key(
			{modkey, 'Control'},
			'Right',
			function(c)
				if c.floating then
					local c_width = c.width
					c:relative_move(0, 0, dpi(-10), 0)
					if c.width ~= c_width and c.width > 10 then
						c:relative_move(dpi(10), 0 , 0, 0)
					end
				end
			end,
			{description = 'decrease floating client size horizontally by 10 px right', group = 'client'}
		)

	)

	return clientKeys
