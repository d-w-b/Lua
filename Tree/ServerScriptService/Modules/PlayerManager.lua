local PlayerManager = {}
PlayerManager.players = {}
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(
	function(player: Player) 
		table.insert(PlayerManager.players, player)
	end
)

return PlayerManager
