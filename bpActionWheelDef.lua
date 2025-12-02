-- List of actions
local blank = action_wheel:newAction()
	:hoverColor(0,0,0)
	:color(0,0,0)

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
local action1 = action_wheel:newAction():item("iron_ingot")
local action2 = action_wheel:newAction():item("gold_ingot")
local action3 = action_wheel:newAction():item("netherite_ingot")
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
	name = "Main",
	params = {}, -- leave this blank for the home page
	contains = {
		},
	}
}

-- Actually constructs the menu system
require("boilerplate")
bpas = bpactions:build(mainMenu)
