--CC

--[[
=========================
 STARTUP SCRIPT (1.0.0)
=========================
made by markman4897

 ~ Startup script that installs my framework and runs at every boot

Arguments:
 - [help] prints out arguments and what they do
 - [uninstall] uninstalls the whole framework
 - [update] updates newest version of the framework

How to use:
 - First time you just run it without any arguments
 - It will run on every boot of the machine and check for new version of
   framework

Comments:
 - This script is installed by https://pastebin.com/VLTuFN08
 - !! ^currently not working^ !!

TODO:
 - make it so downloading files is silent (not printed out)

--]]


local tArgs = {...}

local path = "placeholder"

if fs.exists(".apis/ga.lua") then
  os.loadAPI(".apis/ga.lua")
end

-- for installation to other dirs that are not root (disks)
--local dir = fs.getDir("")

local files = {}
files.basic = {
  ".globalVariables.cfg",
  "resetGlobalVariables.lua",
  ".apis/ga.lua",
  ".apis/fv.lua"
}

files.turtle = {
  ".apis/ta.lua",
  "programs/turtle/builder.lua",
  "programs/turtle/lumberjack.lua",
  "programs/turtle/miner.lua",
  "programs/turtle/refuel.lua",
  "programs/turtle/ringRepair.lua"
}

files.computer = {
  "programs/computer/diskInstaller.lua"
}

files.neural_interface = {
  "programs/neural_interface/fly.lua",
  "programs/neural_interface/oreScanner.lua"
}

files.pocket ={
  "[ERROR] Placeholder!!!"
}

local function install(program)
  if type(program) == "string" then
    shell.run("wget", path..program, program)
  elseif type(program) == "table" then
    for k,v in ipairs(program) do
      shell.run("wget", path..v, v)
    end
  else
    print("Problem in 'program' argument!")
  end
end

local function init()
  install(files.basic)
  os.loadAPI(".apis/ga.lua")
  local device = ga.getDeviceType()
  if files[device] then
    install(files[device])
  end
end

local function uninstall(force)
  force = force or false
  ga.pInfo("Uninstallation commencing...")
  if not force then
    print("Are you sure you want to uninstall the framework? (y/n)")
    local temp = read()
    if temp == "n" or temp == "N" or temp == "no" or temp == "No" or temp == "NO" then
      ga.pInfo("Uninstallation aborted.")
      return false
    end
  end

  -- should I use ipairs here?
  for i,j in pairs(files) do
    for i,v in ipairs(j) do
      -- should this be try() ? or pcall(func, arg) or whatever for extra safety?
      print("Deleting: "..v)
      fs.delete(v)
    end
  end

  ga.pInfo("Uninstallation completed.")
end

local function update()
  ga.pInfo("Updating framework...")
  uninstall()
  shell.run("wget", path.."startup.lua", "startup")
  shell.run("startup")
  ga.pInfo("Framework updated.")
end

if tArgs[1] == "uninstall" then
  uninstall(tArgs[2])

  return true
elseif tArgs[1] == "update" then
  update()

  return true
elseif tArgs[1] == "help" then
  print("Available arguments:")
  print("uninstall - uninstalls the framework and everything in it.")
  print("update - updates fresh version of the framework.")
  print("install - placeholder")
  print("help - prints this information")

  return true
end

-- Checks if system has initialised, otherwise, does it now.
-- If its initialised, checks for updates and updates the system if new version
-- found.

if not fs.exists(".globalVariables.cfg") then
  init()
  ga.pInfo("Installation complete.")
  return true -- so the turtles dont do what their label says on installation
else
  -- auto update code
  if fs.exists(".apis/fv.lua") then
    os.loadAPI(".apis/fv.lua")
    local variables = fv.read()
    if variables.autoUpdate == true then
      shell.run("wget", path..".globalVariables.cfg", "temp")
      local new_ver_f = fs.open("temp", "r")
      local new_ver = textutils.unserialise(new_ver_f.readAll())
      new_ver_f.close()
      local ver_f = fs.open(".globalVariables.cfg", "r")
      local ver = textutils.unserialise(ver_f.readAll())
      ver_f.close()
      fs.delete("temp")
      if not (new_ver.version == ver.version) then
        if not fs.exists("resume") then
          update()
          return true
        else
          ga.pWarn("Will update on next boot. Program is running.")
        end
      end
    end
  end
end

ga.pInfo("Finished startup.")

-- test this...
if fs.exists("resume") then
  ga.pInfo("Resuming in 10s.")
  os.sleep(10)
  shell.run("resume")
end

-- This section tries to understand what the turtle does by its label
local label = os.getComputerLabel()
if label then
  local label_parts = {}

  for i in string.gmatch(label, "%a+") do
    table.insert(label_parts, i)
  end

  -- #? maybe use string.find instead?
  local function find(keys)
    for k,part in ipairs(label_parts) do
      for i,key in ipairs(keys) do
        if type(part) ~= "string" then part = tostring(part) end
        if string.lower(part) == key then return true end
      end
    end

    return false
  end

  -- Now for the recognition part
  if find({"mine", "miner"}) then
    if find({"control", "controller"}) then
      ga.pInfo("Fill in 9 miner drones and 9 pairs of ender chests.")
      ga.pInfo("You have 10s to comply.")
      os.sleep(10)
      print("... sorry, not implemented yet")
      -- carry them around and place the drones and fill them with chests
      return true
    end
    if find({"swarm", "drone"}) then --maybe remove drone?
      ga.pInfo("Going to start mining chunk in 5s!")
      os.sleep(5)
      shell.run("programs/turtle/miner.lua", "16", "16", "68")
      return true
    end
  elseif find({"lumberjack", "chopper", "treefarm"}) then
    ga.pInfo("Going to start lumberjacking in 5s!")
    os.sleep(5)
    shell.run("programs/turtle/lumberjack.lua")
    return true
  elseif find({"fly", "flight", "flying"}) then
    ga.pInfo("Going to start fli program in 2s!")
    os.sleep(2)
    shell.run("programs/neural_interface/fly.lua")
    return true
  end
end
