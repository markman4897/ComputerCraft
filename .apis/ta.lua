--CC

--[[
=====================
 TURTLE API (1.0.0)
=====================
made by markman4897

 ~ This API is made to be the backbone for most all turtle programs

Setup for inventory:
 - [1] slot: Ender chest for depositing
 - [2] slot: Ender chest for fuel (hard fuels like coal, charcoal, blaze rods..)

How to use:
 - Consult the code, functions are very basic or self explanatory

Comments:
 - Programs using this should specify if they don't want the turtle to attack
   when trying to move (be non violent)

TODO:
 - make logs and make them print only if logs are enabled (use ga.lua!)
 - make refuel and deposit functions an extension of findSpaceAndPlace somehow
 - make so that functions take optional arguments for repetition

--]]

-- ========
--   APIs
-- ========

os.loadAPI(".apis/fv.lua")


-- =============
--   Variables
-- =============

variables = fv.read()

fuelCap = turtle.getFuelLimit()

violent = true -- does it attack or does it wait if it cant move
-- i dont think this works the way it should?

-- does it force direction to deposit and refuel
force = {}
force.up = false
force.down = false
-- #? WILL THIS BE AFFECTED WHEN IT GETS CHANGED FROM OTHER PROGRAMS? - no?
-- and how will this be handled on restarts? (should be coded into programs)

-- from where to where does the turtle deposit stuff
start = 3
stop = 16

-- if you want functions to display logs or not
logs = false -- not yet implemented

-- ====================
--   Rotate functions
-- ====================

function rotateLeft()
  turtle.turnLeft()
  variables.dirx, variables.dirz = variables.dirz, -variables.dirx
  fv.write({dirx=variables.dirx, dirz=variables.dirz})

end

function rotateRight()
  turtle.turnRight()
  variables.dirx, variables.dirz = -variables.dirz, variables.dirx
  fv.write({dirx=variables.dirx, dirz=variables.dirz})
end

function rotateBack()
  rotateLeft()
  rotateLeft()
end

function turnTo(direction)
  local temp = translate(direction)
  while variables.dirx ~= temp[1] or variables.dirz ~= temp[2]  do
    rotateRight()
  end
end

-- ==================
--   Move functions
-- ==================

local function forward()
  if turtle.getFuelLevel() < 1 then refuel() end
  for i=1,5 do
    if not turtle.forward() then
      if violent then
        turtle.attack()
        os.sleep(0.2)
      else
        os.sleep(0.5)
      end
    else
      return true
    end
  end

  return false
end

local function back()
  if not turtle.back() then
    turtle.turnLeft()
    turtle.turnLeft()
    local temp = forward()

    turtle.turnLeft()
    turtle.turnLeft()
    return temp
  else
    return true
  end
end

local function up()
  if turtle.getFuelLevel() < 1 then refuel() end
  for i=1,5 do
    if not turtle.up() then
      if violent then
        turtle.attackUp()
        os.sleep(0.2)
      else
        os.sleep(0.5)
      end
    else
      return true
    end
  end

  return false
end

local function down()
  if turtle.getFuelLevel() < 1 then refuel() end
  for i=1,5 do
    if not turtle.down() then
      if violent then
        turtle.attackDown()
        os.sleep(0.2)
      else
        os.sleep(0.5)
      end
    else
      return true
    end
  end

  return false
end

-- maybe could merge upper functions into lower functions

function moveForward()
  if forward() then
    variables.x = variables.x + variables.dirx
    variables.z = variables.z + variables.dirz
    fv.write({x=variables.x, z=variables.z})

    return true
  else
    return false
  end
end

function moveBack()
  if back() then
    variables.x = variables.x + variables.dirx
    variables.z = variables.z + variables.dirz
    fv.write({x=variables.x, z=variables.z})

    return true
  else
    return false
  end
end

function moveUp()
  if up() then
    variables.y = variables.y + 1
    fv.write({y=variables.y})

    return true
  else
    return false
  end
end

function moveDown()
  if down() then
    variables.y = variables.y - 1
    fv.write({y=variables.y})

    return true
  else
    return false
  end
end

-- #! if I fix this, should update miner.lua too!
-- #! if this returns false it still rotated!!
function moveLeft()
  rotateLeft()

  return moveForward()
end

-- #! if this returns false it still rotated!!
function moveRight()
  rotateRight()

  return moveForward()
