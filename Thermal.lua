-- Gui to Lua
-- Version: 3.2

-- Instances:
local inst = game.CoreGui:FindFirstChild("MercThermal")
inst:Destroy()
	

local ScreenGui = Instance.new("ScreenGui")
local Vision = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextLabel_2 = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local Tint = Instance.new("ColorCorrectionEffect", game.Lighting)
local Thermal = false
local isFPS = false

local HeatTarget = game:GetService("Players")
local Client = HeatTarget.LocalPlayer 
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- retarded check if game is made by rolve
if game.PlaceId == 286090429 then
	isFPS = true
	print('v')
end

if game.PlaceId == 301549746 then
	isFPS = true
	print('v')
end


-- another check if game is first person only
local Character = Client.Character or Client.CharacterAdded:Wait() 
local Head = Character:WaitForChild("Head") 

local function OnRenderStepped()
	if (Head.CFrame.Position - Camera.CFrame.Position).Magnitude < 1 then
		print("fps detected")
		isFPS = true
	end
end


--Properties:
ScreenGui.Name = "MercThermal"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

TextLabel.Parent = ScreenGui
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderSizePixel = 3
TextLabel.Position = UDim2.new(0, 0, 0.902534127, 0)
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Font = Enum.Font.RobotoMono
TextLabel.Text = "Press \"T\" to activate thermal vision."
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 14.000
TextLabel.TextStrokeTransparency = 0.500
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom

TextLabel_2.Parent = ScreenGui
TextLabel_2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TextLabel_2.BackgroundTransparency = 0.200
TextLabel_2.Position = UDim2.new(0.860356152, 0, 0.0350877196, 0)
TextLabel_2.Size = UDim2.new(0, 133, 0, 23)
TextLabel_2.Font = Enum.Font.RobotoMono
TextLabel_2.Text = "SCAN TEAMMATES: ON"
TextLabel_2.TextColor3 = Color3.fromRGB(221, 221, 221)
TextLabel_2.TextSize = 14.000

UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = TextLabel_2

Vision.Name = "Vision"
Vision.Parent = ScreenGui
Vision.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Vision.BackgroundTransparency = 1.000
Vision.Size = UDim2.new(1, 0, 1, 0)

Tint.Name = "Merc"
Tint.Enabled = false
Tint.Brightness = 0.3
Tint.Contrast = 0.2
Tint.Saturation = -1
Tint.TintColor = Color3.fromRGB(74,74,74)

--[[
Tint.Name = "NVG"
Tint.Enabled = false
Tint.Brightness = 0.1
Tint.Contrast = 1
Tint.Saturation = -1
Tint.TintColor = Color3.fromRGB(18, 67, 41)

local settings_tbl = {
	ESP_Enabled = true,
	ESP_TeamCheck = false,
	Chams = true,
	Chams_Color = Color3.fromRGB(229, 156, 10),
	Chams_Transparency = 0,
	Chams_Glow_Color = Color3.fromRGB(255, 112, 16)
}

]]--

local settings_tbl = {
	ESP_Enabled = false,
	ESP_TeamCheck = false,
	Chams = false,
	Chams_Color = Color3.fromRGB(255,255,255),
	Chams_Transparency = 0,
	Glow_Transparency = 0.3,
	Chams_Glow_Color = Color3.fromRGB(255,255,255)
}

function destroy_chams(char)

	for k,v in next, char:GetChildren() do 

		if v:IsA("BasePart") and v.Transparency ~= 1 then

			if v:FindFirstChild("Glow") and 
				v:FindFirstChild("Chams") then

				v.Glow:Destroy()
				v.Chams:Destroy() 

			end 

		end 

	end 

end

