bpactions = {}
bpactions.__index = bpactions

function bpactions:build(structure, menu)
	self = setmetatable({}, bpactions)
	self.menu = menu or bpactions.menu:new("Main")

	local childMenu = self.menu:addChildPage(structure)
	if structure.contains == nil then return end
	for i = 1,#structure.contains do
		local subStruct = structure.contains[i]
		if type(subStruct) == "Action" then
			childMenu:addAction(subStruct)
		else
			bpactions:build(subStruct, childMenu)
		end
	end
	action_wheel:setPage(self.menu.page)
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

	function self:addChildPage(struct)
		local params = struct.params
		if params == nil or next(params) == nil then return self end
		local page = bpactions.menu:new(struct.name or params.title)
		table.insert(self.children, page)
		page.parent = self

		local goToPage = action_wheel:newAction()
			:title(params.title or "Title T")
			:item(params.item or nil)
			:hoverItem(params.hoverItem or params.item or nil)
			:color(params.color or vec(0,0,0))
			:hoverColor(params.hoverColor)
			:onLeftClick(function() action_wheel:setPage(page.page) end)
		local goBack = action_wheel:newAction()
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
		self.page:setAction(-1, action)
		self.rotateActions()
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
        -- Calculate the new index with wraparound
        -- (i - 1 - shift) % len ensures the index wraps correctly,
        -- and adding 1 converts it back to 1-based indexing.
        shifted[i] = tab[(i - 1 - shift) % len + 1]
    end
    return shifted
end

return bpactions