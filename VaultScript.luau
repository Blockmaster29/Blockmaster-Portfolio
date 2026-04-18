local inventoryEvent = game.ReplicatedStorage.Remotes.VaultEvent
local removeEvent = game.ReplicatedStorage.Remotes.RemoveVaultItem
local openInventory = game.ReplicatedStorage.Remotes.CloseVault

game.Players.PlayerAdded:Connect(function(player)
	local inventory = player:WaitForChild("Vault")
	
	local inventoryFrame = player.PlayerGui:WaitForChild("InventoryGUI").VaultFrame.ItemsFrame:GetChildren()
	
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

inventoryEvent.OnServerEvent:Connect(function(player, ItemName, Value, button)
	if Value == false then
		if player.OtherValues.VaultTimeLeft.Value == 0 then
			local SelectedItem = player.Vault:FindFirstChild(ItemName)
			SelectedItem.Parent = player.Inventory
			removeEvent:FireClient(player, ItemName)
			openInventory:FireClient(player)
		end
	end
end)