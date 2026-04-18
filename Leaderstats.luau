local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local marketplace = game:GetService("MarketplaceService")
local vaultgpbought = game.ReplicatedStorage.Gamepass.Vaultgpbought
local PlayerDataService = require(script.Parent.PlayerData)
local closeBase = game.ReplicatedStorage.Events.CloseBase
local deleteBase = game.ReplicatedStorage.Events.DeleteBase
local upgradeVaultEvent = game.ReplicatedStorage.Remotes.UpgradeVaultEvent
local playSoundEvent = game.ReplicatedStorage.Remotes.PlaySoundEvent

game.Players.PlayerAdded:Connect(function(player)
	local inventory = Instance.new("Folder", player)
	inventory.Name = "Inventory"
	
	local vault = Instance.new("Folder", player)
	vault.Name = "Vault"
	
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	local cash = Instance.new("NumberValue", leaderstats)
	cash.Name = "Cash"
	cash.Value = 0
	
	local rebirths = Instance.new("IntValue", leaderstats)
	rebirths.Name = "Rebirths"
	rebirths.Value = 0
	
	local otherValues = Instance.new("Folder", player)
	otherValues.Name = "OtherValues"
	
	local nextRebirth = Instance.new("NumberValue", otherValues)
	nextRebirth.Name = "NextRebirth"
	nextRebirth.Value = 100000
	
	local boughtVaultUpgrades = Instance.new("NumberValue", otherValues)
	boughtVaultUpgrades.Name = "BoughtVaultUpgrades"
	boughtVaultUpgrades.Value = 0
	
	local totalVaultUpgrades = Instance.new("NumberValue", otherValues)
	totalVaultUpgrades.Name = "TotalVaultUpgrades"
	totalVaultUpgrades.Value = 0
	
	local nextVaultUpgrade = Instance.new("NumberValue", otherValues)
	nextVaultUpgrade.Name = "NextVaultUpgrade"
	nextVaultUpgrade.Value = 1000000
	
	local hasvaultgp = Instance.new("BoolValue", otherValues)
	hasvaultgp.Name = "HasVaultGP"
	hasvaultgp.Value = false
	
	local timeOffline = Instance.new("NumberValue", otherValues)
	timeOffline.Name = "TimeOffline"
	timeOffline.Value = 0
	
	local vaultTimeLeft = Instance.new("NumberValue", otherValues)
	vaultTimeLeft.Name = "VaultTimeLeft"
	vaultTimeLeft.Value = 0
	
	local offlineClaimed = Instance.new("BoolValue", otherValues)
	offlineClaimed.Name = "OfflineClaimed"
	offlineClaimed.Value = false
	
	local offlineEarned = Instance.new("NumberValue", otherValues)
	offlineEarned.Name = "OfflineEarned"
	offlineEarned.Value = 0
	
	wait(2.3)
	local data = PlayerDataService.GetData(player)
	cash.Value = data.cash
	rebirths.Value = data.rebirths
	boughtVaultUpgrades.Value = data.vaultUpgrades
	if data.loggedofat ~= -1 then
		timeOffline.Value = os.time() - data.loggedofat
	end
	
	vaultTimeLeft.Value = data.vaultTimeLeft
	
	if timeOffline.Value > 0 then
		vaultTimeLeft.Value -= timeOffline.Value
		if vaultTimeLeft.Value < 0 then
			vaultTimeLeft.Value = 0
		end
	end
	
	for _, meme in pairs(data.invMemes) do
		local newMeme = game.ServerStorage.Brainrots:FindFirstChild(meme.name):Clone()
		newMeme.Parent = inventory
		newMeme.Values.Mutation.Value = meme.mutation
		newMeme.Values.Level.Value = meme.level
		newMeme.Values.XP.Value = meme.xp
		newMeme.Values.ID.Value = meme.id
		local MutationMulti = 1

		if newMeme.Values.Mutation.Value ~= "" then
			MutationMulti = game.ServerStorage.MutationX:FindFirstChild(newMeme.Values.Mutation.Value).Value
		end

		local LevelMulti = 1

		LevelMulti += newMeme.Values.Level.Value * 0.10

		if newMeme.Values.Level.Value == 0 then
			newMeme.Values.MaxXP.Value = 100
		else
			newMeme.Values.MaxXP.Value = 100 * math.pow(1.5, newMeme.Values.Level.Value)
			newMeme.Values.MaxXP.Value = math.floor(newMeme.Values.MaxXP.Value)
		end

		newMeme.Values.MoneyperSecond.Value = newMeme.Values.DefaultMoneyperSecond.Value * MutationMulti * LevelMulti
		newMeme.Values.MoneyperSecond.Value = math.floor(newMeme.Values.MoneyperSecond.Value)
		newMeme.Values.nextUpgrade.Value = newMeme.Values.MoneyperSecond.Value * 500

		newMeme.Values.Worth.Value = newMeme.Values.MoneyperSecond.Value * 1000
		newMeme.Name = newMeme.Values.NameofB.Value.."-"..newMeme.Values.Mutation.Value.."-"..newMeme.Values.Level.Value.."-"..newMeme.Values.XP.Value
	end
	
	for _, meme in pairs(data.vaultMemes) do
		local newMeme = game.ServerStorage.Brainrots:FindFirstChild(meme.name):Clone()
		newMeme.Parent = vault
		newMeme.Values.Mutation.Value = meme.mutation
		newMeme.Values.Level.Value = meme.level
		newMeme.Values.XP.Value = meme.xp
		newMeme.Values.ID.Value = meme.id
		local MutationMulti = 1

		if newMeme.Values.Mutation.Value ~= "" then
			MutationMulti = game.ServerStorage.MutationX:FindFirstChild(newMeme.Values.Mutation.Value).Value
		end

		local LevelMulti = 1

		LevelMulti += newMeme.Values.Level.Value * 0.10

		if newMeme.Values.Level.Value == 0 then
			newMeme.Values.MaxXP.Value = 100
		else
			newMeme.Values.MaxXP.Value = 100 * math.pow(1.5, newMeme.Values.Level.Value)
			newMeme.Values.MaxXP.Value = math.floor(newMeme.Values.MaxXP.Value)
		end

		newMeme.Values.MoneyperSecond.Value = newMeme.Values.DefaultMoneyperSecond.Value * MutationMulti * LevelMulti
		newMeme.Values.MoneyperSecond.Value = math.floor(newMeme.Values.MoneyperSecond.Value)
		newMeme.Values.nextUpgrade.Value = newMeme.Values.MoneyperSecond.Value * 500

		newMeme.Values.Worth.Value = newMeme.Values.MoneyperSecond.Value * 1000
		newMeme.Name = newMeme.Values.NameofB.Value.."-"..newMeme.Values.Mutation.Value.."-"..newMeme.Values.Level.Value.."-"..newMeme.Values.XP.Value
	end
	
	nextRebirth.Value = 100000 * math.pow(5, rebirths.Value)
	nextVaultUpgrade.Value = 1000000 * math.pow(5, boughtVaultUpgrades.Value)
	totalVaultUpgrades.Value = boughtVaultUpgrades.Value
	
	cash.Changed:Connect(function()
		data.cash = cash.Value
	end)
	
	rebirths.Changed:Connect(function()
		data.rebirths = rebirths.Value
	end)
	
	boughtVaultUpgrades.Changed:Connect(function()
		data.vaultUpgrades = boughtVaultUpgrades.Value
	end)
	
	local memeid = 0
	
	for _, meme in pairs(data.invMemes) do
		memeid = meme.id
	end

	inventory.ChildAdded:Connect(function(meme)
		memeid += 1
		meme.Values.ID.Value = memeid
		data.invMemes[tostring(memeid)] = {
			name = meme.Values.NameofB.Value,
			mutation = meme.Values.Mutation.Value,
			level = meme.Values.Level.Value,
			xp = meme.Values.XP.Value,
			id = memeid,
			realname = meme.name
		}
	end)
	
	inventory.ChildRemoved:Connect(function(meme)
		for _, memed in pairs(data.invMemes) do
			if memed.realname == meme.Name then
				data.invMemes[tostring(memed.id)] = nil
				break
			end
		end
	end)
	
	vault.ChildAdded:Connect(function(meme)
		memeid += 1
		meme.Values.ID.Value = memeid
		data.vaultMemes[tostring(memeid)] = {
			name = meme.Values.NameofB.Value,
			mutation = meme.Values.Mutation.Value,
			level = meme.Values.Level.Value,
			xp = meme.Values.XP.Value,
			id = memeid,
			realname = meme.name
		}
	end)

	vault.ChildRemoved:Connect(function(meme)
		for _, memed in pairs(data.vaultMemes) do
			if memed.realname == meme.Name then
				data.vaultMemes[tostring(memed.id)] = nil
				break
			end
		end
	end)
	
	if marketplace:UserOwnsGamePassAsync(player.UserId, 1730034346) then
		totalVaultUpgrades.Value += 5
		hasvaultgp.Value = true
	end
	
	while task.wait(1) do
		if vaultTimeLeft.Value > 0 then
			vaultTimeLeft.Value -= 1
		end
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	local data = PlayerDataService.GetData(player)
	if data ~= nil then
		data.loggedofat = os.time()
		data.vaultTimeLeft = player.OtherValues.VaultTimeLeft.Value
	end
	wait(3)
	local base = nil
	for _, v in pairs(game.Workspace.Bases:GetChildren()) do
		if v.Owner.Value == player.Name then
			base = v
		end
	end
	if base ~= nil then
		deleteBase:Fire(base.Name)
	end
end)

