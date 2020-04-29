-- get this to root of disk and name it "startup"

if fs.exists("startup") then
  shell.run("startup", "uninstall", "true")
  fs.delete("startup")
end

shell.run("wget", "http://84.41.40.10:8080/startup.lua", "startup")
shell.run("startup")

--[[ --optional for quick naming
print("Do you want to name it 'mining_turtle'? (Y/n)")
decision = read() -- might wanna disable this tho

if not (decision == "y" or decision == "Y" or decision == "yes" or decision == "Yes" or decision == "YES") then
  shell.run("label", "set", "mining_turtle")
--]]
