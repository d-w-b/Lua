local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStore = require(ServerStorage.Class.DataStore)
local TycoonDataStore = DataStore.new("Tycoon")
local MemoryStoreService = game:GetService("MemoryStoreService")
local hashMap = MemoryStoreService:GetHashMap("TycoonHashMap")
local Objects = ReplicatedStorage:WaitForChild("Objects")
local PlayerDataManager = {}

local EXPIRATION_LIMIT = 3000 

type Data = {}

local startNode = 1
local defaultData = {
	visited = {},
	points = 0
}


for i = 1, #Objects:GetChildren()  do
	defaultData.visited[i] = false
end
defaultData.visited[1] = true

function PlayerDataManager.fetchData(player: Player)
	local data = TycoonDataStore:GetData(player)
	if data == nil then
		data = defaultData
		TycoonDataStore:SaveData( player, data )
	end

	PlayerDataManager.SetDataOnMemory(player , data)
	return data
end

function PlayerDataManager.resetData(
	player : Player
)
	TycoonDataStore:RemoveData(player)
	TycoonDataStore:SaveData( player, defaultData )
end


function PlayerDataManager.GetPlayerData(player : Player)
	local playerData = PlayerDataManager.GetDataFromMemory(player)
	if not playerData then
		playerData = PlayerDataManager.fetchData(player)
	end
	return playerData
end

function PlayerDataManager.GetDataFromDataStore(
	player:Player
)
	local item
	local success, result = pcall( 
		function()
			item = TycoonDataStore:GetData(player)
		end
	)
	if success then
		return item
	end
end

function PlayerDataManager.SetDataToDataStore(
	player : Player,
	data : Data
)
	TycoonDataStore:SaveData(player, data)
end

function PlayerDataManager.SetDataOnMemory(
	player : Player,
	data : Data
)
	local setSuccess, _ = pcall(
		function()
			hashMap:SetAsync(player.UserId, data, EXPIRATION_LIMIT)
		end
	)

	if setSuccess then
		print("Set Data On Memory Succeeded.")
		print(data)
	end

end

function PlayerDataManager.GetDataFromMemory(
	player: Player
)
	local item

	local getSuccess, getError = pcall(
		function()
			item = hashMap:GetAsync(player.UserId)
		end
	)

	if getSuccess then
		return item
	else
		warn(getError)
		return false
	end

end

return PlayerDataManager