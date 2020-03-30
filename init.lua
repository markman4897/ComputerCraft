--CC

-- TODO::
-- check what device this is running on and download the right apis
-- automate so you can just pass files and it will generate wgets itself

-- Initialisation script to get all the files

-- shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/startup.lua", "startup")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/ref.lua", "globalVariables.cfg")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/install.luashell.run", "install.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/uninstall.lua", "uninstall.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/mine.lua", "programs/mine.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/ref.lua", "programs/ref.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/ref.lua", "apis/turtleAPI.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/ref.lua", "apis/computerAPI.lua")