upgradeVaultEvent.OnServerEvent:Connect(function(player)
	if player.leaderstats.Cash.Value >= player.OtherValues.NextVaultUpgrade.Value and player.OtherValues.BoughtVaultUpgrades.Value < 5 then
		player.leaderstats.Cash.Value -= player.OtherValues.NextVaultUpgrade.Value
		player.OtherValues.BoughtVaultUpgrades.Value += 1
		player.OtherValues.TotalVaultUpgrades.Value += 1
		player.OtherValues.NextVaultUpgrade.Value = 1000000 * math.pow(5, player.OtherValues.BoughtVaultUpgrades.Value)
		playSoundEvent:FireClient(player, game.SoundService.GUISoundeffects.Upgrade)
		upgradeVaultEvent:FireClient(player)
	end
end)

marketplace.PromptGamePassPurchaseFinished:Connect(function(player, id, purchased)
	if player == game.Players.LocalPlayer and id == 1730034346 and purchased then
		vaultgpbought:FireClient(player)
		player.OtherValues.TotalVaultUpgrades.Value += 5
		player.OtherValues.HasVaultGP.Value = true
	end
end)

marketplace.PromptProductPurchaseFinished:Connect(function(userId, productId, isPurchased)
	local player = game.Players:GetPlayerByUserId(userId)
	if isPurchased and player and productId == 3545650147 then
		player.OtherValues.VaultTimeLeft.Value = 0
	end
end)