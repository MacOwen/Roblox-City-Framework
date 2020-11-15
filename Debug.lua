local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local Player = game.Players.LocalPlayer

local PlayerScripts = Player:WaitForChild("PlayerScripts")
local PlayerGui = Player:WaitForChild("PlayerGui")
local Modules = PlayerScripts:WaitForChild("Modules")

local LocalData = require(PlayerScripts:WaitForChild("LocalData"))

ChunkData = LocalData.ChunkData
EntityData = LocalData.EntityData
ModuleData = LocalData.ModuleData
ModelData = LocalData.ModelData

local DebugMenu,
		FramesCounter,
		EntityCount,
		ModuleCount,
		ModelCount,
		ChunkEntityUpdateTime,
		LooseEntityUpdateTime,
		InteriorEntityUpdateTime,
		ChunkCountTotal,
		ChunkCountHigh,
		ChunkCountLow,
		ChunkUpdateTime
local guiOpen = false
local fps = 0

function roundString(num,increment)
	if num<increment then return "<" .. tostring(increment) .. "s" else return tostring(num-num%increment) .. "s" end
end

--Load all gui text elements
function loadGui()
	DebugMenu = PlayerGui:WaitForChild("Debug")
	
	
	FramesCounter = DebugMenu:WaitForChild("FramesCounter")
	
	ModuleCount = DebugMenu:WaitForChild("ModuleCount")
	ModelCount = DebugMenu:WaitForChild("ModelCount")
	EntityCount = DebugMenu:WaitForChild("EntityCount")
		ChunkEntityUpdateTime = DebugMenu:WaitForChild("ChunkEntityUpdateTime")
		LooseEntityUpdateTime = DebugMenu:WaitForChild("LooseEntityUpdateTime")
		InteriorEntityUpdateTime = DebugMenu:WaitForChild("InteriorEntityUpdateTime")
	ChunkCountTotal = DebugMenu:WaitForChild("ChunkCountTotal")
	ChunkCountHigh = DebugMenu:WaitForChild("ChunkCountHigh")
	ChunkCountLow = DebugMenu:WaitForChild("ChunkCountLow")
		ChunkUpdateTime = DebugMenu:WaitForChild("ChunkUpdateTime")
end
loadGui()


--Update all text in debug screen
function updateGui()
	ModuleCount.Text = "loaded modules: " .. ModuleData.numModules
	ModelCount.Text = "loaded models: " .. ModelData.numModels
	EntityCount.Text = "total entities: " .. EntityData.numEntities
		ChunkEntityUpdateTime.Text = "    chunkentity update time: " .. roundString(EntityData.cUpdateTime,0.001)
		
	--ChunkCountTotal.Text = 
		ChunkUpdateTime.Text = "    chunk update time: " .. roundString(ChunkData.updateTime,0.001)
end

--Updates FPS counter
function updateFPS()
	FramesCounter.Text = "FPS: " .. tostring(fps)
end



UserInputService.InputBegan:Connect(function(key,g)
	if key.KeyCode == Enum.KeyCode.F10 then
		guiOpen = not guiOpen
		DebugMenu.Enabled = guiOpen
	end
end)

RunService.RenderStepped:Connect(function(dt)
	fps = math.floor(1/dt)
	if guiOpen then updateGui() end
end)


spawn(function()
	while true do
		updateFPS()
		wait(1)
	end
end)