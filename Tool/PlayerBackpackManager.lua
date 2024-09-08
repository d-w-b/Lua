local PlayerBackpackManager = {}
local PlayerDataManager = require(game:GetService("ServerScriptService").Modules.PlayerDataManager)

function PlayerBackpackManager.insert(
	player: Player,
	tool: Tool
)
	local playerData = PlayerDataManager.GetDataFromMemory(player)
	if not playerData  then
		playerData = PlayerDataManager.fetchData(player)
	end
	
	table.insert(playerData.backpack, tool.Name)
	PlayerDataManager.SetDataOnMemory(player, playerData)
end

function PlayerBackpackManager.remove(
	player: Player,
	tool : Tool
)
	local playerData = PlayerDataManager.GetDataFromMemory(player)
	if not playerData  then
		playerData = PlayerDataManager.fetchData(player)
	end
	
	table.remove(playerData.backpack, tool.Name)
	PlayerDataManager.SetDataOnMemory(player, playerData)
end

return PlayerBackpackManager
