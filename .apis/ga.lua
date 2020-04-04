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

--]]

-- =================
--   Log functions
-- =================

function printLog(input, color) -- TODO: delete this sooner or later
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



-- ===================
--   Other functions
-- ===================

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
