local prompt = script.Parent.Prompt.ProximityPrompt
local upgradeprompt = script.Parent.Prompt.ProximityUpgrade
local brainrot = script.Parent
local openInventory = game.ReplicatedStorage.Remotes.OpenInventory
local nextUpgrade = script.Parent.Values.nextUpgrade
local playSoundEvent = game.ReplicatedStorage.Remotes.PlaySoundEvent

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

local rarityG = game.ServerStorage.RarityG:FindFirstChild(brainrot.Values.Rarity.Value):Clone()
rarityG.Parent = brainrot.Part.BillboardGui.Rarity
prompt.ObjectText = brainrot.Values.NameofB.Value
upgradeprompt.ObjectText = brainrot.Values.NameofB.Value

if brainrot.Values.Mutation.Value == "" then
	brainrot.Part.BillboardGui.NameLabel.Text = brainrot.Values.NameofB.Value
	local mutationG = game.ServerStorage.MutationsG:FindFirstChild("None"):Clone()
	mutationG.Parent = brainrot.Part.BillboardGui.NameLabel
else
	brainrot.Part.BillboardGui.NameLabel.Text = brainrot.Values.NameofB.Value.." ("..brainrot.Values.Mutation.Value..")"
	local mutationG = game.ServerStorage.MutationsG:FindFirstChild(brainrot.Values.Mutation.Value):Clone()
	mutationG.Parent = brainrot.Part.BillboardGui.NameLabel
	for _, v in pairs(brainrot.Change:GetDescendants()) do
		if v:IsA("Part") then
			v.BrickColor = game.ServerStorage.Mutations:FindFirstChild(brainrot.Values.Mutation.Value).Value
		end
	end
end

if brainrot.Values.Mutation.Value == "" then
	local allvfx = script.Parent.VFX:FindFirstChild("Normal")
	if allvfx ~= nil then
		for _, vfx in pairs(allvfx:GetChildren()) do
			vfx.Enabled = true
		end
	end
else
	local allvfx = script.Parent.VFX:FindFirstChild(brainrot.Values.Mutation.Value)
	if allvfx ~= nil then
		for _, vfx in pairs(allvfx:GetChildren()) do
			vfx.Enabled = true
		end
	else
		local allvfx2 = script.Parent.VFX:FindFirstChild("Normal")
		if allvfx2 ~= nil then
			for _, vfx2 in pairs(allvfx2:GetChildren()) do
				vfx2.Enabled = true
			end
		end
	end
end

local MutationMulti = 1

if brainrot.Values.Mutation.Value ~= "" then
	MutationMulti = game.ServerStorage.MutationX:FindFirstChild(brainrot.Values.Mutation.Value).Value
end

local LevelMulti = 1

LevelMulti += brainrot.Values.Level.Value * 0.10

if brainrot.Values.Level.Value == 0 then
	brainrot.Values.MaxXP.Value = 100
else
	brainrot.Values.MaxXP.Value = 100 * math.pow(1.5, brainrot.Values.Level.Value)
	brainrot.Values.MaxXP.Value = math.floor(brainrot.Values.MaxXP.Value)
end

brainrot.Values.MoneyperSecond.Value = brainrot.Values.DefaultMoneyperSecond.Value * MutationMulti * LevelMulti
brainrot.Values.MoneyperSecond.Value = math.floor(brainrot.Values.MoneyperSecond.Value)
nextUpgrade.Value = brainrot.Values.MoneyperSecond.Value * 500

brainrot.Part.BillboardGui.MoneyperSecond.Text = "$"..formatNumber(brainrot.Values.MoneyperSecond.Value).."/s"

brainrot.Values.Worth.Value = brainrot.Values.MoneyperSecond.Value * 1000

brainrot.Name = brainrot.Values.NameofB.Value.."-"..brainrot.Values.Mutation.Value.."-"..brainrot.Values.Level.Value.."-"..brainrot.Values.XP.Value

prompt.Triggered:Connect(function(player)
	if prompt.ActionText == "Claim" then
		brainrot.Parent = player.Inventory
		playSoundEvent:FireClient(player, script.Parent.Values.Sound)
	elseif prompt.ActionText == "Inspect" then
		openInventory:FireClient(player, brainrot.Parent.Parent.Parent.Name, "Inspect")
		brainrot.Name = brainrot.Values.NameofB.Value.."-"..brainrot.Values.Mutation.Value.."-"..brainrot.Values.Level.Value.."-"..brainrot.Values.XP.Value
	end
end)

upgradeprompt.Triggered:Connect(function(player)
	if player.leaderstats.Cash.Value >= nextUpgrade.Value then
		playSoundEvent:FireClient(player, game.SoundService.GUISoundeffects.Upgrade)
		player.leaderstats.Cash.Value -= nextUpgrade.Value
		brainrot.Values.XP.Value = 0
		brainrot.Values.Level.Value += 1
		brainrot.Prompt.ProximityUpgrade.Enabled = false
		local MutationMulti = 1

		if brainrot.Values.Mutation.Value ~= "" then
			MutationMulti = game.ServerStorage.MutationX:FindFirstChild(brainrot.Values.Mutation.Value).Value
		end

		local LevelMulti = 1

		LevelMulti += brainrot.Values.Level.Value * 0.10

		if brainrot.Values.Level.Value == 0 then
			brainrot.Values.MaxXP.Value = 100
		else
			brainrot.Values.MaxXP.Value = 100 * math.pow(1.5, brainrot.Values.Level.Value)
			brainrot.Values.MaxXP.Value = math.floor(brainrot.Values.MaxXP.Value)
		end

		brainrot.Values.MoneyperSecond.Value = brainrot.Values.DefaultMoneyperSecond.Value * MutationMulti * LevelMulti
		brainrot.Values.MoneyperSecond.Value = math.floor(brainrot.Values.MoneyperSecond.Value)
		nextUpgrade.Value = brainrot.Values.MoneyperSecond.Value * 500

		brainrot.Part.BillboardGui.MoneyperSecond.Text = "$"..formatNumber(brainrot.Values.MoneyperSecond.Value).."/s"
		
		brainrot.Values.Worth.Value = brainrot.Values.MoneyperSecond.Value * 1000

		brainrot.Name = brainrot.Values.NameofB.Value.."-"..brainrot.Values.Mutation.Value.."-"..brainrot.Values.Level.Value.."-"..brainrot.Values.XP.Value
	end
end)