end

function moveTo(x,y,z)
  -- move on z axis
  if z < variables.z then
    turnTo("north")
  elseif z > variables.z then
    turnTo("south")
  end
  while not (z == variables.z) do
    if not moveForward() then moveUp() end
  end
  -- move on x axis
  if x < variables.x then
    turnTo("west")
  else
    turnTo("east")
  end
  while not (x == variables.x) do
    if not moveForward() then moveUp() end
  end
  -- move on y axis
  while not (y == variables.y) do
    if y < variables.y then moveDown()
    else moveUp() end
  end

end

-- =================
--   Dig functions
-- =================

function dig()
  if quick_check_inv_full() then deposit() end

  if turtle.detect() then
    turtle.dig() -- because if detect we know there is a block
    while turtle.detect() do -- if there is gravity blocks
      turtle.dig()
    end

    return true
  else
    return false
  end
end

function digUp()
  if quick_check_inv_full() then deposit() end

  if turtle.detectUp() then
    turtle.digUp()
    while turtle.detectUp() do
      turtle.digUp()
    end

    return true
  else
    return false
  end
end

function digDown()
  if quick_check_inv_full() then deposit() end

  if turtle.detectDown() then
    turtle.digDown()
    while turtle.detectDown() do -- #! this might be totally pointless but hey
      turtle.digDown()
    end

    return true
  else
    return false
  end
end

function digRight()
  rotateRight()
  return dig()
end

function digLeft()
  rotateLeft()
  return dig()
end

function digBack()
  rotateBack()
  return dig()
end

function digTo() -- #!to be tested!
  -- move on z axis
  if z < variables.z then
    turnTo("north")
  elseif z > variables.z then
    turnTo("south")
  end
  while not (z == variables.z) do
    dig()
    moveForward()
  end
  -- move on x axis
  if x < variables.x then
    turnTo("west")
  else
    turnTo("east")
  end
  while not (x == variables.x) do
    dig()
    moveForward()
  end
  -- move on y axis
  while not (y == variables.y) do
    if y < variables.y then
      digDown()
      moveDown()
    else
      digUp()
      moveUp()
    end
  end

end

-- =====================
--   Special functions
-- =====================

function translate(input)
  if input == "north" then return {0,-1}
  elseif input == "south" then return {0,1}
  elseif input == "east" then return {1,0}
  elseif input == "west" then return {-1,0}
  elseif input[1] == 0 and input[2] == -1 then return "north"
  elseif input[1] == 0 and input[2] == 1 then return "south"
  elseif input[1] == 1 and input[2] == 0 then return "east"
  elseif input[1] == -1 and input[2] == 0 then return "west" end
end

function placeDir(direction) -- maybe this will get handy in the future
  print("im a place function")
end

function digDir(direction) -- maybe this will get handy in the future
  print("im a break function")
end

function checkInvSetup()
  if start == 1 then return true end -- just in case...

  for i=1,start-1 do -- checks inventory to where it starts depositing
    turtle.select(i)
    if turtle.getItemCount() == 0 then
      print("You forgot to insert ender chests!")
      return false
    end
  end

  return true
end

function check_inv_full()
  for i=3,16 do
    turtle.select(i)
    if turtle.getItemCount() == 0 then
      return false
    end
  end

  turtle.select(1)

  return true
end

function quick_check_inv_full()
  turtle.select(16)
  if turtle.getItemCount() == 0 then
    turtle.select(1)
    return false
  end

  turtle.select(1)

  return true
end

-- This will assume you know where the deposit chest is
function depositTo(direction)
  if direction == "up" then
    for i=start,stop do
      turtle.select(i)
      turtle.dropUp(turtle.getItemCount())
    end

    turtle.select(1) -- to reset cursor position
  elseif direction == "down" then
    for i=start,stop do
      turtle.select(i)
      turtle.dropDown(turtle.getItemCount())
    end

    turtle.select(1) -- to reset cursor position
  elseif direction == "front" then
    for i=start,stop do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1) -- to reset cursor position
  end
end --[[ asdfasdfasdfasdfasdfasdf
asdfasdfasdfasdfadsf
asdfsadfadsfasdf --]]

