--CC

-- COMPUTER API (ca)
-- General api (not just for computers)

-- Printing Logs functions

function printLog(input, color)
  -- if its advanced use colours
  print(input)
end

-- Print info
function pInfo(input)
  printLog("[INFO] "..input, "green")
end

-- Print warning
function pWarn(input)
  printLog("[WARN] "..input, "orange")
end

-- Print error
function pErr(input)
  printLog("[error] "..input, "red")
end

-- Determine current device

local function getDeviceType()
  if turtle then
    return "turtle"
  elseif pocket then
    return "pocket"
  elseif commands then
    return "command_computer"
  else
    return "computer"
  end
end
