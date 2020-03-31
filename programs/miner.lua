--CC

-- This is a miner program, designed to excavate large (or small) areas and
-- survive restarts.
-- This program runs most efficiently if depth is a multiple of 3.
-- for now ! ONLY WORKS ! if depth is a multiple of 3

-- TODO:: - fix so it still works normal if it crashes when turning at the end of
--          the row

-- APIs

os.loadAPI("apis/ta.lua")
os.loadAPI("apis/fv.lua") -- only use translate function from here

-- Variables

local tArgs = {...}

variables = fv.read() -- watch out! NOT used for coordinates while running

local startx = ta.variables.x
local starty = ta.variables.y
local startz = ta.variables.z

local targetx = 0
local targety = 0
local targetz = 0

local done = false
local dir = true -- do you work to right = true (left = false)

-- Functions

-- Deletes miner.lua specific variables in globalVariables.cfg and deletes
-- resume.
local function finish()
  fv.write({
    sx=nil,
    sy=nil,
    sz=nil,
    tx=nil,
    ty=nil,
    tz=nil,
    finished=nil
    })

  fs.delete("resume")

  done = true

  return true
end

-- after hitting last block
local function returnToStart()
  fv.write({finished=true}) -- should be unnecessary
  ta.moveTo(startx,starty,startz)
  return finish()
end

local function checkNextStep()
  if ((ta.variables.x + ta.variables.dirx) > math.max(startx, targetx)) or ((ta.variables.x + ta.variables.dirx) < math.min(startx, targetx)) then
    -- we are gonna step out of bounds on x axis
    return false
  end
  if ((ta.variables.z + ta.variables.dirz) > math.max(startz, targetz)) or ((ta.variables.z + ta.variables.dirz) < math.min(startz, targetz)) then
    --we are gonna step out of bounds on z axis
    return false
  end

  return true -- neither boundary would be crossed
end

local function mineStep(down, up)
  down = down or false
  up = up or false
  if not checkNextStep() then return false end -- if you can't make another step return false

  ta.dig()
  ta.moveForward()
  if not up then ta.digUp() end
  if not down then ta.digDown() end
  return true
end

local function turn(down, up)
  down = down or false
  up = up or false
  if dir then
    ta.rotateRight()
    if not mineStep(down, up) then return false end
    ta.rotateRight()
    dir = not dir
  else
    ta.rotateLeft()
    if not mineStep(down, up) then return false end
    ta.rotateLeft()
    dir = not dir
  end

  return true
end

local function mineLayer(layer)
  while true do
    if not mineStep(layer.down, layer.up) then
      if not turn(layer.down, layer.up) then
        if layer.down then -- if this was the last layer, lets stop
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

local function mine(area)
  local layer
  if variables.finished or done then -- done is just unnecessary safety
    return returnToStart()
  end

  -- reset for recalculation
  layer.down = false
  layer.up = false

  -- get into the right height to run mineLayer()
  if ta.variables.y+1 > targety then -- super not sure if this "+1" will work or not
    while not ((math.abs(starty - ta.variables.y) - 1) % 3) == 0 do -- checks if the turtle is in the right position to mine
      ta.digDown()
      ta.moveDown()
    end
  else
    layer.down = true -- if we're on the bottom layer, don't mine down
  end

  if starty - targety == 0 then layer.up = true end -- if we're digging 1 high hole, don't dig up

  dir = math.ceil((math.abs(starty - ta.variables.y)) / 3) % 2 == 1 -- can be merged down

  layer = { -- could just use startx targetx etc instead
    x1=area.x1,
    x2=area.x2,
    z1=area.z1,
    z2=area.z2
  }

  if not layer.down then ta.digDown() end
  mineLayer(layer)

  return false -- hopefully this doesn't break anything
end

local function start()
  -- could move this directly into mine down below... nicer to read this way
  local area = {
    x1 = startx,
    y1 = starty,
    z1 = startz,
    x2 = targetx,
    y2 = targety,
    z2 = targetz
  }

  local file = fs.open("resume", "w")
  file.write("shell.run('programs/miner.lua', 'resume')")
  file.close()

  while not done do
    print("area: "..textutils.serialise(area))
    mine(area)
  end

  print("Finished mining. Over and out.")
end

-- Main program

if (#tArgs == 0) or (tArgs[1] == "help") then -- if program was not started with the right arguments
  print("Miner program.")
  print("usage: miner [length] [width] [depth]")
  print("length - forward, width - right, depth - down")

  return true
elseif tArgs[1] == "resume" then -- if program is resuming
  startx = variables.sx
  starty = variables.sy
  startz = variables.sz

  targetx = variables.tx
  targety= variables.ty
  targetz = variables.tz
else
  startx = variables.x
  starty = variables.y
  startz = variables.z

  targetx = startx + tArgs[2]--width not right?! !!!!!!!!!! (goes left instead of right) (check ta movement separately!)
  targety= starty - tArgs[3]--depth
  targetz = startz - tArgs[1]--length

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

start()
