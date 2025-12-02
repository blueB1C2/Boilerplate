bpactions = {}
bpactions.__index = bpactions

function bpactions:build(structure, menu) -- structure is the table, menu is for recursive calling
	self = setmetatable({}, bpactions)
	self.menu = menu or bpactions.menu:new("Main") -- creates new menu/sub-menu

	local childMenu = self.menu:addChildPage(structure)
	
	if structure.contains == nil then return end -- end of the tree branch
	for i = 1, #structure.contains do -- iterates through what the node contains
		local subStruct = structure.contains[i]
		if type(subStruct) == "Action" then
			childMenu:addAction(subStruct) -- handles actions
		else
			bpactions:build(subStruct, childMenu) -- recursive call to go deeper in the tree
		end
	end
	
	action_wheel:setPage(self.menu.page) -- at the end of execution this will end up being the main page
	return self
end

bpactions.menu = {}
bpactions.menu.__index = bpactions.menu
function bpactions.menu:new(name)
	self = setmetatable({}, bpactions.menu)
	self.name = name
	self.page = action_wheel:newPage(name)
	action_wheel:setPage(self.page)
	self.parent = {}
	self.children = {}

	function self:addChildPage(struct) -- adds a child page (sub-menu) to this page
		local params = struct.params 	-- extracts params from the table entry
		if params == nil or next(params) == nil then return self end -- detects if node is main node
		local page = bpactions.menu:new(struct.name or params.title) -- creates new sub-menu page
		table.insert(self.children, page)	-- adds new page to a list of its children
		page.parent = self

		local goToPage = action_wheel:newAction() -- action for navigating to the new child page
			:title(params.title or "Title T") -- AGGA
			:item(params.item or nil)
			:hoverItem(params.hoverItem or params.item or nil)
			:color(params.color or vec(0,0,0))
			:hoverColor(params.hoverColor)
			:onLeftClick(function() action_wheel:setPage(page.page) end)
		local goBack = action_wheel:newAction() -- back button on child page
			:title("Back")
			:item("minecraft:barrier")
			:color(1,0,0)
			:hoverColor(1,1,1)
			:onLeftClick(function() action_wheel:setPage(self.page) end)

		self:addAction(goToPage)
		page:addAction(goBack)
		return page
	end

	function self:addAction(action)
		self.page:setAction(-1, action) -- puts new action in the last slot
		self.rotateActions() -- circular shift actions on page so back button is always top left
		return action
	end

	function self.rotateActions()
		local actionList = self.page:getActions()
		actionList = cyclic_table_shift(actionList, 1)
		for i, act in pairs(actionList) do
			self.page:setAction(i, act)
		end
		return actionList
	end

	return self
end

function cyclic_table_shift(tab, shift)
    local len = #tab
    local shifted = {}
    for i = 1, len do
        shifted[i] = tab[(i - 1 - shift) % len + 1] -- calculates new index w/ wraparound
        -- (i - 1 - shift) % len  converts to 0-based index and wraps
        -- adding 1 converts it back to 1-based indexing, thx lua :^)
    end
    return shifted
end

return bpactions
