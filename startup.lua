--CC

-- Startup script to make (download) environment on the first run and to
-- properly run every consecutive time

-- This script is installed by https://pastebin.com/VLTuFN08

local tArgs = {...}

-- Check if system has initialised, otherwise, do it now.
-- If its initialised, checks for updates and updates the system if new version
-- found.

local function uninstall()
    -- TODO:: Add "Are you sure" dialog.
    files = {"/startup",
             "/globalVariables.cfg",
             "/apis", -- folder
             "/programs", -- folder
             "/resume"}

    for k,v in pairs(files) do
      -- should this be try() ? or pcall(func, arg) or whatever for extra safety?
      print("Deleting: "..v)
      fs.delete(v)
    end

end

if tArgs[1] == "uninstall" then
  uninstall()

  return true
end

print("[INFO]: Got through uninstall.")

if not fs.exists("globalVariables.cfg") then
  shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/init.lua", "init.lua")
  shell.run("init.lua")
  fs.delete("init.lua")
else
  shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/globalVariables.cfg", "temp")
  local new_ver_f = fs.open("temp", "r")
  local new_ver = textutils.unserialise(new_ver_f.readAll())
  new_ver_f.close()
  local ver_f = fs.open("globalVariables.cfg", "r")
  local ver = textutils.unserialise(ver_f.readAll())
  ver_f.close()
  fs.delete("temp")
  if (new_ver["version"] ~= ver["version"]) or (tArgs[1] == "reinstall") then
    -- TODO: FIX THIS LOGICALLY SOMEHOW?
    uninstall()
    shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/startup.lua", "startup")
    shell.run("startup")
  end
end

-- test this...
if fs.exists("resume") then
  shell.run("resume")
end
