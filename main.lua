-- 🚀 FLY + NOCLIP | PC & MOBILE | GitHub Ready

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false
local noclip = false
local speed = 60

-- ================= GUI =================
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "FlyNoclipGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,150)
frame.Position = UDim2.new(0.02,0,0.6,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "FLY + NOCLIP"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0.85,0,0,40)
flyBtn.Position = UDim2.new(0.075,0,0.3,0)
flyBtn.Text = "FLY: OFF"
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 14
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
Instance.new("UICorner", flyBtn)

local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Size = UDim2.new(0.85,0,0,40)
noclipBtn.Position = UDim2.new(0.075,0,0.6,0)
noclipBtn.Text = "NOCLIP: OFF"
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 14
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
Instance.new("UICorner", noclipBtn)

-- ================= FLY =================
local bodyGyro, bodyVel

local function startFly()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	bodyGyro = Instance.new("BodyGyro", hrp)
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bodyGyro.CFrame = hrp.CFrame

	bodyVel = Instance.new("BodyVelocity", hrp)
	bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)

	RunService:BindToRenderStep("FlyMove", 200, function()
		local cam = workspace.CurrentCamera
		local move = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

		bodyVel.Velocity = move.Magnitude > 0 and move.Unit * speed or Vector3.zero
		bodyGyro.CFrame = cam.CFrame
	end)
end

local function stopFly()
	RunService:UnbindFromRenderStep("FlyMove")
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	if bodyVel then bodyVel:Destroy() bodyVel = nil end
end

-- ================= NOCLIP =================
RunService.Stepped:Connect(function()
	if noclip and player.Character then
		for _,v in pairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- ================= BOTONES =================
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		startFly()
		flyBtn.Text = "FLY: ON"
		flyBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		stopFly()
		flyBtn.Text = "FLY: OFF"
		flyBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
	end
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "NOCLIP: ON" or "NOCLIP: OFF"
	noclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end)

-- ================= TECLAS PC =================
UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.F then flyBtn:Activate() end
	if input.KeyCode == Enum.KeyCode.N then noclipBtn:Activate() end
end)

print("Fly + Noclip cargado correctamente 🚀")
