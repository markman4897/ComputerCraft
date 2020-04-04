--CC

--[[
==================================
 INITIALISATION SCRIPT (version)
==================================
made by markman4897

 ~ A script that downloads all the programs

How to use:
 - You should not directly use this scrpit as it is just a helper for the
   startup script.

Comments:
 -

TODO:
 - check what device this is running on and download the right apis

--]]


local files = {
  ".globalVariables.cfg",
  "programs/lumberjack.lua",
  "programs/miner.lua",
  "programs/refuel.lua",
  ".apis/ca.lua",
  ".apis/fv.lua",
  ".apis/ta.lua"
}

for k,v in pairs(files) do
  shell.run("wget", "http://localhost:8080/"..v, v)
end
