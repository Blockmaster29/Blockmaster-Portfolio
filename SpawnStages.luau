local stages = game.ServerStorage.Stages:GetChildren()
local stageammount = #stages
local pause = false

function deleteStages()
	script.Parent.Stages:ClearAllChildren()
end

function generateStages()
	for i = 26, 526, 50 do
		local selectedStage = stages[math.random(1, stageammount)]
		local spawnedStage = selectedStage:Clone()
		spawnedStage.Parent = game.Workspace.Stages.Stages
		spawnedStage:PivotTo(CFrame.new(-44, i + 0.5, -140))
	end
end

generateStages()

while true do
	local minutes = script.Parent.Minutes
	local seconds = script.Parent.Seconds
	
	seconds.Value -= 1
	
	if seconds.Value < 0 then
		minutes.Value -= 1
		seconds.Value = 59
	end
	
	if minutes.Value < 0 then
		if pause == true then
			minutes.Value = 10
			seconds.Value = 0
			generateStages()
			pause = false
		else
			seconds.Value = 10
			minutes.Value = 0
			deleteStages()
			pause = true
		end
	end
	
	wait(1)
end
