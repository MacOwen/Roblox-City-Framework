--Local Script
local PlayerScripts = game.Players.LocalPlayer:WaitForChild("PlayerScripts")
local Modules = PlayerScripts:WaitForChild("Modules")
local Remotes = PlayerScripts:WaitForChild("Remotes")

local GraphicsUpdate = Remotes:WaitForChild("GraphicsUpdate")

local ChunkHandler = require(Modules:WaitForChild("ChunkHandler"))
local LocalData = require(PlayerScripts:WaitForChild("LocalData"))

local updateTime


ChunkHandler.Initialize()

--Graphics update event, refreshes entity loader and applies new settings
GraphicsUpdate.Event:Connect(function()
	print("ChunkHandler graphics update")
	updateTime = LocalData.Graphics.Chunks.updateTime
	
	ChunkHandler.UpdateGraphics()
end)

updateTime = LocalData.Graphics.Chunks.updateTime

--VV Function no longer exists VV
--ChunkHandler.UpdateGraphics()
spawn(function()
	while true do
		wait(updateTime)
		ChunkHandler.Update()
	end
end)