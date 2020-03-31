--CC

-- This is a miner program, designed to excavate large (or small) areas and
-- survive restarts.
-- This program runs most efficiently if depth is a multiple of 3.

-- APIs

os.loadAPI("apis/ta.lua")
os.loadAPI("apis/fv.lua")

-- Variables

local tArgs = {...}

variables = fv.read()

local startx = variables.x
local starty = variables.y
local startz = variables.z

local targetx = 0
local targety = 0
local targetz = 0

-- Functions

local function mine(area)
  print(area)
end

-- Main program

if (#tArgs[] == 0) or (tArgs[1] == "help") then
  print("Miner program.")
  print("usage: miner [length] [width] [depth]")
  print("length - forward, width - right, depth - down")

  return true
elseif tArgs[1] == "resume"
  startx = variables.startx
  starty = variables.starty
  startz = variables.startz

  targetx = variables.targetx
  targety= variables.targety
  targetz = variables.targetz
else
  startx = variables.startx
  starty = variables.starty
  startz = variables.startz

  targetx = startx + tArgs[2]--width
  targety= starty - tArgs[3]--depth
  targetz = startz - tArgs[1]--length
end

local area = {
  x1 = startx,
  y1 = starty,
  z1 = startz,
  x2 = targetx,
  y2 = targety,
  z2 = targetz
}

mine(area)
