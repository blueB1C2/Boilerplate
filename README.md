# Boilerplate
Modular library for some common Figura avatar features and behaviours.

To install, add `boilerplate.lua` and the `Boilerplate` folder to your avatar's root folder. 
If you want to use the Actionwheel features, add `bpActionWheelDef.lua` to the folder as well.

To use any of the features of BP in a script, require it at the start.
```lua
require("boilerplate")
```

# BPEyes
This is a simple library for moving humanoid front facing eyes. 

Like most other eye libraries, it translates a modelPart in the XY plane based on head movement.
It also automatically detects if the modelPart's pivot is on the left or right half of the model, and flips travel boundaries accordingly.

### Instantiate
To create an eye, use the `:newEye()` method:
```lua
bpeyes:newEye(modelpart)
```
You can also set this to a variable, here's an example:
```lua
local leftEye = bpeyes:newEye(models.model.root.Head.Eyes.EyeL)
```

### Travel limits
These set bounds on how far the eye can move outwards (away from the nose), inwards (towards the nose), upwards and downwards.
The eye's "resting" position (looking straight forwards) will also be affected by these bounds.
If you find that the eyes look unnatural or otherwise want to change these bounds, you can change the limits using the `:setTravel()` method:
```lua
leftEye:setTravel(outwards, inwards, upwards, downwards)
-- All inputs are optional, they will default to (0.5, 0.0, 0.25, 0.5) which are suited for 2 pixel tall eyes
```
```lua
leftEye:setTravel(0.5, 0.0, 0.25, 0.25) -- I find this works well for 1 pixel tall eyes
```
It's also possible to do this in the declaration:
```lua
local leftEye = bpeyes:newEye(models.model.root.Head.Eyes.EyeL):setTravel(_, _, _, 0.25)
```

### Changing Handedness
If you for whatever reason need to change what side the eye thinks it's on, then you can use `:setLeft(bool)` to trick it into behaving like it's on a different side.
```lua
leftEye:setLeft(false)
```

# BPRandFunc
Lets you randomly call a function on a random interval between `minTicks` and `maxTicks`. 
Very similar to Squishy's randimations but allows for any code you want.

### Instantiate
```lua
local myRandFunc = bprandfunc:new(
  task,        -- Required. The function you want to occur
  minTicks,    -- Optional. Min time for the function to happen. Defaults to 100 ticks, good for blinking
  maxTicks,    -- Optional. Max time for the function to happen. Defaults to 250 ticks, good for blinking
  taskOff      -- Optional. Contingency if the randFunc is disabled on the same tick as it tries to execute
)
```

### Sleeping Behaviour
By default, the random function will still happen during sleep. The function can be disabled when sleeping using the `:setExecuteOnSleep(bool)` method.
Setting `bool` to `false` pauses the timer when the player is sleeping. Again, good for blinking!
```lua
myRandFunc:setExecuteOnSleep(false)
```
It's also possible to do this in the declaration:
```lua
local myRandFunc = bprandfunc:new(task, minTicks, maxTicks, taskOff):setExecuteOnSleep(false)
```

I've hinted at blinking enough, so here's an easily pastable snippet which plays the avatar's blinking animation:
```lua
bprandfunc:new(
	function() animations.model.blink:play() end,  -- task
    nil, nil,                                          -- default minTicks and maxTicks
	function() animations.model.blink:stop() end   -- contingency anim stop
):setExecuteOnSleep(false)
```
Again, you can use *any function* and not just animations. Particles, sounds, or whatever you need. 
<details>
  <summary>Here's an example from one of my avatars</summary>
  This was using physBones by ChloeSpacedOut to have physics-reactive ears on the model.
  By instantaneously setting the ear velocity to the head direction every so often, it effectively makes the ear twitch forward randomly.
  
  ```lua
local earTwitchR = bprandfunc:new(
	function() rightEar.velocity = player:getLookDir() end, 
	100, 700)
local earTwitchL = bprandfunc:new(
	function() leftEar.velocity = player:getLookDir() end, 
	100, 700)
  ```
</details>
