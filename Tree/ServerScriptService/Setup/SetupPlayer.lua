local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Objects = ReplicatedStorage:WaitForChild("Objects")

local Queue = require ( game:GetService("ReplicatedStorage").Script.Queue ) 
local PlayerDataManager = require( game:GetService("ServerScriptService").Module.PlayerDataManager )

Players.PlayerAdded:Connect(
	function(player: Player) 
		PlayerDataManager.resetData(player)
		local initEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Init")
		local playerData = PlayerDataManager.fetchData(player)
		
		initEvent:FireClient(player, playerData)
	end
)
