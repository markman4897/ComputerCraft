local scanInterval = 0.2
local renderInterval = 0.05
local scannerRange = 8
local scannerWidth = scannerRange * 2 + 1

local size = 0.5
local cellSize = 16
local offsetX = 75
local offsetY = 75

local ores = {
	["minecraft:diamond_ore"] = 10,
	["minecraft:emerald_ore"] = 10,
	["minecraft:gold_ore"] = 8,
	["minecraft:redstone_ore"] = 5,
	["minecraft:lapis_ore"] = 5,
	["minecraft:iron_ore"] = 2,
	["minecraft:coal_ore"] = 1
}

local colours = {
	["minecraft:coal_ore"] = { 150, 150, 150 },
	["minecraft:iron_ore"] = { 255, 150, 50 },
	["minecraft:lava"] = { 150, 75, 0 },
	["minecraft:gold_ore"] = { 255, 255, 0 },
	["minecraft:diamond_ore"] = { 0, 255, 255 },
	["minecraft:redstone_ore"] = { 255, 0, 0 },
	["minecraft:lapis_ore"] = { 0, 50, 255 },
	["minecraft:emerald_ore"] = { 0, 255, 0 }
}

local modules = peripheral.find("neuralInterface")
if not modules then error("Must have a neural interface", 0) end
if not modules.hasModule("plethora:scanner") then error("The block scanner is missing", 0) end
if not modules.hasModule("plethora:glasses") then error("The overlay glasses are missing", 0) end

local canvas = modules.canvas()
canvas.clear()

local block_text = {}
local blocks = {}
for x = -scannerRange, scannerRange, 1 do
	block_text[x] = {}
	blocks[x] = {}

	for z = -scannerRange, scannerRange, 1 do
		block_text[x][z] = canvas.addText({ 0, 0 }, " ", 0xFFFFFFFF, size)
		blocks[x][z] = { y = nil, block = nil }
	end
end

canvas.addText({ offsetX, offsetY }, "^", 0xFFFFFFFF, size * 2)

local function scan()
	while true do
		local scanned_blocks = modules.scan()

		for x = -scannerRange, scannerRange do
			for z = -scannerRange, scannerRange do
				local best_score, best_block, best_y = -1
				for y = -scannerRange, scannerRange do

					local scanned = scanned_blocks[scannerWidth ^ 2 * (x + scannerRange) + scannerWidth * (y + scannerRange) + (z + scannerRange) + 1]

					if scanned then
						local new_score = ores[scanned.name]
						if new_score and new_score > best_score then
							best_block = scanned.name
							best_score = new_score
							best_y = y
						end
					end
				end

				-- Update our block table with this information.
				blocks[x][z].block = best_block
				blocks[x][z].y = best_y
			end
		end

		sleep(scanInterval)
	end
end

local function render()
	while true do

		local meta = modules.getMetaOwner and modules.getMetaOwner()
		local angle = meta and math.rad(-meta.yaw % 360) or math.rad(180)

		for x = -scannerRange, scannerRange do
			for z = -scannerRange, scannerRange do
				local text = block_text[x][z]
				local block = blocks[x][z]

				if block.block then

					local px = math.cos(angle) * -x - math.sin(angle) * -z
					local py = math.sin(angle) * -x + math.cos(angle) * -z

					local sx = math.floor(px * size * cellSize)
					local sy = math.floor(py * size * cellSize)
					text.setPosition(offsetX + sx, offsetY + sy)

					text.setText(tostring(block.y))
					text.setColor(table.unpack(colours[block.block]))
				else

					text.setText(" ")
				end
			end
		end

		sleep(renderInterval)
	end
end

parallel.waitForAll(render, scan)
