bpeyes = {}
bpeyes.__index = bpeyes

bpeyes.instances = {}

function bpeyes:newEye(modelPart)
	local self = setmetatable({}, {__index = bpeyes})

	local eyePart = modelPart
	local isLeft = (modelPart:getTruePivot().x < 0)

	local travel = {}
	travel.outwards = 0.5
	travel.inwards = 0.0
	travel.upwards = 0.25
	travel.downwards = 0.5

	local pos = vec(0,0)

	local function getHeadRot()
		local rot = vanilla_model.HEAD:getOriginRot()
		return vec(rot.x, rot.y)
	end

	function self.mapHeadRot()
		local headRot = getHeadRot()
		if isLeft then
			pos = vec(
				math.map(headRot.y, -50, 50, travel.inwards, -travel.outwards), 
				math.map(headRot.x, -90, 90, -travel.downwards, travel.upwards)
				)
		else
			pos = vec(
				math.map(headRot.y, -50, 50, travel.outwards, -travel.inwards), 
				math.map(headRot.x, -90, 90, -travel.downwards, travel.upwards)
				)
		end
	end

	function self.updatePos(dt)
		local current = {}
		current = eyePart:getPos()
		eyePart:setPos(
			math.lerp(current.x, pos.x, dt),
			math.lerp(current.y, pos.y, dt), 
			0
			)
	end

	function self:setTravel(outwards, inwards, upwards, downwards)
		travel.outwards = outwards or travel.outwards
		travel.inwards = inwards or travel.inwards
		travel.upwards = upwards or travel.upwards
		travel.downwards = downwards or travel.downwards
		return travel
	end
	function self:travel(outwards, inwards, upwards, downwards) --alias
		return self:setTravel(outwards, inwards, upwards, downwards)
	end
	function self:getTravel() return travel end

	function self:setLeft(b)
		isLeft = b
		return isLeft
	end
	function self:left(b) return self:setLeft(b) end --alias
	function self:getLeft() return isLeft end

	table.insert(bpeyes.instances, self)
	return self
end

--tick event, called 20 times per second
function bpeyes:tick()
	self.mapHeadRot()
end

function bpeyes:render(dt, _)
	self.updatePos(dt)
end


return bpeyes

