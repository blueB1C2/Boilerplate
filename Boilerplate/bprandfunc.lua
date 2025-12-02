bprandfunc = {}
bprandfunc.__index = bprandfunc

bprandfunc.instances = {}

function bprandfunc:new(task, minTicks, maxTicks, taskOff)
	local self = setmetatable({}, {__index = bprandfunc})
	
	local executeFunc = task
	local stopFunc = taskOff or function() end

	local ticks = {}
	
	function self:setTickRange(minTicks, maxTicks) -- sets tick range to randomly execute between
		ticks.min = minTicks or 100
		ticks.max = maxTicks or 250
		assert(ticks.min <= ticks.max, "minTicks must be less than maxTicks, check the order of your inputs")
		return ticks
	end
	self:setTickRange(minTicks, maxTicks)
	
	local countdownTimer = math.random(ticks.min, ticks.max)

	local enabled = true
	local persistWhileSleeping = true
	
	function self:setEnabled(b) 					-- enable or disable the randFunc timer
		enabled = b 
		return b 
	end
	function self:getEnabled() return enabled end 	-- if for some reason you need to retrieve it
	function self:toggle() 							-- toggles enabled status
		enabled = not enabled 
		return enabled	
	end

	function self:setExecuteOnSleep(b) -- enable or disable the timer while sleeping
		persistWhileSleeping = b 
		return b 
	end
	function self:getExecuteOnSleep() return persistWhileSleeping end -- if for some reason you need to retrieve it

	function self:countdown()
		local sleepCheck = (player:getPose() ~= "SLEEPING") or persistWhileSleeping -- true if player is awake or randFunc allowed to exec while sleeping
		if sleepCheck and enabled then
			if countdownTimer <= 0 then	-- countdown runs out, chooses new random countdown
				executeFunc()
				countdownTimer = math.random(ticks.min, ticks.max)
			else
				countdownTimer = countdownTimer - 1
			end
		else
			if countdownTimer <= 0 then -- contingency if the randFunc is disabled just as the timer reaches 0
				stopFunc()
			end
		end
	end	

	table.insert(bprandfunc.instances, self) -- makes a new instance to run on tick and render
	return self
end

function bprandfunc:tick()
	if client:isPaused() then return end -- don't run when client is paused
	self:countdown()
end

return bprandfunc
