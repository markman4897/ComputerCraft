--CC

-- TODO::
-- check what device this is running on and download the right apis

-- Initialisation script to get all the files

local files = {
  "globalVariables.cfg",
  "programs/mine.lua",
  "programs/ref.lua",
  "programs/treeChopper.lua",
  "apis/computerAPI.lua",
  "apis/fv.lua",
  "apis/turtleAPI.lua"
}

for k,v in pairs(files) do
  shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/"..v, v)
end
--[[
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/globalVariables.cfg", "globalVariables.cfg")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/mine.lua", "programs/mine.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/ref.lua", "programs/ref.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/treeChopper.lua", "programs/treeChopper.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/apis/computerAPI.lua", "apis/computerAPI.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/apis/fv.lua", "apis/fv.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/apis/turtleAPI.lua", "apis/turtleAPI.lua")
--]]
