# Boilerplate
Modular library for some common Figura avatar features and behaviours.

To install, add `boilerplate.lua` and the `Boilerplate` folder to your avatar's root folder. 
If you want to use the Actionwheel features, add `bpActionWheelDef.lua` to the folder as well.

To use all the features in BP in a script, require it at the start.
```lua
require("boilerplate")
```

## BPEyes
This is a simple script for moving humanoid front facing eyes. 

Like most other eye scripts, it translates a cube in the XY plane based on head movement.
It also automatically detects if an eye is on the left or right half of the model and flips travel limits accordingly.

### Instatiate
To create an eye, use the `:newEye()` method:
```lua
bpeyes:newEye(modelpart)
```
You can also set this to a variable, here's an example:
```lua
local leftEye = bpeyes:newEye(models.model.root.Head.Eyes.EyeL)
```

### Travel limits
The default travel limits are best suited for 2 pixel tall eyes. 
If you find that the eyes look unnatural, you can change the limits using the `:setTravel()` method:
```lua
leftEye:setTravel(_, _, _, 0.25) -- I find this works well for 1 pixel tall eyes
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
