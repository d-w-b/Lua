local DataStoreService = game:GetService("DataStoreService")
local DataStore = {}
DataStore.__index = DataStore

function DataStore.new(
	storeName : string
)
	local self = setmetatable({}, DataStore)
	self.dataStore = DataStoreService:GetDataStore(storeName)
	return self
end

function DataStore:SaveData(
	player : Player,
	data : any
)
	local success, err 
		= pcall(
			function()
				self.dataStore:SetAsync(player.UserId, data) 
			end
		)

	if success then
		print("Data has been saved!")
	else
		print("Data hasn't been saved!")
		warn(err)		
	end
end

function DataStore:GetData(player: Player)
	local response
	local success, data = pcall(
		function()
			response = self.dataStore:GetAsync( player.UserId )
		end
	)
	return response
end

function DataStore:RemoveData( player : Player )
	local response
	local success, data = pcall(
		function()
			response = self.dataStore:RemoveAsync(player.UserId)
		end
	)
	return response
end

return DataStore
