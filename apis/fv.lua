--CC

-- FV - File variables
-- Quick API to access globalVariables.cfg file and write into it

-- Might have to define variables here so they stay the right type (dirz, dirx
-- can be negative), better fix would be giving values that we can work with
-- (for example 0, 1, 2, or floats). <-- this (can do better I think)

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
