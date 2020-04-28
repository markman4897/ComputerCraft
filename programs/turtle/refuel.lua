--CC

-- makeshift program to quickly refuel from first four slots

while not (turtle.getFuelLevel() == 20000) do
  turtle.suck()
  turtle.refuel()
  turtle.drop()
  sleep(0.8)
end
