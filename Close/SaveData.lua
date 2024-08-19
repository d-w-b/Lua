local Players = game:GetService("Players")
local ServerScriptService= game:GetService("ServerScriptService")
local PlayerDataManager = require(ServerScriptService.Modules.PlayerDataManager )
local PlayerManager = require( ServerScriptService.Modules.PlayerManager )

game:BindToClose(
	function()
		print("close")
		for i, player in ipairs(PlayerManager.players) do
			--TODO 
			coroutine.wrap(PlayerDataManager.SetDataToDataStore)(player, PlayerDataManager.GetDataFromMemory(player))
		end
	end
)
