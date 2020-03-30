--CC

-- IMPORTANT!!!
-- This library predicts that you have in your turtle inventory:
-- 1st slot: ender chest for depositing
-- 1st slot: ender chest for fuel

-- This is the API for most used general turtle commands
local file = fs.open("globalVariables.cfg", "r")
variables = textutils.unserialise(file.readAll())
file.close()
os.loadAPI("/apis/fv.lua")
variables = fv.read()

function moveForwards()
  --placeholder
end

function moveBackwards()
  --placeholder
end

function moveUp()
  --placeholder
end

function moveDown()
  --placeholder
end

function rotateLeft()
  --placeholder
end

function rotateRight()
  --placeholder
end

function check_inv()
  --placeholder
end

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
    turtle.turnLeft()
    if not turtle.detect() then
      while not turtle.place() do
        turtle.attack()
      end

      return "left"
    end

    -- look Back for space
    turtle.turnLeft()
    if not turtle.detect() then
      while not turtle.place() do
        turtle.attack()
      end

      return "back"
    end

    -- look Right for space
    turtle.turnLeft()
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
    turtle.turnRight()
  elseif space == "right" then
    for i=2,16 do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1)
    turtle.dig()
    turtle.turnLeft()
  elseif space == "back" then
    for i=2,16 do
      turtle.select(i)
      turtle.drop(turtle.getItemCount())
    end

    turtle.select(1)
    turtle.dig()
    turtle.turnLeft()
    turtle.turnLeft()
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

function refuel()
  turtle.select(2)

  local space = findSpaceAndPlace()

  if space == "left" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suck(64)
      turtle.refuel()
    end

    turtle.dig()
    turtle.turnRight()
  elseif space == "right" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suck(64)
      turtle.refuel()
    end

    turtle.select(1)
    turtle.dig()
    turtle.turnLeft()
  elseif space == "back" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suck(64)
      turtle.refuel()
    end

    turtle.select(1)
    turtle.dig()
    turtle.turnLeft()
    turtle.turnLeft()
  elseif space == "up" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suckUp(64)
      turtle.refuel()
    end

    turtle.select(1)
    turtle.digUp()
  elseif space == "down" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suckDown(64)
      turtle.refuel()
    end

    turtle.select(1)
    turtle.digDown()
  elseif space == "front" then
    while turtle.getFuelLevel() < 20000 do
      turtle.suck(64)
      turtle.refuel()
    end

    turtle.select(1)
    turtle.dig()
  else
    print("Problem with findSpaceAndPlace() output in function refuel()")
  end

end
