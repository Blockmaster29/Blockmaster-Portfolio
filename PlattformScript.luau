local prompt = script.Parent.Platform.ProximityPrompt
local event = game.ReplicatedStorage.Remotes.OpenInventory
local rebirthBase = game.ReplicatedStorage.Events.RebirthBase
local playSoundEvent = game.ReplicatedStorage.Remotes.PlaySoundEvent
local marketplace = game:GetService("MarketplaceService")

local Moneypers = 0
local Money = script.Parent.SMoney
local MoneyT = script.Parent.Collector.CollectorGui.MoneyTextLabel
local debounce = false
local deleteBase = game.ReplicatedStorage.Events.DeleteBase
local brainrot = nil
local Owner = nil
local moneyg = 1
local vip = 1
local friendboost = 1

function formatNumber(value)
	if value < 1000 then
		return value..""
	elseif value < 1000000 then
		local v = value / 1000
		v = math.round(v * 100) / 100
		return v.."K"
	elseif value < 1000000000 then
		local v = value / 1000000
		v = math.round(v * 100) / 100
		return v.."M"
	elseif value < 1000000000000 then
		local v = value / 1000000000
		v = math.round(v * 100) / 100
		return v.."B"
	else
		local v = value / 1000000000000
		v = math.round(v * 100) / 100
		return v.."T"
	end
end

prompt.Triggered:Connect(function(player)
	if player.Name == script.Parent.Parent.Parent.Owner.Value then
		event:FireClient(player, script.Parent.Name, "Add")
	end
end)

script.Parent.Platform.Brainrot.ChildAdded:Connect(function(brainrott)
	wait(0.5)
	Moneypers = brainrott.Values.MoneyperSecond.Value
	brainrot = brainrott
end)

script.Parent.Platform.Brainrot.ChildRemoved:Connect(function()
	Moneypers = 0
	brainrot = nil
end)

script.Parent.Collector.Touched:Connect(function(hit)
	if hit.Parent.Name == script.Parent.Parent.Parent.Owner.Value then
		if debounce == false then
			debounce = true
			script.Parent.Collector.BrickColor = BrickColor.new("Bright red")
			game.Players:FindFirstChild(hit.Parent.Name).leaderstats.Cash.Value += Money.Value
			Money.Value = 0
			MoneyT.Text = "$"..Money.Value
			playSoundEvent:FireClient(game.Players:FindFirstChild(hit.Parent.Name), script.Parent.Collector.Sound)
			wait(1)
			debounce = false
			script.Parent.Collector.BrickColor = BrickColor.new("Lime green")
		end
	end
end)

deleteBase.Event:Connect(function(base)
	if base == script.Parent.Parent.Parent.Name then
		Moneypers = 0
		Money.Value = 0
		MoneyT.Text = "$"..Money.Value
		script.Parent.Platform.Brainrot:ClearAllChildren()
		script.Parent.Platform.ProximityPrompt.Enabled = true
	end
end)

rebirthBase.Event:Connect(function(player)
	if player.Name == script.Parent.Parent.Parent.Owner.Value then
		Moneypers = 0
		Money.Value = 0
		MoneyT.Text = "$"..Money.Value
		script.Parent.Platform.Brainrot:ClearAllChildren()
		script.Parent.Platform.ProximityPrompt.Enabled = true
	end
end)

script.Parent.Parent.Parent.Owner.Changed:Connect(function()
	if script.Parent.Parent.Parent.Owner.Value ~= "" then
		Owner = game.Players:FindFirstChild(script.Parent.Parent.Parent.Owner.Value)
		if marketplace:UserOwnsGamePassAsync(Owner.UserId, 1739052381) then
			moneyg = 2
		end
		
		if marketplace:UserOwnsGamePassAsync(Owner.UserId, 1736068113) then
			vip = 3
		end
		
		friendboost = Owner.OtherValues.Friendboost.Value
		
		Owner.OtherValues.Friendboost.Changed:Connect(function()
			friendboost = Owner.OtherValues.Friendboost.Value
		end)
	else
		Owner = nil
		moneyg = 1
		vip = 1
	end
end)

marketplace.PromptGamePassPurchaseFinished:Connect(function(player, id, purchased)
	if player.Name == script.Parent.Parent.Parent.Owner.Value then
		if purchased == true then
			if id == 1739052381 then
				moneyg = 2
			elseif id == 1736068113 then
				vip = 3
			end
		end
	end
end)

while task.wait(1) do
	local rebirthM = 1
	local player = game.Players:FindFirstChild(script.Parent.Parent.Parent.Owner.Value)
	if player ~= nil then
		rebirthM += player.leaderstats.Rebirths.Value / 2
	end
	
	Money.Value += Moneypers * rebirthM * moneyg * vip
	
	MoneyT.Text = "$"..formatNumber(Money.Value)
	
	if brainrot ~= nil then
		if Owner ~= nil then
			if brainrot.Values.XP.Value < brainrot.Values.MaxXP.Value then
				if brainrot.Values.XP.Value + Owner.Upgrades.XPUpgrade.UpgradeOutput.Value <= brainrot.Values.MaxXP.Value then
					brainrot.Values.XP.Value += Owner.Upgrades.XPUpgrade.UpgradeOutput.Value
				else
					brainrot.Values.XP.Value = brainrot.Values.MaxXP.Value
				end
			else 
				brainrot.Prompt.ProximityUpgrade.Enabled = true
				brainrot.Prompt.ProximityUpgrade.ActionText = "Upgrade ($"..formatNumber(brainrot.Values.nextUpgrade.Value)..")"
			end
		end
	end
end