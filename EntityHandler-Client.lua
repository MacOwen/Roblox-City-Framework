--Local Script
local PlayerScripts = game.Players.LocalPlayer:WaitForChild("PlayerScripts")
local Modules = PlayerScripts:WaitForChild("Modules")
local Remotes = PlayerScripts:WaitForChild("Remotes")
	local GraphicsUpdate = Remotes:WaitForChild("GraphicsUpdate")
	local ModuleRequester = Remotes:WaitForChild("ModuleRequester")
	local LoadChunkEntities = Remotes:WaitForChild("LoadChunkEntities")


local EntityHandler = require(Modules:WaitForChild("EntityHandler"))
local LocalData = require(PlayerScripts:WaitForChild("LocalData"))


local updateTime = 5


EntityHandler.LoadDefaults()


--Graphics update event, refreshes entity loader and applies new settings
GraphicsUpdate.Event:Connect(function()
	print("EntityHandler graphics update")
	updateTime = LocalData.Graphics.Entities.updateTime
	
	EntityHandler.UpdateGraphics()
end)

LoadChunkEntities.Event:Connect(function(chunkName)
	EntityHandler.LoadChunkEntities(chunkName)
end)

--Sends module name to EntityHandler module, returns module object reference
ModuleRequester.OnInvoke = function(moduleName)
	return EntityHandler.LoadModule(moduleName)
end



updateTime = LocalData.Graphics.Entities.updateTime
EntityHandler.UpdateGraphics()
spawn(function()
	while true do
		wait(updateTime)
		EntityHandler.Update()
	end
end)