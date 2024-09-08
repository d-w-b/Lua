local ServerScriptService= game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local DataStore = require(ServerStorage.Class.DataStore)
local FTQDataStore = DataStore.new("FTQ")

local PlayerDataManager= require(ServerScriptService.Modules.PlayerDataManager)

local function loadPlayerData(player : Player)
	local playerData = PlayerDataManager.fetchData( player )
	PlayerDataManager.SetDataOnMemory( player, playerData )
	return playerData
end

type PlayerData = {
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
	skill: string,
	equippedTool : Tool
}

local function setupShield(player)
	local animation = nil
	local character = player.Character
	local humanoid = character.Humanoid
	local shieldModel = ServerStorage.Model.Shield:Clone()
	shieldModel.PrimaryPart:PivotTo(character.WorldPivot)
	shieldModel.PrimaryPart.Transparency = 0
	shieldModel.Parent = character
	wait(0.3)
	shieldModel.PrimaryPart.Transparency = 1
end

local function setupCharacterStatus(
	player: Player,
	playerData : PlayerData
)
	local character = player.Character
	for key, value in pairs(playerData) do
		if type(value) ~= "table" then
			local StringValue = Instance.new("StringValue")
			StringValue.Name = key
			StringValue.Value = value
			StringValue.Parent = character
		end
	end
	
	local equippedTool = character["equippedTool"].Value
	local tool = ReplicatedStorage:WaitForChild("Model"):WaitForChild("Tools")[ equippedTool ]:Clone()
	
	tool.Parent = character
	
	--local shieldValue = tonumber( character["shield"].Value )
	--if shieldValue > 0  then
	--	setupShield(player)
	--end
end




Players.PlayerAdded:Connect(
	function(player : Player)
		PlayerDataManager.resetData(player)
		local playerData = loadPlayerData(player)
		setupCharacterStatus(player, playerData)
	end
)