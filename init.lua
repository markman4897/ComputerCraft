--CC

-- TODO::
-- check what device this is running on and download the right apis
-- automate so you can just pass files and it will generate wgets itself

-- Initialisation script to get all the files

-- shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/startup.lua", "startup")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/globalVariables.lua", "globalVariables.cfg")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/mine.lua", "programs/mine.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/ref.lua", "programs/ref.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/treeChopper.lua", "programs/treeChopper.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/apis/computerAPI.lua", "apis/computerAPI.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/apis/fv.lua", "apis/fv.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/apis/turtleAPI.lua", "apis/turtleAPI.lua")
