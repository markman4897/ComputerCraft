--CC

--[[
================
 MINER (1.0.0)
================
made by markman4897

 ~ This is a miner program, designed to excavate large (or small) areas and
   survive restarts.

Setup for inventory:
 - [1] slot: Ender chest for depositing
 - [2] slot: Ender chest for fuel (hard fuels like coal, charcoal, blaze rods..)

 print("usage: miner [length] [width] [depth]")
 print("length - forward, width - right, depth - down")
Arguments:
 - <length> how far in the direction the turtle is facing do you want it to mine
 - <width> how far to the right do you want the turtle to mine
 - <depth> how deep do you want the turtle to mine

How to use:
 - You run the miner program with all three arguments.
 - The inserted dimensions of the excavated area include the block the turtle is
   currently in.

Comments:
 - This program runs most efficiently when depth is a multiple of 3
 - this program is not yet truly persistent!

TODO:
 - fix so it still works normal if it crashes when turning at the end
   of the row... actually idunno man...
 - make an argument check so it can dispose of material into chest
   placed on top of it on start (or preselected coordinates if need be)
 - rewrite it so it really is persistent!

--]]


-- ========
--   APIs
-- ========

os.loadAPI(".apis/ta.lua")
os.loadAPI(".apis/fv.lua") -- only use translate function from here


-- =============
--   Variables
-- =============

local tArgs = {...}

-- watch out! NOT used for coordinates while running
variables = fv.read()

-- force to deposit and refuel from above (not good for 1 high layers)
ta.force.up = true

local startx = ta.variables.x
local starty = ta.variables.y
local startz = ta.variables.z

local targetx = 0
local targety = 0
local targetz = 0

local done = false
local dir = true -- turn to right = true (left = false)
-- dir gets calculated, so it doesnt matter what it is here

-- =============
--   Functions
-- =============

-- Deletes miner.lua specific variables in globalVariables.cfg and deletes
-- resume.
local function finish() -- technically could merge to start func somehow...
  fv.delete({
    "sx",
    "sy",
    "sz",
    "tx",
    "ty",
    "tz",
    "finished"
    })

  fs.delete("resume")

  ta.force.up = nil -- might be totally unnecessary

  done = true

  return true
end

-- after hitting last block we run this
local function returnToStart()
  fv.write({finished=true}) -- should be unnecessary
  ta.deposit() -- deposit remainder of stuff
  ta.moveTo(startx,starty,startz) -- maybe make so it also orients the same?
  return finish()
end

local function checkNextStep()
  if ((ta.variables.x + ta.variables.dirx) > math.max(startx, targetx)) or ((ta.variables.x + ta.variables.dirx) < math.min(startx, targetx)) then
    -- we are gonna step out of bounds on x axis
    return false
  end -- could make it elseif... probably...
  if ((ta.variables.z + ta.variables.dirz) > math.max(startz, targetz)) or ((ta.variables.z + ta.variables.dirz) < math.min(startz, targetz)) then
    --we are gonna step out of bounds on z axis
    return false
  end

  return true -- neither boundary would be crossed
end

local function mineStep(flags)
  if not checkNextStep() then
    return false
  end -- if you can't make another step return false

  ta.dig()
  ta.moveForward()
  if not flags.up then ta.digUp() end
  if not flags.down then ta.digDown() end
  return true
end

local function turn(flags)
  if dir then
    ta.rotateRight()
    if not mineStep(flags) then return false end
    ta.rotateRight()
    dir = not dir
  else
    ta.rotateLeft()
    if not mineStep(flags) then return false end
    ta.rotateLeft()
    dir = not dir
  end

  return true
end

local function mineLayer(flags)
  while true do
    if not mineStep(flags) then
      if not turn(flags) then
        if flags.down then -- if this was the last layer, lets stop
          print("FINISHED!!!")
          variables.finished = true
          fv.write({finished=true})
          return true
        end

        if dir then
          ta.rotateRight()
          ta.moveDown()
          return true
        else
          ta.rotateLeft()
          ta.moveDown()
          return true
        end
      end
    end
  end
end

-- are we are not on last layer? (with failsafe so it even works if we are too deep)
local function isItFinalLayer()
  return not (math.abs(targety - ta.variables.y) > 0)
end

local function mine()
  -- reset for recalculation
  local flags = {
    down=false,
    up=false
  }
  if variables.finished or done then -- done is just unnecessary safety
    return returnToStart() -- only time this actually returns, it should be true
  end

  -- get into the right height to run mineLayer() (how is this so hard!!!)
  if isItFinalLayer() then
    print("i've run down true!")
    flags.down = true -- if we're on the bottom layer, don't mine down
  else
    -- checks if the turtle is in the right position to mine (so we can break
    -- front, up and down)
    while not (((math.abs(starty - ta.variables.y) + 2) % 3) == 0) do
      ta.digDown()
      ta.moveDown()
      if isItFinalLayer() then
        print("i've run down true!")
        flags.down = true -- if we're on the bottom layer, don't mine down
        break
      end
    end
  end

  -- if we're digging 1 deep hole so we don't dig up
  if ta.variables.y == starty then
    print("i've run up true!")
    flags.up = true
  end -- no digging up on first layer

  -- calculates the right direction
  --dir = math.ceil((math.abs(starty - ta.variables.y)) / 3) % 2 == 1

  -- just not to skip the first down block of the layer
  if not flags.down then ta.digDown() end
  mineLayer(flags)

  return false
end

local function start()
  local file = fs.open("resume", "w")
  file.write("shell.run('programs/miner.lua', 'resume')")
  file.close()

  while not done do
    mine()
  end

  print("Finished mining. Over and out.")
end

-- ================
--   Main program
-- ================

if (#tArgs == 0) or (tArgs[1] == "help") then -- if program was not started with the right arguments
  print("Miner program.")
  print("usage: miner [length] [width] [depth]")
  print("length - forward, width - right, depth - down")

  return true
elseif (tArgs[1] == "resume") or fs.exists("resume") then -- if program is resuming
  startx = variables.sx
  starty = variables.sy
  startz = variables.sz

  targetx = variables.tx
  targety = variables.ty
  targetz = variables.tz
else
  startx = variables.x
  starty = variables.y
  startz = variables.z

-- FIX:: make so it is conscious how its rotated in the begining and then fill
--       width and length appropriately!!!

  -- -1 because turtle is standing in the first block (good when facing north)
  targetx = startx + (tArgs[2] - 1) --width
  targety = starty - (tArgs[3] - 1) --depth
  targetz = startz - (tArgs[1] - 1) --length

  fv.write({
    sx=startx,
    sy=starty,
    sz=startz,
    tx=targetx,
    ty=targety,
    tz=targetz,
    finished=false
    })
end

-- check if the ender chests are in place
for i=1,2 do
  turtle.select(i)
  if turtle.getItemCount() == 0 then
    print("You forgot to insert ender chests!")
    return false
  end
end

turtle.select(1)

start()
