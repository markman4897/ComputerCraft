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

local file = fs.open("globalVariables.cfg", "r")
variables = textutils.unserialise(file.readAll())
file.close()
os.loadAPI("/apis/fv.lua")
variables = fv.read()

violent = true

-- Dig functions (placeholder for later)

function dig()
  turtle.dig()
end

function digUp()
  turtle.digUp()
end

function digDown()
  turtle.digDown()
end

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

function turnTo(direction)
  local temp = fv.translate(direction)
  while variables.dirx ~= temp[1] or variables.dirz ~= temp[2]  do
    rotateLeft()
  end
end

-- Move functions

local function forward()
  for i=1,3 do
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
  for i=1,3 do
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
  for i=1,3 do
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

-- Special functions

function inv_full()
  for i=3,16 do
    turtle.select(i)
    if turtle.getItemCount() == 0 then
      return false
    end
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
    turnLeft()
    if not turtle.detect() then
      while not turtle.place() do
        turtle.attack()
      end

      return "left"
    end

    -- look Back for space
    turnLeft()
    if not turtle.detect() then
      while not turtle.place() do
        turtle.attack()
      end

      return "back"
    end

    -- look Right for space
    turnLeft()
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
    turnRight()

  elseif space == "right" then
    for i=2,16 do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1)
    turtle.dig()
    turnLeft()

  elseif space == "back" then
    for i=2,16 do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1)
    turtle.dig()
    turnLeft()
    turnLeft()
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
    while turtle.getFuelLevel() < 20000 do
      turtle.suck(64)
      turtle.refuel(64)
    end

    turtle.dig()
    turnRight()
  elseif space == "right" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suck(64)
      turtle.refuel(64)
    end

    turtle.select(1)
    turtle.dig()
    turnLeft()
  elseif space == "back" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suck(64)
      turtle.refuel(64)
    end

    turtle.select(1)
    turtle.dig()
    turnLeft()
    turnLeft()
  elseif space == "up" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suckUp(64)
      turtle.refuel(64)
    end

    turtle.select(1)
    turtle.digUp()
  elseif space == "down" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suckDown(64)
      turtle.refuel(64)
    end

    turtle.select(1)
    turtle.digDown()
  elseif space == "front" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suck(64)
      turtle.refuel(64)
    end

    turtle.select(1)
    turtle.dig()
  else
    print("Problem with findSpaceAndPlace() output in function refuel()")
  end

end
