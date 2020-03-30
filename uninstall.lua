--CC

-- Uninstalls or rather deletes all the files associated with my system.

files = {"startup",
         "resume",
         "install.lua",
         "globalVariables.cfg",
         "apis",
         "programs",
         "uninstall.lua"}

for y,x in pairs(files) do
  -- should this be try() ? or pcall(func, arg) or whatever for extra safety?
  shell.run("fs.delete("..x..")")
