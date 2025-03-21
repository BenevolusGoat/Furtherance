local mod = Furtherance
local game = Game()

function mod:KarethQual(entity)
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local itemConfig = Isaac.GetItemConfig()
		if (player and player:HasCollectible(CollectibleType.COLLECTIBLE_KARETH)) and itemConfig:GetCollectible(entity.SubType).Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST then
			if itemConfig:GetCollectible(entity.SubType).Quality <= 1 then -- Quality 0 - 1
				local trinket = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(entity.Position, 0), Vector.Zero, player):ToPickup()
				trinket.Price = entity.Price
			elseif itemConfig:GetCollectible(entity.SubType).Quality == 2 or itemConfig:GetCollectible(entity.SubType).Quality == 3 then -- Quality 2 - 3
				local trinket = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(entity.Position, 0), Vector.Zero, player):ToPickup()
				local trinket2 = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(entity.Position, 0), Vector.Zero, player):ToPickup()
				trinket.Price = entity.Price
				trinket2.Price = entity.Price
			elseif itemConfig:GetCollectible(entity.SubType).Quality == 4 then -- Quality 4
				local trinket = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(entity.Position, 0), Vector.Zero, player):ToPickup()
				local trinket2 = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(entity.Position, 0), Vector.Zero, player):ToPickup()
				local trinket3 = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, Isaac.GetFreeNearPosition(entity.Position, 0), Vector.Zero, player):ToPickup()
				trinket.Price = entity.Price
				trinket2.Price = entity.Price
				trinket3.Price = entity.Price
			end
			entity:Remove()
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.KarethQual, PickupVariant.PICKUP_COLLECTIBLE)

function mod:Smelter(entity, collider)
	if collider:ToPlayer() then
		local player = collider:ToPlayer()
		local data = mod:GetData(player)
		local room = game:GetRoom()
		if (player and player:HasCollectible(CollectibleType.COLLECTIBLE_KARETH)) then
			data.KarethSmelt = true
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.Smelter, PickupVariant.PICKUP_TRINKET)

function mod:StupidAPIMoment(player)
	local data = mod:GetData(player)
	if data.KarethSmelt == true then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, true, false, -1)
		data.KarethSmelt = false
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.StupidAPIMoment)
