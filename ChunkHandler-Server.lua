--Global
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")


local ChunkLoader=ReplicatedStorage:WaitForChild("ChunkLoader")


local GlobalData = require(ServerScriptService:WaitForChild("GlobalData"))
local map = GlobalData.Map


function ScramblePartNames()
	local ids = {}
	
	local function genId()
		local key=tostring(math.random(0,999999999))
		if ids[key] then error("genId inside S_MapHandler had duplicate part id") return genId() end
		ids[key]=true
		return key
	end
	
	for _,chunk in pairs(map:GetChildren()) do
		if chunk["high"] then 
			for _,part in chunk["high"]:GetDescendants() do
				part.Name = genId()
			end
		end
		if chunk["low"] then 
			for _,part in chunk["low"]:GetDescendants() do
				part.Name = genId()
			end
		end
	end
end

function MapToData()
	local matNumbers = {[Enum.Material.SmoothPlastic]=0,[Enum.Material.Neon]=1}
	local data = {}
	
	
	local function partToData(obj)
		local id = obj.Name
		local matNumber = matNumbers[obj.Material]
		local transparency = obj.Transparency
		
		local shape
		if obj:IsA("Part") then shape = 0
		elseif obj:IsA("WedgePart") then shape = 1
		elseif obj:IsA("MeshPart") then shape = 2
		else error("Map part type exception") end

		local size = obj.Size
		local frame = obj.CFrame
		local color = obj.Color
		
		local meshId
		if obj:IsA("MeshPart") then meshId = obj.MeshId end
		
		return {id,matNumber,transparency,shape,size,frame,color,meshId}
	end
	
	local function textureToData(obj)
		local id = obj.Name
		local parent = obj.Parent.Name
		local transparency = obj.Transparency
		
		local color = obj.Color3
		
		local offU = obj.OffsetStudsU
		local offV = obj.OffsetStudsV
		local sizeU = obj.StudsPerTile
		
		local textureId = obj.Texture
	end
	
	
	for _,chunk in pairs(map:GetChildren()) do
		local partData = {}
		local textureData = {}
		local entityData = {}
		for _,part in pairs(chunk:GetDescendants()) do
			
		end
	end
	
	return data
end

ChunkLoader.OnServerInvoke = function(p,chunkName)
	if map[chunkName] then
		local chunkClone = map[chunkName].high:Clone()
		chunkClone.Parent = p.PlayerGui
		
		return chunkClone
	end
end