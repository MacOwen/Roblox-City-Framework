--Global
local EntityFolder = game:WaitForChild("Workspace"):WaitForChild("Entities")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")


local EntityAssigner = ServerScriptService:WaitForChild("EntityAssigner")
local EntityLoader = ReplicatedStorage:WaitForChild("EntityLoader")

local GlobalData = require(ServerScriptService:WaitForChild("GlobalData"))
	local Entities = GlobalData.Entities
	local Modules = GlobalData.ServerEntityModules
	local MapEntityData = GlobalData.MapEntityData

local EntityHandlerReady = ServerScriptService:WaitForChild("EntityHandlerReady")

--Generates new entity ID
function generateId(numTries)
	local n=numTries
	if not numTries then n = 0 end
	if n>10 then error("More than 10 attempts to generate a new entity id") return end
	

	local key=tostring(math.random(0,999999999))
	if GlobalData.Entities[key]then
		return generateId(n+1)
	end
	return key
end





--Creates new entity (server sided)
EntityAssigner.OnInvoke = function(name,obj,data)
	local id = generateId()
	
	
	local module = Modules[name]
	
	if not id then warn("An ID was not properly generated") return end
	if not module then warn("module "..name.." does not exist") return end
	
	obj.Parent = EntityFolder
	local d = obj:FindFirstChild("Data") if data then d:Destroy() end
	
	module = require(module)

	local e = module.New(name,id,obj,data)
	Entities[id]=e
	
	e:Initialize()

	return e
end


--Handles players loading/unloading entities
--eType: 1=loose,2=chunk,3=interior
EntityLoader.OnServerInvoke = function(Player,keyword,eType,data)
	if keyword == "load" then
		if eType == 1 then
			--Loose
			for _,v in pairs(data)do
				--[[
				
				local chunkData = MapEntityData[v]
				local d = {}
				for _,id in pairs(chunkData) do
					if Entities[id] then table.insert(d,Entities[id].data) end
				end
				
				return d
				
				]]--
			end
		elseif eType == 2 then
			--Chunk, data = chunk name
			local d = {}
			local chunkData = MapEntityData[data]
			if not chunkData then print("Chunk contains no entities") return end
			
			for _,id in pairs(chunkData) do
				if Entities[id] then 
					local entity = Entities[id]
					local localCopy = {name=entity.name,id=entity.id,obj=entity.obj,data=entity.data}
					table.insert(d,localCopy) 
				end
			end
			
			return d
		elseif eType == 3 then
			--Interior
			
		else
			print("Player " .. Player.Name .. " sent EntityHandler request without proper eType (Must be either 1, 2, or 3)")
		end
	elseif keyword == "unload" then
			
	else
		warn("Player " .. Player.Name .. " sent EntityHandler request without proper keyword (Must be either \"load\" or \"unload\")")
	end
end




--Confirms this script is ready
EntityHandlerReady.Value = true