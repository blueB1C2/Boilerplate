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
	 █▒░ █   ╚╗   █▒░ █▄▄▄▄▄█  █ ▒░█ █░ ▒█    █▒░ █╤╗  ║ █▒░ █▄▄▄▄▄█ Version 1
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

for _, library in pairs(libraries) do
	local pathLibrary = path .. library
	if pcall(require, pathLibrary) then 
		local reqMod = require(pathLibrary)
		bp[library] = reqMod
		if type(reqMod) == "table" then
			if reqMod.tick then table.insert(doTick, reqMod) end
			if reqMod.render then table.insert(doRender, reqMod) end
		end
	end
end

function events.tick()
	for _, m in ipairs(doTick) do
		for _, inst in ipairs(m.instances) do
	        inst:tick()
	    end
	end
end

function events.render(delta, context)
	for _, m in ipairs(doRender) do
		for _, inst in ipairs(m.instances) do
	        inst:render(delta, context)
	    end
	end
end

return bp