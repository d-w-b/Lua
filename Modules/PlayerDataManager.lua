local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local DataStore = require(ServerStorage.Class.DataStore)
local FTQDataStore = DataStore.new("FTQ")
local MemoryStoreService = game:GetService("MemoryStoreService")
local hashMap = MemoryStoreService:GetHashMap("HashMap1")
local PlayerDataManager = {}

local EXPIRATION_LIMIT = 3000 


type Data = {
	id : number,
	level: number,
	gold : number,
	exp : number,
	maxHealth : number,
	health : number,
	heal: number,
	power : number,
	shield : number,
	pearl: number,
	backpack : table,
	equippedTool : Tool
}

local defaultData = {
	level  =  1,
	exp =  0,
	gold = 100,
	pearl = 0,
	power = 100,
	shield = 20,
	heal = 0,
	health = 100,
	maxHealth = 100,
	backpack = {"태극검","WaterBottle","TopHat","태극기_카펫","Branch","Pheonix shield","ElementStaff"},
	equippedTool = "태극검"
}


function PlayerDataManager.fetchData(player: Player)
	local data = FTQDataStore:GetData(player)
	if data == nil then
		data = defaultData
		FTQDataStore:SaveData( player, data )
	end
	
	PlayerDataManager.SetDataOnMemory(player , data)
	return data
end

function PlayerDataManager.resetData(
	player : Player
)
	FTQDataStore:RemoveData(player)
	FTQDataStore:SaveData( player, defaultData )
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
			item = FTQDataStore:GetData(player)
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
	FTQDataStore:SaveData(player, data)
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