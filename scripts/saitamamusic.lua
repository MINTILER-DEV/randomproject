-- Death Counter and Serious Punch Music.
-- Someone make Table Flip and Omnidirectional Punch overwrite the music that's being played please :)

local contents

contents = game:HttpGet("https://mintiler-dev.github.io/death.mp3")
local deathcounter = writefile("deathcounter.mp3", contents)
print("Downloaded Death Counter Music")
contents = game:HttpGet("https://mintiler-dev.github.io/omni.mp3")
local omnidirectional = writefile("omnidirectional.mp3", contents)
print("Downloaded Omni Music")
contents = game:HttpGet("https://mintiler-dev.github.io/table.mp3")
local tableflip = writefile("tableflip.mp3", contents)
print("Downloaded Table Flip Music")
contents = game:HttpGet("https://mintiler-dev.github.io/serious.mp3")
local seriouspunch = writefile("seriouspunch.mp3", contents)
print("Downloaded Serious Punch Music")
 
deathcounter = getcustomasset("deathcounter.mp3")
omnidirectional = getcustomasset("omnidirectional.mp3")
tableflip = getcustomasset("tableflip.mp3")
seriouspunch = getcustomasset("seriouspunch.mp3")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

function setup(animID, music)
	local function playMusic()
		local humanoid = character:WaitForChild("Humanoid")

		-- Hook into AnimationPlayed event
		humanoid.AnimationPlayed:Connect(function(animationTrack)
			-- Check if the played animation has the old animation ID
			if animationTrack.Animation.AnimationId == "rbxassetid://" .. animID then
				local Sound = Instance.new("Sound")
				Sound.SoundId = music
				Sound.Volume = 3
				Sound.Parent = player
				Sound.PlayOnRemove = true
				Sound:Destroy()
			end
		end)
	end

	playMusic()

	player.CharacterAdded:Connect(function(newCharacter)
		character = newCharacter
		playMusic()
	end)
end

setup(12983333733, seriouspunch)
setup(11343318134, deathcounter)
