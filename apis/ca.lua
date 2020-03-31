--CC

-- COMPUTER API (ca)

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
