--CC

--[[
========================
 GENERAL API (version)
========================
made by markman4897

 ~ General api for functions that don't belong elsewhere

How to use:
 - Consult the code, functions are very basic or self explanatory

Comments:
 -

TODO:
 - make the api recognise if it is running on advanced or regular machine and
   use colors accordingly
 - use this for logging in other programs and APIs
 - maybe differentiate with terms.isColor() to get if its advanced or not
 - maybe pass that as a 2nd argument? (bool)

--]]

-- =================
--   Detect device
-- =================

-- Determine current device

function getDeviceType()
  if turtle then
    return "turtle"
  elseif peripheral.find("neuralInterface") then
    return "neural_interface"
  elseif pocket then
    return "pocket"
  elseif commands then
    return "command_computer"
  else
    return "computer"
  end
end

-- =================
--   Log functions
-- =================

function printLog(input, color)
  if term.isColor() then
    term.setTextColor(colors[color])
    print(input)
    term.setTextColor(colors.white)
  else
    print(input)
  end
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


-- ===================
--   Other functions
-- ===================

function placeholder()
  pWarn("Just a placeholder.")
end


-- ================
--   Main program
-- ================

deviceType = getDeviceType()
