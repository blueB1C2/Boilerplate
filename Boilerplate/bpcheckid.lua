bpcheck = {}
bpcheck.__index = bpcheck

bpcheck.instance = {}

--[[ Set this to true if you want to be warned about ID mismatches --]]
local warnMe = false

local function warn(message, level) --thank you AuriaFoxGirl
	if not warnMe then return end
	local _, traceback = pcall(function() error(message, (level or 1) + 3) end)
	printJson(toJson{
    	{text = '[non-fatal warn] ', color = 'yellow'},
    	{text = avatar:getEntityName(), color = 'white'},
    	' : ', traceback, '\n'
    	})
end

function bpcheck:item(id, fb)
	local primary = id
	local fallback = fb

	-- Check if primary item ID is valid, if so return it
	local passed, itemStack = pcall(world.newItem, primary)
	if passed then
		return itemStack 
	end

	-- Check if fallback item ID is valid, if so return it
	passed, itemStack = pcall(world.newItem, fallback)
	if passed then
		-- Send gentle warning to operator that the fallback is being used
		warn(
			"The item ID \""..tostring(primary).."\" could not be found. "..
			"Trying fallback \""..tostring(fallback).."\""
			)
		return itemStack
	end

	-- Last resort, use air
	-- Send gentle warning to operator again
	warn(
		"The item ID \""..tostring(primary)..
		"\" or fallback \""..tostring(fallback)..
		"\" could not be found. Returning air."
		)
	return world.newItem("air")
end

function bpcheck:sound(id, fb)
	local primary = id
	local fallback = fb

	-- Check if primary sound ID is valid, if so return it
	if sounds:isPresent(primary) then
		return primary
	end

	-- Check if fallback sound ID is valid, if so return it
	if sounds:isPresent(fallback) then
		-- Send gentle warning to operator that the fallback is being used
		warn(
			"The sound ID \""..tostring(primary).."\" could not be found. "..
			"Trying fallback \""..tostring(fallback).."\""
			)
		return fallback
	end

	-- Last resort, send empty string
	-- Send gentle warning to operator again
	warn(
		"The sound ID \""..tostring(primary)..
		"\" or fallback \""..tostring(fallback)..
		"\" could not be found."
		)
	return ""
end

function bpcheck:particle(id, fb)
	local primary = id
	local fallback = fb

	-- Check if primary sound ID is valid, if so return it
	if particles:isPresent(primary) then
		return primary
	end

	-- Check if fallback sound ID is valid, if so return it
	if particles:isPresent(fallback) then
		-- Send gentle warning to operator that the fallback is being used
		warn(
			"The particle ID \""..tostring(primary).."\" could not be found. "..
			"Trying fallback \""..tostring(fallback).."\""
			)
		return fallback
	end

	-- Last resort, use note (particle from an early mc version that's easily visible)
	-- Send gentle warning to operator again
	warn(
		"The particle ID \""..tostring(primary)..
		"\" or fallback \""..tostring(fallback)..
		"\" could not be found."
		)
	return "note"
end

return bpcheck