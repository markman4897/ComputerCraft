--CC

-- TODO::
-- check what device this is running on and download the right apis

-- Initialisation script to get all the files

local files = {
  "globalVariables.cfg",
  "programs/mine.lua",
  "programs/ref.lua",
  "programs/treeChopper.lua",
  "apis/ca.lua",
  "apis/fv.lua",
  "apis/ta.lua"
}

for k,v in pairs(files) do
  shell.run("wget", "https://raw.githubusercontent.com/markman4897/ComputerCraft/master/"..v, v)
end
