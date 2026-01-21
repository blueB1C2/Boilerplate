--[[
	▄▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄  ░   ▄▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄
	 █[+]  ░[+]█ █[+]  ░[+]█  █[+]█   █[+]█ ░   ░  █[+]  ░[+]█╦╗█[+] ░ [+]█
	 █░  █▀█  ░█╔█░  █▀█  ░█ ╔█░  █╡  █░  █  ▒>╥<▒ █░  █▀▀▀▀▀█║╟█░  █▀█  ░█
	 █   █▄█░  █║█   █ █░  █ ║█   █  ╔█   █═╦═╤╝   █   █      ║╚█   █▄█░  █
	 █  ░  ░ ▄▀ ║█  ░█ █   █═╝█  ░█ ╔╝█  ░█ ║ │  ╔═█[+]▀▀▀▀█══╝ █  ░  ░ █▀▀
	 █░  █▀█  ▀▄║█░  █ █  ░█  █░  █═╩═█░  █ ╚═╧═╤╣ █░  █▀▀▀▀    █░  █▀▄  █
	 █▒░ █▄█░ ▒█╬█▒░ █▄█░ ▒█  █▒░ █   █▒░ █▄▄▄▄▄█╚═█▒░ █▄▄▄▄▄█  █▒░ █╗█░▒ █
	 █[+]▒░ [+]█║█[+]▒░ [+]█  █[+]█   █[+]▒░ [+]█  █[+]▒░ [+]█  █[+]█╚█[+]█
	▄█▄▄▄▄▄▄▄▄▄█║█▄▄▄▄▄▄▄▄▄█ ▄█▄▄▄█▄ ▄█▄▄▄▄▄▄▄▄▄█ ▄█▄▄▄▄▄▄▄▄▄█ ▄█▄▄▄█╗█▄▄▄█▄
	▄▄▄▄▄▄▄▄▄▄▄▄║▄▄▄▄▄▄▄  │    ║   ▄▄▄ ║  ▄▄▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄ ╠═══╝
	 █[+]  ░[+]█╚╗█[+]█╦══╧╤══╦╝  █[+]█╩╗ █[+]    ░[+]█  █[+]  ░[+]█ ║ 
	 █░  █▀█  ░█ ║█░  █╢   │  ╟──█░ ▄  █╚╗█▀▀▀█░  █▀▀▀█ ╔█░  █▀▀▀▀▀█ ║ 
	 █   █▄█░  █ ╟█   █╚╗ [♥] ║ ▄▀ █ █░▀▄║    █   █   │ ╟█  ░█═╤══╦╧═╝ 
	 █  ░▄▄▄▄▄▄█═╣█  ░█═╝     ╚═█ ░▀▀▀  █╩═══╦█  ░█═══╧╦╝█[+]▀▀▀▀█╝    
	 █░  █   ╔╧══╝█░  █        ▄▀░  ▄░ ░▀▄   ╚█░  █    ║ █░  █▀▀▀▀
	 █▒░ █   ╚╗   █▒░ █▄▄▄▄▄█  █ ▒░█ █░ ▒█    █▒░ █╤╗  ║ █▒░ █▄▄▄▄▄█ Version 1.0.0
	 █[+]█ ░  ╠═══█[+]▒░ [+]█  █[+]█ █[+]█    █[+]█┘╚══╩═█[+]▒░ [+]█ Made by Blueberry
	▄█▄▄▄█▄ ░>╨  ▄█▄▄▄▄▄▄▄▄▄█ ▄█▄▄▄█ █▄▄▄█▄  ▄█▄▄▄█▄    ▄█▄▄▄▄▄▄▄▄▄█ @blueberry1c2
]]--
bp = {}

local path = "./Boilerplate."
local libraries = {
	"bpeyes", 
	"bphys", 
	"bpmenubuilder", 
	"bprandfunc"
}
-- we don't talk about bphys

local doTick = {}
local doRender = {}

for _, library in pairs(libraries) do -- requires everything in the library list, skips if it doesn't exist
	local pathLibrary = path .. library
	if pcall(require, pathLibrary) then 
		local reqMod = require(pathLibrary)
		bp[library] = reqMod
		if type(reqMod) == "table" then
			if reqMod.tick then table.insert(doTick, reqMod) end		-- find all libraries with a tick event
			if reqMod.render then table.insert(doRender, reqMod) end	-- find all libraries with a render event
		end
	end
end

function events.tick() -- does tick event for all libraries that have it
	for _, m in ipairs(doTick) do
		for _, inst in ipairs(m.instances) do
	        inst:tick()
	    end
	end
end

function events.render(delta, context) -- does render event for all libraries that have it
	for _, m in ipairs(doRender) do
		for _, inst in ipairs(m.instances) do
	        inst:render(delta, context)
	    end
	end
end

return bp
-- a full stack of lines B^)

