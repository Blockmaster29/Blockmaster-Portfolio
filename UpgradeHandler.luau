local upgradeEvent = game.ReplicatedStorage.Remotes.UpgradeEvent
local PlayerDataService = require(script.Parent.PlayerData)
local upgradeTemplates = game.ReplicatedStorage.Upgrades
local playSoundEvent = game.ReplicatedStorage.Remotes.PlaySoundEvent

game.Players.PlayerAdded:Connect(function(player)
	local upgrades = Instance.new("Folder", player)
	upgrades.Name = "Upgrades"
	
	for _, upgrade in pairs(upgradeTemplates:GetChildren()) do
		local folder = Instance.new("Folder", upgrades)
		folder.Name = upgrade.Name
		
		local upgradeLevel = Instance.new("IntValue", folder)
		upgradeLevel.Name = "UpgradeLevel"
		
		local upgradePrice = Instance.new("NumberValue", folder)
		upgradePrice.Name = "UpgradePrice"
		
		local upgradeOutput = Instance.new("NumberValue", folder)
		upgradeOutput.Name = "UpgradeOutput"
	end
	
	wait(2.3)
	local data = PlayerDataService.GetData(player)
	for _, upgrade in pairs(upgrades:GetChildren()) do
		local upgradeTemplate = upgradeTemplates:FindFirstChild(upgrade.Name)
		upgrade.UpgradeLevel.Value = data[upgrade.Name]
		
		if upgradeTemplate.LorE.Value then
			upgrade.UpgradeOutput.Value = upgradeTemplate.StartingValue.Value * math.pow(upgradeTemplate.ValueIngrement.Value, upgrade.UpgradeLevel.Value)
		else
			upgrade.UpgradeOutput.Value = upgradeTemplate.StartingValue.Value + (upgradeTemplate.ValueIngrement.Value * upgrade.UpgradeLevel.Value)
		end
		
		if upgradeTemplate.LorEMoney.Value then
			upgrade.UpgradePrice.Value = upgradeTemplate.StartingMoney.Value * math.pow(upgradeTemplate.MoneyIngrement.Value, upgrade.UpgradeLevel.Value)
		else
			upgrade.UpgradePrice.Value = upgradeTemplate.StartingMoney.Value + (upgradeTemplate.MoneyIngrement.Value * upgrade.UpgradeLevel.Value)
		end
	end
	
	player.Character.Humanoid.MaxHealth = upgrades.MaxHealth.UpgradeOutput.Value
	player.Character.Humanoid.Health = upgrades.MaxHealth.UpgradeOutput.Value
	
	player.CharacterAdded:Connect(function(character)
		player.Character.Humanoid.MaxHealth = upgrades.MaxHealth.UpgradeOutput.Value
		player.Character.Humanoid.Health = upgrades.MaxHealth.UpgradeOutput.Value
	end)
end)

upgradeEvent.OnServerEvent:Connect(function(player, upgradeName)
	local upgrade = player.Upgrades[upgradeName]
	local upgradeTemplate = upgradeTemplates:FindFirstChild(upgrade.Name)
	local data = PlayerDataService.GetData(player)
	
	if player.leaderstats.Cash.Value >= upgrade.UpgradePrice.Value and (upgradeTemplate.MaxUpgrades.Value > upgrade.UpgradeLevel.Value or upgradeTemplate.MaxUpgrades.Value == -1) then
		upgrade.UpgradeLevel.Value += 1
		playSoundEvent:FireClient(player, game.SoundService.GUISoundeffects.Upgrade)
		player.leaderstats.Cash.Value -= upgrade.UpgradePrice.Value

		if upgradeTemplate.LorE.Value then
			upgrade.UpgradeOutput.Value = upgradeTemplate.StartingValue.Value * math.pow(upgradeTemplate.ValueIngrement.Value, upgrade.UpgradeLevel.Value)
		else
			upgrade.UpgradeOutput.Value = upgradeTemplate.StartingValue.Value + (upgradeTemplate.ValueIngrement.Value * upgrade.UpgradeLevel.Value)
		end

		if upgradeTemplate.LorEMoney.Value then
			upgrade.UpgradePrice.Value = upgradeTemplate.StartingMoney.Value * math.pow(upgradeTemplate.MoneyIngrement.Value, upgrade.UpgradeLevel.Value)
		else
			upgrade.UpgradePrice.Value = upgradeTemplate.StartingMoney.Value + (upgradeTemplate.MoneyIngrement.Value * upgrade.UpgradeLevel.Value)
		end
		
		data[upgrade.Name] = upgrade.UpgradeLevel.Value
		
		if upgradeName == "MaxHealth" then
			player.Character.Humanoid.MaxHealth = upgrade.UpgradeOutput.Value
			player.Character.Humanoid.Health += 10
		end
	end
end)
