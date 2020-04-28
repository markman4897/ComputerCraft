--CC

-- Quick and dirty program to reset ".globalvariables.cfg" file

local f = fs.open(".globalVariables.cfg", "r")
local empty = f.readAll()
f.close() -- maybe unnecessary? or just good practise?
local f = fs.open(".globalVariables.cfg", "w")

local temp = {}
temp.version = "1.0"
temp.autoUpdate = false
temp.x = 0
temp.z = 0
temp.y = 0
temp.dirx = 0
temp.dirz = -1

f.write(textutils.serialise(temp))
f.close()

fs.delete("resume")
