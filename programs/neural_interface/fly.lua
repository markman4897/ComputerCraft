local modules = peripheral.find("neuralInterface")
if not modules then
    error("Must have a neural interface", 0)
end

if not modules.hasModule("plethora:sensor") then error("Must have a sensor", 0) end
if not modules.hasModule("plethora:scanner") then error("Must have a scanner", 0) end
if not modules.hasModule("plethora:introspection") then error("Must have an introspection module", 0) end
if not modules.hasModule("plethora:kinetic", 0) then error("Must have a kinetic agument", 0) end

local meta = {}
local hover = false

print("You might want to use keyboard in the neural interface.")

parallel.waitForAny(
    function()
        while true do
            local event, key = os.pullEvent()
            if event == "key" and key == keys.numPad8 then
                -- The O key launches you high into the air.
                modules.launch(0, -90, 3)
            elseif event == "key" and key == keys.space then
                -- The P key launches you a little into the air.
                modules.launch(0, -90, 0.6)
            elseif event == "key" and key == keys.leftAlt then
                -- The l key launches you in whatever direction you are looking.
                modules.launch(meta.yaw, meta.pitch, 0.8)
            elseif event == "key_up" and key == keys.k then
                -- Holding the K key enables "hover" mode. We disable it when it is released.
                if not hover then
                    hover = true
                    os.queueEvent("hover")
                else
                    hover = false
                end
            elseif event == "key_up" and key == keys.k then
            end
        end
    end,
    function()
        while true do
            meta = modules.getMetaOwner()
        end
    end,
    function()
        while true do
            if hover then
                -- We calculate the required motion we need to take
                local mY = meta.motionY
                mY = (mY - 0.138) / 0.8

                -- If it is sufficiently large then we fire ourselves in that direction.
                if mY > 0.5 or mY < 0 then
                    local sign = 1
                    if mY < 0 then sign = -1 end
                    modules.launch(0, 90 * sign, math.min(4, math.abs(mY)))
                else
                    sleep(0)
                end
            else
                os.pullEvent("hover")
            end
        end
    end,
    function()
        while true do
            local blocks = modules.scan()
            for y = 0, -8, -1 do
                -- Scan from the current block downwards
                local block = blocks[1 + (8 + (8 + y)*17 + 8*17^2)]
                if block.name ~= "minecraft:air" then
                    if meta.motionY < -0.3 then
                        -- If we're moving slowly, then launch ourselves up
                        modules.launch(0, -90, math.min(4, meta.motionY / -0.5))
                    end
                    break
                end
            end
        end
    end
)
