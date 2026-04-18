local InventoryEvent = game.ReplicatedStorage.Remotes.VaultEvent
local RemoveEvent = game.ReplicatedStorage.Remotes.RemoveVaultItem
local OpenInventory = game.ReplicatedStorage.Remotes.OpenInventory
local itemFrame = script.Parent:FindFirstChild("ItemsFrame")
local player = game.Players.LocalPlayer
local addedButtons = 0
local lastItemButton = 0
local equipFrame = script.Parent.EquipFrame
local targetsize = nil
local barsmooth = 10

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

InventoryEvent.OnClientEvent:Connect(function(ItemName, Value, button, selectedPlatform, mode)
	if Value == true then
		addedButtons += 1
		local ItemButton = script.Parent.ItemsFrame.Frame.ItemsButton:Clone()
		ItemButton.Visible = true
		ItemButton.Name = ItemName.Name
		ItemButton.ID.Value = addedButtons
		ItemButton.ImageLabel.ImageLabel.Image = ItemName.Values.Image.Value
		ItemButton.ImageLabel.TextLabel.Text = ItemName.Values.NameofB.Value
		local rarityG = player.PlayerGui.InventoryGUI.RarityG:FindFirstChild(ItemName.Values.Rarity.Value):Clone()
		rarityG.Parent = ItemButton.ImageLabel.TextLabel
		if ItemName.Values.Mutation.Value == "" then
			ItemButton.ImageLabel.Mutation.Visible = false
		else
			ItemButton.ImageLabel.Mutation.Visible = true
			ItemButton.ImageLabel.Mutation.ImageColor3 = player.PlayerGui.InventoryGUI.Mutations:FindFirstChild(ItemName.Values.Mutation.Value).Value
		end
		ItemButton.ImageLabel.Level.Text = ItemName.Values.Level.Value
		ItemButton.Parent = itemFrame.Frame
		
		local equipButton = equipFrame.EquipButton
		
		ItemButton.MouseButton1Click:Connect(function()
			if equipFrame.Visible == false or lastItemButton ~= ItemButton.ID.Value then
				lastItemButton = ItemButton.ID.Value
				if equipFrame.TopFrane.ImageLabel.ScrollingFrame.Rarity.TextLabel:FindFirstChildWhichIsA("UIGradient") ~= nil then
					equipFrame.TopFrane.ImageLabel.ScrollingFrame.Rarity.TextLabel:FindFirstChildWhichIsA("UIGradient"):Destroy()
				end
				if equipFrame.TopFrane.ImageLabel.ScrollingFrame.Mutation.TextLabel:FindFirstChildWhichIsA("UIGradient") ~= nil then
					equipFrame.TopFrane.ImageLabel.ScrollingFrame.Mutation.TextLabel:FindFirstChildWhichIsA("UIGradient"):Destroy()
				end
				equipFrame.TopFrane.ImageLabel.Title.Text = ItemName.Values.NameofB.Value
				equipFrame.NameofB.Value = ItemName.Name
				equipFrame.TopFrane.ImageLabel.MemeImage.Studs.Meme.Image = ItemName.Values.Image.Value
				equipFrame.TopFrane.ImageLabel.ScrollingFrame.Level.TextLabel.Text = ItemName.Values.Level.Value
				equipFrame.TopFrane.ImageLabel.ScrollingFrame.XP.BarBG.Studs.TextLabel.Text = ItemName.Values.XP.Value.."/"..ItemName.Values.MaxXP.Value
				targetsize = UDim2.new(ItemName.Values.XP.Value / ItemName.Values.MaxXP.Value, 0, 0, 26)
				equipFrame.TopFrane.ImageLabel.ScrollingFrame.Worth.TextLabel.Text = "$"..formatNumber(ItemName.Values.Worth.Value)
				equipFrame.TopFrane.ImageLabel.ScrollingFrame.Rarity.TextLabel.Text = ItemName.Values.Rarity.Value
				local rarityG2 = player.PlayerGui.InventoryGUI.RarityG:FindFirstChild(ItemName.Values.Rarity.Value):Clone()
				rarityG2.Parent = equipFrame.TopFrane.ImageLabel.ScrollingFrame.Rarity.TextLabel
				equipFrame.TopFrane.ImageLabel.ScrollingFrame.MoneyperSecond.TextLabel.Text = "$"..formatNumber(ItemName.Values.MoneyperSecond.Value).."/s"
				if ItemName.Values.Mutation.Value == "" then
					equipFrame.TopFrane.ImageLabel.ScrollingFrame.Mutation.TextLabel.Text = "None"
					local mutationG = player.PlayerGui.InventoryGUI.MutationsG:FindFirstChild("None"):Clone()
					mutationG.Parent = equipFrame.TopFrane.ImageLabel.ScrollingFrame.Mutation.TextLabel
				else
					equipFrame.TopFrane.ImageLabel.ScrollingFrame.Mutation.TextLabel.Text = ItemName.Values.Mutation.Value
					local mutationG = player.PlayerGui.InventoryGUI.MutationsG:FindFirstChild(ItemName.Values.Mutation.Value):Clone()
					mutationG.Parent = equipFrame.TopFrane.ImageLabel.ScrollingFrame.Mutation.TextLabel
				end
				equipFrame.Visible = true
				if script.Parent.Parent.Mode.Value ~= "View" then
					equipButton.Visible = true
					equipFrame.TopFrane.ImageLabel.TextLabel.Visible = true
				end
			else
				equipFrame.Visible = false
				equipButton.Visible = false
				equipFrame.TopFrane.ImageLabel.ScrollingFrame.Rarity.TextLabel:FindFirstChildWhichIsA("UIGradient"):Destroy()
				equipFrame.TopFrane.ImageLabel.TextLabel.Visible = false
			end
		end)
	end
end)

RemoveEvent.OnClientEvent:Connect(function(ItemName)
	local ItemButton = script.Parent.ItemsFrame.Frame:FindFirstChild(ItemName)
	ItemButton:Destroy()
end)

while true do
	local bt = time()
	task.wait()
	local dt = time() - bt
	if targetsize ~= nil then
		equipFrame.TopFrane.ImageLabel.ScrollingFrame.XP.BarBG.Barfill.Size = equipFrame.TopFrane.ImageLabel.ScrollingFrame.XP.BarBG.Barfill.Size:Lerp(targetsize, barsmooth * dt)
	end
end