-- TODO:: - prettify to use fv.translate and keep original direction and then
--          turn back
--        - maybe make it just findSpace... and make place separate where it
--          recieves function as an argument on what to do then
--        - then make it so this function rotates back how it was originally
function findSpaceAndPlace()
  while true do
    -- look up for space
    if not turtle.detectUp() then
      while not turtle.placeUp() do
        turtle.attackUp()
      end

      return "up"
    end

    -- look down for space
    if not turtle.detectDown() then
      while not turtle.placeDown() do
        turtle.attackDown()
      end

      return "down"
    end

    -- look forward for space
    if not turtle.detect() then
      while not turtle.place() do
        turtle.attack()
      end

      return "front"
    end

    -- look left for space
    rotateLeft()
    if not turtle.detect() then
      while not turtle.place() do
        turtle.attack()
      end

      return "left"
    end

    -- look Back for space
    rotateLeft()
    if not turtle.detect() then
      while not turtle.place() do
        turtle.attack()
      end

      return "back"
    end

    -- look Right for space
    rotateLeft()
    if not turtle.detect() then
      while not turtle.place() do
        turtle.attack()
      end

      return "right"
    end

  end

end

-- This will assume you have the right inventory placement!
function deposit()
  turtle.select(1)
  local space = "" -- initialise variable, might not be needed

  if force.up then
    while not turtle.placeUp() do
      if violent then
        turtle.attackUp()
        os.sleep(0.2)
      else
        os.sleep(0.5)
      end
      turtle.digUp() -- might waste 1 resource block...
    end

    space = "up"

  elseif force.down then
    while not turtle.placeDown() do
      if violent then
        turtle.attackDown()
        os.sleep(0.2)
      else
        os.sleep(0.5)
      end
      turtle.digDown() -- might waste 1 resource block...
    end

    space = "down"
  else
    space = findSpaceAndPlace()
  end

  if space == "left" then
    for i=start,stop do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1) -- to reset cursor position
    turtle.dig()
    rotateRight()

  elseif space == "right" then
    for i=start,stop do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1) -- to reset cursor position
    turtle.dig()
    rotateLeft()

  elseif space == "back" then
    for i=start,stop do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1) -- to reset cursor position
    turtle.dig()
    rotateLeft()
    rotateLeft()
  elseif space == "up" then
    for i=start,stop do
      turtle.select(i)
      turtle.dropUp(turtle.getItemCount())
    end

    turtle.select(1) -- to reset cursor position
    turtle.digUp()
  elseif space == "down" then
    for i=start,stop do
      turtle.select(i)
      turtle.dropDown(turtle.getItemCount())
    end

    turtle.select(1) -- to reset cursor position
    turtle.digDown()
  elseif space == "front" then
    for i=start,stop do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1) -- to reset cursor position
    turtle.dig()
  else
    print("Problem with findSpaceAndPlace() output in function deposit()")
  end

end

-- This will assume you have the right inventory placement!
function refuel()
  local space = "" -- initialise variable, might not be needed
  turtle.select(2)

  if force.up then
    while not turtle.placeUp() do
      if violent then
        turtle.attackUp()
        os.sleep(0.2)
      else
        os.sleep(0.5)
      end
      turtle.digUp() -- might waste 1 resource block...
    end

    space = "up"

  elseif force.down then
    while not turtle.placeDown() do
      if violent then
        turtle.attackDown()
        os.sleep(0.2)
      else
        os.sleep(0.5)
      end
      turtle.digDown() -- might waste 1 resource block...
    end

    space = "down"
  else
    space = findSpaceAndPlace()
  end

  turtle.select(2)

  if space == "left" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suck(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.drop(itemCount) end

    turtle.dig()
    rotateRight()
  elseif space == "right" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suck(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.drop(itemCount) end

    turtle.dig()
    rotateLeft()
  elseif space == "back" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suck(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.drop(itemCount) end

    turtle.dig()
    rotateLeft()
    rotateLeft()
  elseif space == "up" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suckUp(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.dropUp(itemCount) end

    turtle.digUp()
  elseif space == "down" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suckDown(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.dropDown(itemCount) end

    turtle.digDown()
  elseif space == "front" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suck(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.drop(itemCount) end
    turtle.dig()
  else
    print("Problem with findSpaceAndPlace() output in function refuel()")
  end

  -- to reset cursor position
  turtle.select(1)

end

-- reset cursor just in case...
turtle.select(1) -- not sure if this helps, but it sure can't hurt