RunService.Heartbeat:Connect(function()
	if settings_tbl.ESP_Enabled then
	 if isFPS == true then
		for k,v in pairs(HeatTarget:GetPlayers()) do 
				if v ~= Client then

					if v.Character and
						v.Character:FindFirstChild("HumanoidRootPart") and 
						v.Character:FindFirstChild("Humanoid") and 
						v.Character:FindFirstChild("Humanoid").Health ~= 0 then

						if settings_tbl.ESP_TeamCheck == false then

							local char = v.Character 

							for k,b in pairs(char:GetChildren()) do 

								if b:IsA("BasePart") and 
									b.Transparency ~= 1 then

									if settings_tbl.Chams then

										if not b:FindFirstChild("Glow") and
											not b:FindFirstChild("Chams") then

											local chams_box = Instance.new("BoxHandleAdornment", b)
											chams_box.Name = "Chams"
											chams_box.AlwaysOnTop = true 
											chams_box.ZIndex = 4 
											chams_box.Adornee = b 
											chams_box.Color3 = settings_tbl.Chams_Color
											chams_box.Transparency = settings_tbl.Chams_Transparency
											chams_box.Size = b.Size + Vector3.new(0.02, 0.02, 0.02)

											local glow_box = Instance.new("BoxHandleAdornment", b)
											glow_box.Name = "Glow"
											glow_box.AlwaysOnTop = false 
											glow_box.ZIndex = 3 
											glow_box.Adornee = b 
											glow_box.Color3 = settings_tbl.Chams_Glow_Color
											glow_box.Transparency = settings_tbl.Glow_Transparency
											glow_box.Size = chams_box.Size + Vector3.new(0.13, 0.13, 0.13)

										end

									else

										destroy_chams(char)

									end

								end

							end

						else

							if v.Team == Client.Team then
								destroy_chams(v.Character)
							end

						end

					else

						destroy_chams(v.Character)

					end

				end
		end
	else
			for k,v in pairs(HeatTarget:GetPlayers()) do 
				if v.Character and
					v.Character:FindFirstChild("HumanoidRootPart") and 
					v.Character:FindFirstChild("Humanoid") and 
					v.Character:FindFirstChild("Humanoid").Health ~= 0 then

					if settings_tbl.ESP_TeamCheck == false then

						local char = v.Character 

						for k,b in pairs(char:GetChildren()) do 

							if b:IsA("BasePart") and 
								b.Transparency ~= 1 then

								if settings_tbl.Chams then

									if not b:FindFirstChild("Glow") and
										not b:FindFirstChild("Chams") then

										local chams_box = Instance.new("BoxHandleAdornment", b)
										chams_box.Name = "Chams"
										chams_box.AlwaysOnTop = true 
										chams_box.ZIndex = 4 
										chams_box.Adornee = b 
										chams_box.Color3 = settings_tbl.Chams_Color
										chams_box.Transparency = settings_tbl.Chams_Transparency
										chams_box.Size = b.Size + Vector3.new(0.02, 0.02, 0.02)

										local glow_box = Instance.new("BoxHandleAdornment", b)
										glow_box.Name = "Glow"
										glow_box.AlwaysOnTop = false 
										glow_box.ZIndex = 3 
										glow_box.Adornee = b 
										glow_box.Color3 = settings_tbl.Chams_Glow_Color
										glow_box.Transparency = settings_tbl.Glow_Transparency
										glow_box.Size = chams_box.Size + Vector3.new(0.13, 0.13, 0.13)

									end

								else

									destroy_chams(char)

								end

							end

						end

					else

						if v.Team == Client.Team then
							destroy_chams(v.Character)
						end

					end

				else

					destroy_chams(v.Character)

				end
			end
	end
	else 

		for k,v in pairs(HeatTarget:GetPlayers()) do 

			if
				v.Character and 
					v.Character:FindFirstChild("HumanoidRootPart") and 
					v.Character:FindFirstChild("Humanoid") and 
					v.Character:FindFirstChild("Humanoid").Health ~= 0 then

				destroy_chams(v.Character)

			end

		end

	end

end)

-- Scripts:

local function BHHY_fake_script() -- TextButton.LocalScript 
	local script = Instance.new('LocalScript', TextLabel)
	game:GetService("UserInputService").InputBegan:connect(function(key)
		if key.KeyCode == Enum.KeyCode.T then
		if Thermal == false then
			Thermal = true
			settings_tbl.ESP_Enabled = Thermal
			settings_tbl.Chams = Thermal
			Tint.Enabled = true
			TextLabel.Text = "Press \"V\" to disable teammate scanning."
			local RunService = game:GetService("RunService")
			local Textures = {
				268592485,
				268592462,
				268592427,
				268590007,
			}
			local Frames = {}

			for i,v in pairs(Textures) do
				local ImageLabel = Instance.new("ImageLabel")
				ImageLabel.Image = "http://www.roblox.com/asset/?id="..v
				ImageLabel.BackgroundTransparency = 1
				ImageLabel.ImageTransparency = 0.58
				ImageLabel.Visible = true
				ImageLabel.Size = UDim2.new(1,0,1,0)
				ImageLabel.Parent = script.Parent.Parent.Vision
				Frames[#Frames+1] = ImageLabel
			end

			local FramesToWait = 3
			while Thermal == true do
				local Last = nil
				for i,v in pairs(Frames) do
					if Last ~= nil then
						Last.Visible = false
					end
					v.Visible = true
					Last = v
					for i = 1, FramesToWait do RunService.RenderStepped:wait() end
				end
				Last.Visible = false
			end					

		else if Thermal == true then
				Thermal = false
				settings_tbl.ESP_Enabled = Thermal
				settings_tbl.Chams = Thermal
					Tint.Enabled = false
					TextLabel.Text = "Press \"T\" to activate thermal vision."
			end
			end
			end
	end)
	game:GetService("UserInputService").InputBegan:connect(function(k)
		if k.KeyCode == Enum.KeyCode.V then
			if settings_tbl.ESP_TeamCheck == false then
				TextLabel_2.Text = "SCAN TEAMMATES: OFF"
				settings_tbl.ESP_TeamCheck = true
			else
				TextLabel_2.Text = "SCAN TEAMMATES: ON"
				settings_tbl.ESP_TeamCheck = false
			end
		end
	end)
end
coroutine.wrap(BHHY_fake_script)() 
