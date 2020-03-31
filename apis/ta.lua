--CC

-- TURTLE API (ta)

-- IMPORTANT!!!
-- This library predicts that you have in your turtle inventory:
-- 1st slot: ender chest for depositing
-- 1st slot: ender chest for fuel

-- TODO::
-- - prettify code like while not place, attack etc. to local functions and make
--   a nonviolent option (wait instead of attack) for indoor use
-- - add turnTo() function
-- - add moveTo(x,y,z) function

-- This is the API for most used general turtle commands

local file = fs.open("globalVariables.cfg", "r")
variables = textutils.unserialise(file.readAll())
file.close()
os.loadAPI("/apis/fv.lua")
variables = fv.read()

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
  while variables.dirx ~= temp[1] and variables.dirz ~= temp[2]  do
    rotateLeft()
  end
end

-- Move functions

-- TODO:: make so they try for a certain time and then return false instead

function moveForward()
  while not turtle.forward() do
    turtle.attack()
  end

  variables.x = variables.x + variables.dirx
  variables.z = variables.z + variables.dirz
  fv.write({x=variables.x, z=variables.z})
end

function moveBack()
  if not turtle.back() then
    turtle.turnLeft()
    turtle.turnLeft()

    while not turtle.forward() do
      turtle.attack()
    end

    turtle.turnLeft()
    turtle.turnLeft()

  end

  variables.x = variables.x + variables.dirx
  variables.z = variables.z + variables.dirz
  fv.write({x=variables.x, z=variables.z})
end

function moveUp()
  while not turtle.up() do
    turtle.attackUp()
  end

  variables.y = variables.y + 1
  fv.write({y=variables.y})
end

function moveDown()
  while not turtle.down() do
    turtle.attackDown()
  end

  variables.y = variables.y - 1
  fv.write({y=variables.y})
end

function moveLeft()
  rotateLeft()
  moveForward()
end

function moveRight()
  rotateRight()
  moveForward()
end

function moveTo(x,y,z)
  -- move on z axis
  if z < variables.z then
    turnTo("north")
  else
    turnTo("south")
  end
  while (not z == variables.z) do
    if not moveForward() then moveUp() end
  end
  -- move on x axis
  if x < variables.x then
    turnTo("west")
  else
    turnTo("east")
  end
  while (not x == variables.x) do
    if not moveForward() then moveUp() end
  end
  -- move on y axis
  while (not y == variables.y) do
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
