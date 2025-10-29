bprandfunc = {}
bprandfunc.__index = bprandfunc

bprandfunc.instances = {}

function bprandfunc:new(task, minTicks, maxTicks, taskOff)
	local self = setmetatable({}, {__index = bprandfunc})
	local executeFunc = task
	local stopFunc = taskOff or function() end

	local ticks = {}
	function self:setTickRange(minTicks, maxTicks)
		ticks.min = minTicks or 100
		ticks.max = maxTicks or 250
		assert(ticks.min <= ticks.max, "minTicks must be less than maxTicks, check the order of your inputs")
		return ticks
	end
	self:setTickRange(minTicks, maxTicks)
	
	local countdownTimer = math.random(ticks.min, ticks.max)

	local enabled = true
	local persistWhileSleeping = true
	
	function self:setEnabled(b) enabled = b return b end
	function self:getEnabled() return enabled end
	function self:toggle() enabled = not enabled return enabled	end

	function self:setExecuteOnSleep(b) persistWhileSleeping = b return b end
	function self:getExecuteOnSleep() return persistWhileSleeping end

	function self:countdown()
		local sleepCheck = (player:getPose() ~= "SLEEPING") or persistWhileSleeping
		if sleepCheck and enabled then
			if countdownTimer <= 0 then
				executeFunc()
				countdownTimer = math.random(ticks.min, ticks.max)
			else
				countdownTimer = countdownTimer - 1
			end
		else
			if countdownTimer <= 0 then
				stopFunc()
			end
		end
	end	

	table.insert(bprandfunc.instances, self)
	return self
end

--tick event
function bprandfunc:tick()
	if client:isPaused() then return end
	self:countdown()
end

return bprandfunc