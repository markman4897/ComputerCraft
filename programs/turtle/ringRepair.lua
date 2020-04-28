--CC

--[[
=========================
 RING REPAIRER (version)
=========================
made by markman4897

 ~ Simple program to repair (or rather refill) rings with the substance from
   the chest above.

Setup:
 - Crafting turtle should face the ender chest with the items you want to repair
   in front of it
 - It should also have a chest with desired refill item above it.
 - It will deposit refilled item to chest below.

How to use:
 - Just place the turtle and 2 chests in the right spots and run the program.

Comments:
 -

TODO:
 - Migrate functions to ta.lua sooner or later
 - make logical chest placement and rules
 - make comments more pretty and do a better program
 - test out the program

--]]


-- a bit limited, yet intentionally so that the orientation of the turtle
-- doesn't get confuset (for now)
-- move this to ta.lua ?
function getFromChest(direction)
  if direction == "up" then
    return turtle.suckUp()
  elseif direction == "front" then
    return turtle.suck()
  elseif direction == "down" then
    return turtle.suckDown()
end

-- this program uses 3 ESDs (from Actually Additions mod) to handle input and
-- output of crafted items and refill material

-- items to be crafted should be placed into first slot of the turtle
-- crafted items will be sucked out of last slot of the turtle
-- refill material should be placed in all other slots

-- TODO: - could make it so it doesnt need 3rd ESD for materials but instead
--         sucks from front of turtle when needed

function checkFuel()
  turtle.select(2)
  if turtle.getItemCount() == 1 then return false end

  turtle.select(3)
  if turtle.getItemCount() == 1 then return false end

  turtle.select(1)

  return true
end

function refillFuel()
  turtle.select(2)
  turtle.suck(64)
  turtle.select(3)
  turtle.suck(64)
  turtle.select(1)
end

-- ================
--   Main program
-- ================

print("Ring repairing turtle.")
print("Commensing operation in 10s.")
os.sleep(10)

turtle.select(1)

while true do
  if not checkFuel() then refillFuel() end
  for i=1,20 do
      turtle.craft()
  end

  print("Crafted.")
  turtle.transferTo(16)

  os.sleep(5)
end
