--CC

-- Startup script to make (download) environment on the first run and to
-- properly run every consecutive time

-- get
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/startup.lua", "sartup.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/install.luashell.run", "install.lua")
shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/programs/ref.lua", "programs/ref.lua")
shell.run("programs/ref.lua")
