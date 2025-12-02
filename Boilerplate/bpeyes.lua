bpeyes = {}
bpeyes.__index = bpeyes

bpeyes.instances = {}

function bpeyes:newEye(modelPart)
	local self = setmetatable({}, {__index = bpeyes})

	local eyePart = modelPart
	local isLeft = (modelPart:getTruePivot().x < 0) -- checks if the eye's pivot is on the -x side of the model

	local travel = {} -- defaults for two pixel tall eyes
	travel.outwards = 0.5
	travel.inwards = 0.0
	travel.upwards = 0.25
	travel.downwards = 0.5

	local pos = vec(0,0)

	local function getHeadRot() -- missed opportunity to call this getBrainRot
		local rot = vanilla_model.HEAD:getOriginRot()
		return vec(rot.x, rot.y) -- returns azimuth and attitude
	end

	function self.mapHeadRot() -- maps degrees of headRot to blockbench units
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

	function self.updatePos(dt) -- updates visual position in render
		local current = {}
		current = eyePart:getPos()
		eyePart:setPos(
			math.lerp(current.x, pos.x, dt),
			math.lerp(current.y, pos.y, dt), 
			0
			)
	end

	function self:setTravel(outwards, inwards, upwards, downwards) -- sets custom eye travel limits
		travel.outwards = outwards or travel.outwards
		travel.inwards = inwards or travel.inwards
		travel.upwards = upwards or travel.upwards
		travel.downwards = downwards or travel.downwards
		return travel
	end
	function self:travel(outwards, inwards, upwards, downwards) --alias
		return self:setTravel(outwards, inwards, upwards, downwards)
	end
	function self:getTravel() return travel end -- if for some reason you need to retrieve it

	function self:setLeft(b) -- sets handedness if you don't want that happening automatically
		isLeft = b
		return isLeft
	end
	function self:left(b) return self:setLeft(b) end --alias
	function self:getLeft() return isLeft end -- if for some reason you need to retrieve it

	table.insert(bpeyes.instances, self) -- makes a new instance to run on tick and render
	return self
end

function bpeyes:tick()
	self.mapHeadRot()
end

function bpeyes:render(dt, _)
	self.updatePos(dt)
end

return bpeyes
