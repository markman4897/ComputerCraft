--CC

--[[
=============================
 FILE VARIABLES API (1.0.0)
=============================
made by markman4897

 ~ Quick API to access globalVariables.cfg file and write into it and translate
   numerics to strings and back.

How to use:
 - fv.read() accepts no arguments and returns all the variables stored in the
             file
 - fv.write(<variables table>) accepts a table for an argument which should
                               contain variables you want to write to file
 - fv.delete(<variables table>) accepts a table of strings of variable names you
                                want to delete from file
 - fv.translate(<item>) accepts an item you want translated and returns the
                        translation

Comments:
 -

TODO:
 -

--]]


-- =============
--   Functions
-- =============

function read()
  local file = fs.open(".globalVariables.cfg", "r")
  local temp = textutils.unserialise(file.readAll())
  file.close()
  return temp
end

function write(inp)
  local f = fs.open(".globalVariables.cfg", "r")
  local temp = textutils.unserialise(f.readAll())
  f.close() -- maybe unnecessary? or just good practise?
  local f = fs.open(".globalVariables.cfg", "w")

  for k,v in pairs(inp) do
    temp[k] = v
  end

  f.write(textutils.serialise(temp))
  f.close()

  return true
end

function delete(inp)
  local f = fs.open(".globalVariables.cfg", "r")
  local temp = textutils.unserialise(f.readAll())
  f.close() -- maybe unnecessary? or just good practise?
  local f = fs.open(".globalVariables.cfg", "w")

  for k,v in ipairs(inp) do
    temp[v] = nil
  end

  f.write(textutils.serialise(temp))
  f.close()

  return true
end
