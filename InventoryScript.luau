local inventoryEvent = game.ReplicatedStorage.Remotes.InventoryEvent
local removeEvent = game.ReplicatedStorage.Remotes.RemoveItem
local openInventory = game.ReplicatedStorage.Remotes.OpenInventory
local sellEvent = game.ReplicatedStorage.Remotes.SellEvent
local vaultEvent = game.ReplicatedStorage.Remotes.MovetoVaultEvent
local closeEquipFrame = game.ReplicatedStorage.Remotes.CloseEquipEvent

game.Players.PlayerAdded:Connect(function(player)
	local inventory = player:WaitForChild("Inventory")
	
	local inventoryFrame = player.PlayerGui:WaitForChild("InventoryGUI").InventoryFrame.ItemsFrame:GetChildren()
	
	inventory.ChildAdded:Connect(function(Item)
		wait(1)
		inventoryEvent:FireClient(player, Item, true)
	end)
	
	player.CharacterAdded:Connect(function(character)
		wait(0.5)
		for i, v in pairs(player.Inventory:GetChildren()) do
			inventoryEvent:FireClient(player, v, true)
		end
	end)
end)

inventoryEvent.OnServerEvent:Connect(function(player, ItemName, Value, button, selectedPlatform, mode)
	
	if Value == false then
		local SelectedItem = player.Inventory:FindFirstChild(ItemName)
		local stuff = player.Character:GetChildren()
		local playerbase = nil
		
		for i, v in pairs(game.Workspace.Bases:GetChildren()) do
			if v.Owner.Value == player.Name then
				playerbase = v
			end
		end
		
		if mode == "Add" then
			local platform = playerbase.Platforms:FindFirstChild(selectedPlatform).Platform
			SelectedItem.Parent = platform.Brainrot
			local positon = platform.Position
			if platform.Parent.Rotated.Value == true then
				SelectedItem:PivotTo(CFrame.new(positon.x, positon.y + SelectedItem.Values.moveHeight.Value, positon.z) * CFrame.Angles(0, math.rad(180), 0))
			else
				SelectedItem:PivotTo(CFrame.new(positon.x, positon.y + SelectedItem.Values.moveHeight.Value, positon.z))
			end
			SelectedItem.Prompt.ProximityPrompt.ActionText = "Inspect"
			SelectedItem.Prompt.ProximityPrompt.HoldDuration = 0
			platform.ProximityPrompt.Enabled = false
			
			removeEvent:FireClient(player, ItemName)
			openInventory:FireClient(player, selectedPlatform, "Close")
		elseif mode == "Inspect" then
			local platform = playerbase.Platforms:FindFirstChild(selectedPlatform).Platform
			platform.Brainrot:GetChildren()[1].Name = platform.Brainrot:GetChildren()[1].Values.NameofB.Value.."-"..platform.Brainrot:GetChildren()[1].Values.Mutation.Value.."-"..platform.Brainrot:GetChildren()[1].Values.Level.Value.."-"..platform.Brainrot:GetChildren()[1].Values.XP.Value
			platform.Brainrot:GetChildren()[1].Parent = player.Inventory
			platform.ProximityPrompt.Enabled = true
			
			openInventory:FireClient(player, selectedPlatform, "Close")
		end
	end
end)

sellEvent.OnServerEvent:Connect(function(player, ItemName)
	local SelectedItem = player.Inventory:FindFirstChild(ItemName)
	player.leaderstats.Cash.Value += SelectedItem.Values.Worth.Value
	SelectedItem:Destroy()
	removeEvent:FireClient(player, ItemName)
	closeEquipFrame:FireClient(player)
end)

vaultEvent.OnServerEvent:Connect(function(player, ItemName)
	if player.OtherValues.TotalVaultUpgrades.Value > #player.Vault:GetChildren() then
		if player.OtherValues.VaultTimeLeft.Value == 0 then
			local SelectedItem = player.Inventory:FindFirstChild(ItemName)
			SelectedItem.Parent = player.Vault
			removeEvent:FireClient(player, ItemName)
			closeEquipFrame:FireClient(player)
		end
	end
end)