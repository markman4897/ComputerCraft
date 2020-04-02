--CC

-- TURTLE API (ta)

-- IMPORTANT!!!
-- This library predicts that you have in your turtle inventory:
-- 1st slot: ender chest for depositing
-- 1st slot: ender chest for fuel

-- TODO::
-- - prettify code like while not place, attack etc. to local functions and make
--   a nonviolent option (wait instead of attack) for indoor use

-- This is the API for most used general turtle commands

-- Variables
os.loadAPI("apis/fv.lua")
variables = fv.read()

fuelCap = turtle.getFuelLimit()

violent = true

-- Rotate functions

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
  local temp = fv.translate(direction)
  while variables.dirx ~= temp[1] or variables.dirz ~= temp[2]  do
    rotateRight()
  end
end

-- Move functions

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
    local temp = forward() -- should this be local?

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

-- if this returns false it still rotated!!
function moveLeft()
  rotateLeft()

  return moveForward()
end

-- if this returns false it still rotated!!
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

-- Dig functions

function dig()
  if quick_check_inv_full() then deposit() end
  return turtle.dig()
end

function digUp()
  if quick_check_inv_full() then deposit() end
  return turtle.digUp()
end

function digDown()
  if quick_check_inv_full() then deposit() end
  return turtle.digDown()
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

-- Special functions

function check_inv_full()
  for i=3,16 do
    turtle.select(i)
    if turtle.getItemCount() == 0 then
      return false
    end
  end

  return true
end

function quick_check_inv_full()
  turtle.select(16)
  if turtle.getItemCount() == 0 then
    return false
  end

  return true
end

-- TODO:: prettify to use fv.translate and keep original direction and then turn
--        back
function findSpaceAndPlace()
  while true do
    -- look forward for space
    if not turtle.detect() then
      while not turtle.place() do
        turtle.attack()
      end

      return "front"
    end

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

  local space = findSpaceAndPlace()

  if space == "left" then
    for i=2,16 do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1)
    turtle.dig()
    rotateRight()

  elseif space == "right" then
    for i=2,16 do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1)
    turtle.dig()
    rotateLeft()

  elseif space == "back" then
    for i=2,16 do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1)
    turtle.dig()
    rotateLeft()
    rotateLeft()
  elseif space == "up" then
    for i=2,16 do
      turtle.select(i)
      turtle.dropUp(turtle.getItemCount())
    end

    turtle.select(1)
    turtle.digUp()
  elseif space == "down" then
    for i=2,16 do
      turtle.select(i)
      turtle.dropDown(turtle.getItemCount())
    end

    turtle.select(1)
    turtle.digDown()
  elseif space == "front" then
    for i=2,16 do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1)
    turtle.dig()
  else
    print("Problem with findSpaceAndPlace() output in function deposit()")
  end

end

-- This will assume you have the right inventory placement!
function refuel()
  turtle.select(2)

  local space = findSpaceAndPlace()

  if space == "left" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suck(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.drop(itemCount)

    turtle.dig()
    rotateRight()
  elseif space == "right" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suck(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.drop(itemCount)

    turtle.dig()
    rotateLeft()
  elseif space == "back" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suck(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.drop(itemCount)

    turtle.dig()
    rotateLeft()
    rotateLeft()
  elseif space == "up" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suckUp(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.dropUp(itemCount)

    turtle.digUp()
  elseif space == "down" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suckDown(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.dropDown(itemCount)

    turtle.digDown()
  elseif space == "front" then
    while turtle.getFuelLevel() < fuelCap do
      turtle.suck(64)
      turtle.refuel(64)
    end

    local itemCount = turtle.getItemCount()
    if itemCount > 0 then turtle.drop(itemCount)

    turtle.dig()
  else
    print("Problem with findSpaceAndPlace() output in function refuel()")
  end

  -- to reset cursor position
  turtle.select(1)

end
