-- List of actions
local blank = action_wheel:newAction()
	:hoverColor(0,0,0)
	:color(0,0,0)

local homeButton = action_wheel:newAction()
	:title("Home")
	:item("red_bed")
	:hoverColor(1,1,1)
	:onLeftClick(function() action_wheel:setPage("Main") end)

local inkAction = action_wheel:newAction()
	:title(toJson({
		{text = "INK!\n\n", bold = true, italic = true, color = "red"},
		{text = "Cannot ink outside of water.\n\n", bold = false, color = "white"},
		{text = "Alternatively, right click while\nholding an ink sac.", bold = false, color = "gray"}
	}))
	:item("ink_sac")
	:hoverColor(vectors.hexToRGB("ff5e00"))
	:onLeftClick(function() pings.inkItUp() end)

local bloopaAction = action_wheel:newAction()
	:title(toJson({
		{text = "Bloopa!", italic = true, color = "aqua"},
	}))
	:item("water_bucket")
	:hoverColor(0,1,1)
	:onLeftClick(function() pings.bloopa() end)

local changeSquidAction = action_wheel:newAction()
	:title(toJson({
		{text = "Bloopa Appearance", italic = true, color = "aqua"},
	}))
	:item("squid_spawn_egg")
	:toggleItem("glow_squid_spawn_egg")
	:color(vectors.hexToRGB("21497B"))
	:toggleColor(vectors.hexToRGB("119F36"))
	:onToggle(pings.setBloopaTexture)
	:toggled(config:load("GlowBloopa"))

local changeWhirlpoolAction = action_wheel:newAction()
	:title(toJson({
		{text = "Toggle Bubbles", italic = true, color = "blue"},
	}))
	:item("soul_sand")
	:toggleItem("magma_block")
	:color(vectors.hexToRGB("573724"))
	:toggleColor(vectors.hexToRGB("15a5d1"))
	:onToggle(pings.setWhirlpoolBubbles)
	:toggled(config:load("WhirlpoolBubbles"))

local singAction = action_wheel:newAction()
	:title(toJson({
			{text = "Play Singing animation", bold = true, color = "blue"}
	}))
	:item("music_disc_blocks")
	:toggleItem("music_disc_cat")
	:onToggle(pings.sing)

--[[	Menu structure
		Uses a heirarchy system similar to JSON to automatically construct a menu system.

	name: Optional, just used internally for the actionwheel page title.
	params: Parameters for the action that is used to navigate to the page. Most are optional.
		[*]Since the home page has no parent action, the parameters for it should be left blank.
	contains: Actions/more pages inside the page
		[*]You can number the entries if you like, otherwise they should be unnamed. 
		Actions are slotted in counterclockwise from top left, in the order they're numbered.
		contains = {[1] = action1} 	is fine
		contains = {action1}		is fine
		contains = {act1 = action1}	is not fine

example:
node = {
	name = "homepage",
	params = {}, -- leave this blank for the home page
	contains = {
		[1] = action1, 
		[2] = {
			name = "subpage1",
			params = {
				title = "page1title", 
				item = "dirt",
				hoverItem = "grass_block",
				color = vec(0,0,0),
				hoverColor = vec(1,1,1)
			},
			contains = {action2, action3}
		}
	}
}

]]--

local mainMenu = {
	name = "Homepage",
	params = {}, -- leave this blank for the home page
	contains = {
		inkAction,
		bloopaAction,
		{
			name = "Settings Page",
			params = {
				title = toJson({
					{text = "Settings", italic = true, color = "blue"},
				}),
				item = "comparator", 
				hoverColor = vectors.hexToRGB("5555FF")
			},
			contains = { 
				blank, changeWhirlpoolAction, changeSquidAction
			}
		}, 
		{
			name = "Animations Page",
			params = {
				title = toJson({
					{text = "Animations", italic = true, color = "dark_green"},
				}), 
				item = "armor_stand", 
				hoverColor = vectors.hexToRGB("47A036")
			},
			contains = {blank, singAction}
		},
	}
}

-- Actually constructs the menu system
bpas = bpactions:build(mainMenu)