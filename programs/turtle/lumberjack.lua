--CC

--[[
====================
 LUMBERJACK (1.0.0)
====================
made by markman4897

 ~ This is a lumberjack program that chops wood and deposits it into ender chest.

 Setup for inventory:
  - [1] slot: Ender chest for depositing
  - [2] slot: Ender chest for fuel (hard fuels like coal, charcoal, blaze rods..)
  - [3] slot: Sapplings (not right now)

Arguments:
 - <required argument> description
 - [optional argument] description

How to use:
 - Needs something to place saplings instead of it (turtles can't place in
   claimed areas -.-)
 - Place a sappling in front of the turtle and power that sappling with a
   redstone repeater (so the block recieves power when it grows)

Comments:
 - Only works on horizontal trees (no side branches).
 - This will totally break if it gets something into the last inv slot (because
   then it will try to deposit to ender chest and hang on it)
   ... could happen when breaking block

TODO:
 - make it an option if you want it to place sapplings or not and use ender
   chests to deposit rather than chest below
 - check if it collects sapplings at all or not (then figure out how to)

--]]



-- ========
--   APIs
-- ========

os.loadAPI(".apis/ta.lua")


-- =============
--   Variables
-- =============

ta.force.up = true

ta.start = 1

counter = 0

-- would be used if it would also plant sapplings
-- ta.start = 4


-- =============
--   Functions
-- =============

local function chop()
  print("[INFO] Started chopping the tree.")

  -- chop the whole tree
  while turtle.detect() do
    ta.dig()
    ta.digUp()
    ta.moveUp()
  end

  -- get back down
  while not turtle.detectDown() do
    ta.moveDown()
  end

  counter = counter + 1
  print("[INFO] Chopped down ", counter, " trees since last restart.")
end


-- ================
--   Main program
-- ================

-- check if the ender chests are in place (when adding the option)
--if not ta.checkInvSetup() then return false end

print("[INFO] Chopping program commensing.")

while true do
  if turtle.detectDown() then
    if turtle.detect() then
      if redstone.getInput("front") then
        chop()
        ta.depositTo("down")
      else
        print("[INFO] Sleeping 60s.")
        sleep(60) -- maybe make this bigger
      end
    --[[else -- will be useful when... read TODO -.-
      turtle.select(3)
      turtle.place() --]]
    end
  else
    chop()
  end
end
