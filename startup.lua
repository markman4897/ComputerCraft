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

-- Checks if system has initialised, otherwise, does it now.
-- If its initialised, checks for updates and updates the system if new version
-- found.

local function uninstall()
    print("[INFO] Uninstallation commencing...")
    print("Are you sure you want to uninstall the framework? (y/n)")
    local temp = read()
    if temp == "n" or temp == "N" or temp == "no" or temp == "No" or temp == "NO" then
      return false
    end

    files = {"startup",
             ".globalVariables.cfg",
             ".apis", -- folder
             "programs", -- folder
             "resume"}

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
  shell.run("wget", "http://localhost:8080/startup.lua", "startup")
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
  shell.run("wget", "http://localhost:8080/init.lua", "init.lua")
  shell.run("init.lua")
  print("[INFO] Installation complete.")
  fs.delete("init.lua")
else
  shell.run("wget", "http://localhost:8080/.globalVariables.cfg", "temp")
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

-- test this...
if fs.exists("resume") then
  shell.run("resume")
end

print("[INFO] Finished startup.")
