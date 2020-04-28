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

TODO:
 - make it so downloading files is silent (not printed out)

--]]


local tArgs = {...}

local path = "placeholder"

-- for installation to other dirs that are not root (disks)
--local dir = fs.getDir("")

local files = {
  ".globalVariables.cfg",
  "resetGlobalVariables.lua",
  "programs/turtle/lumberjack.lua",
  "programs/turtle/miner.lua",
  "programs/turtle/refuel.lua",
  "programs/turtle/ringRepair.lua",
  ".apis/ga.lua",
  ".apis/fv.lua",
  ".apis/ta.lua"
}

-- Checks if system has initialised, otherwise, does it now.
-- If its initialised, checks for updates and updates the system if new version
-- found.

local function init()
  for k,v in pairs(files) do
    shell.run("wget", path..v, v)
  end
end

local function uninstall()
    print("[INFO] Uninstallation commencing...")
    print("Are you sure you want to uninstall the framework? (y/n)")
    local temp = read()
    if temp == "n" or temp == "N" or temp == "no" or temp == "No" or temp == "NO" then
      return false
    end

    -- should I use ipairs here?
    for k,v in ipairs(files) do
      -- should this be try() ? or pcall(func, arg) or whatever for extra safety?
      print("Deleting: "..v)
      fs.delete(v)
    end

    print("[INFO] Uninstallation completed.")
end

local function update()
  print("[INFO] Updating framework...")
  uninstall()
  shell.run("wget", path.."startup.lua", "startup")
  shell.run("startup")
  print("[INFO] Framework updated.")
end

if tArgs[1] == "uninstall" then
  uninstall()

  return true
elseif tArgs[1] == "update" then
  update()

  return true
elseif tArgs[1] == "help" then
  print("Available arguments:")
  print("uninstall - uninstalls the framework and everything in it.")
  print("update - updates fresh version of the framework.")
  print("help - prints this information")

  return true
end

if not fs.exists(".globalVariables.cfg") then
  init()
  print("[INFO] Installation complete.")
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
          print("[WARN] Will update on next boot. Program is running.")
        end
      end
    end
  end
end

print("[INFO] Finished startup.")

-- test this...
if fs.exists("resume") then
  print("[INFO] Resuming in 10s.")
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
      print("[INFO] Fill in 9 miner drones and 9 pairs of ender chests.")
      print("[INFO] You have 10s to comply.")
      os.sleep(10)
      print("... sorry, not implemented yet")
      -- carry them around and place the drones and fill them with chests
      return true
    end
    if find({"swarm", "drone"}) then --maybe remove drone?
      print("[INFO] Going to start mining chunk in 5s!")
      os.sleep(5)
      shell.run("programs/turtle/miner.lua", "16", "16", "68")
      return true
    end
  elseif find({"lumberjack", "chopper", "treefarm"}) then
    print("[INFO] Going to start lumberjacking in 5s!")
    os.sleep(5)
    shell.run("programs/turtle/lumberjack.lua")
    return true
  end
end
