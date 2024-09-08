local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerDataManager = require( ServerScriptService.Module.PlayerDataManager )
local touchPadEvent = Remotes:WaitForChild("TouchPad")
local LoadEvent = Remotes:WaitForChild("Load")


touchPadEvent.OnServerEvent:Connect(
	function(player: Player, ...: any) 
		local args = {...}
		local objectId = args[1]
		
		local playerData = PlayerDataManager.GetPlayerData(player)
		playerData.visited[objectId] = true
		PlayerDataManager.SetDataOnMemory(player, playerData)
	end
)

local function onServerInvoke (player: Player , ...: any)
	return PlayerDataManager.GetPlayerData(player)
end

LoadEvent.OnServerInvoke = onServerInvoke