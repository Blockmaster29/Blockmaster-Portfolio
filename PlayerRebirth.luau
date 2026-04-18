local rebirthEvent = game.ReplicatedStorage.Remotes.RebirthEvent
local rebirthBase = game.ReplicatedStorage.Events.RebirthBase

rebirthEvent.OnServerEvent:Connect(function(player)
	if player.leaderstats.Cash.Value >= player.OtherValues.NextRebirth.Value then
		player.leaderstats.Cash.Value = 0
		player.leaderstats.Rebirths.Value += 1
		player.OtherValues.NextRebirth.Value = 100000  * math.pow(5, player.leaderstats.Rebirths.Value)
		player.Inventory:ClearAllChildren()
		player.OtherValues.VaultTimeLeft.Value = 1800
		rebirthBase:Fire(player)
		rebirthEvent:FireClient(player)
	end
end)
