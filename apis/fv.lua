--CC

-- FV - File variables
-- Quick API to access globalVariables.cfg file and write into it and translate
-- numerics to strings and back.

function read()
  return textutils.unserialise(fs.open("globalVariables.cfg", "r").readAll())

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
  if input == "south" then return {0,1}
  if input == "east" then return {1,0}
  if input == "west" then return {-1,0}
  if input == {0,-1} then return "north"
  if input == {0,1} then return "south"
  if input == {1,0} then return "east"
  if input == {-1,0} then return "west"
end
