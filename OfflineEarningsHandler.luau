local players = game:GetService("Players")
local offlineClaimEvent = game.ReplicatedStorage.Remotes.OfflineClaimEvent
local marketplace = game:GetService("MarketplaceService")

players.PlayerAdded:Connect(function(player)
	wait(3.5)
	local playerTimeOffline = player.OtherValues.TimeOffline.Value
	local earnedMoney = 0
	
	if playerTimeOffline >= player.Upgrades.OfflineHours.UpgradeOutput.Value * 3600 then
		playerTimeOffline = player.Upgrades.OfflineHours.UpgradeOutput.Value * 3600
	end
	
	local bases = workspace.Bases:GetChildren()
	local base = nil
	
	for _, b in pairs(bases) do
		if b.Owner.Value == player.Name then
			base = b
			break
		end
	end
	
	if base ~= nil then
		for _, platform in pairs(base.Platforms:GetChildren()) do
			local meme = platform.Platform.Brainrot:GetChildren()[1]
			if meme ~= nil then
				earnedMoney += math.floor(meme.Values.MoneyperSecond.Value * playerTimeOffline * (player.Upgrades.OfflineReturn.UpgradeOutput.Value * 0.01))
			end
		end
	end
	
	if earnedMoney > 0 then
		player.OtherValues.OfflineEarned.Value = earnedMoney
		offlineClaimEvent:FireClient(player, earnedMoney, "Prompt")
	end
end)

offlineClaimEvent.OnServerEvent:Connect(function(player)
	if player.OtherValues.OfflineClaimed.Value == false then
		player.leaderstats.Cash.Value += player.OtherValues.OfflineEarned.Value
		player.OtherValues.OfflineEarned.Value = 0
		player.OtherValues.OfflineClaimed.Value = true
	end
end)

marketplace.PromptProductPurchaseFinished:Connect(function(userId, productId, isPurchased)
	if isPurchased == true and productId == 3550883756 then
		local player = players:GetPlayerByUserId(userId)
		if player ~= nil then
			player.leaderstats.Cash.Value += player.OtherValues.OfflineEarned.Value * 2
			player.OtherValues.OfflineEarned.Value = 0
			player.OtherValues.OfflineClaimed.Value = true
			offlineClaimEvent:FireClient(player, 0, "Close")
		end
	end
end)