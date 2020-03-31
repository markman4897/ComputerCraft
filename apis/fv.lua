--CC

-- FV - File variables
-- Quick API to access globalVariables.cfg file and write into it

function read()
  return textutils.unserialise(fs.open("globalVariables.cfg", "r").readAll())

end

function write(inp)
  local f = fs.open("globalVariables.cfg", "w")
  local temp = textutils.unserialise(f.readAll())

  for k,v in pairs(inp) do
    temp[k] = v
  end

  f.write(textutils.serialise(temp))
  f.close()

end

-- TODO:: make this usable somehow
--[[
navigationDict = {
  north={0,-1},
  south={0,1},
  east={1,0},
  west={-1,0}
} --]]
