local link = "https://docs.google.com/spreadsheets/d/18TbWXR4-Xxccs4-E_9Lm3wg0f6H2Fg2LPvtFZKnkCLs/export?format=csv"
local fileName = "data.csv"
shell.run("wget", link, fileName)

local csv = fs.open(fileName, "r")
local cR = 1 -- counter row
local result = {}

while true do
  local line = csv.readLine()
  if not line then break end --EOF

  cC = 1 -- counter column
  last = ""
  out = {}

  for i in string.gmatch(line,"[^,]*") do
    if i ~= "" then
          out[cC] = i
          cC = cC+1
      elseif last == "" then
          out[cC] = i
          cC = cC+1
      end
      last = i
  end

  result[cR] = out
  cR = cR+1

end

csv.close()
fs.delete(fileName)

print("result[4][1] (4th row, 1st column)")
print(result[4][1])
