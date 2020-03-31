--CC

-- FV - File variables
-- Quick API to access globalVariables.cfg file and write into it and translate
-- numerics to strings and back.

function read()
  local file = fs.open("globalVariables.cfg", "r")
  local temp = textutils.unserialise(file.readAll())
  file.close()
  return temp

end

function write(inp)
  local f = fs.open("globalVariables.cfg", "r")
  local temp = textutils.unserialise(f.readAll())
  f.close() -- maybe unnecessary?
  local f = fs.open("globalVariables.cfg", "w")

  for k,v in pairs(inp) do
    temp[k] = v
  end

  f.write(textutils.serialise(temp))
  f.close()

end

function translate(input)
  if input == "north" then return {0,-1}
  elseif input == "south" then return {0,1}
  elseif input == "east" then return {1,0}
  elseif input == "west" then return {-1,0}
  elseif input == {0,-1} then return "north"
  elseif input == {0,1} then return "south"
  elseif input == {1,0} then return "east"
  elseif input == {-1,0} then return "west" end
end
