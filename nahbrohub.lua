-- ⚡ NahBro Hub ULTRA
-- SpeedHub / HoHo style | Tabs | Plugins | Aim Assist (Practice) | Web Key (Fake/Pro)

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local HS = game:GetService("HttpService")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- PATHS
local ROOT = "NahBro"
local CFG_FILE = ROOT.."/Config.json"
local KEY_FILE = ROOT.."/key.txt"
local PLUGINS_DIR = ROOT.."/Plugins"

-- FS bootstrap
pcall(function()
	if not isfolder(ROOT) then makefolder(ROOT) end
	if not isfolder(PLUGINS_DIR) then makefolder(PLUGINS_DIR) end
end)

-- =========================
-- 🌐 WEB KEY SYSTEM (FAKE/PRO)
-- =========================
local VALID_KEYS = {["NAHBRO-ULTRA"]=true, ["NAHBRO-2026"]=true}

local function keyGate()
	if isfile(KEY_FILE) then return end
	local g = Instance.new("ScreenGui", game.CoreGui)
	local f = Instance.new("Frame", g)
	f.Size = UDim2.new(0,340,0,200)
	f.Position = UDim2.new(.5,-170,.5,-100)
	f.BackgroundColor3 = Color3.fromRGB(12,12,18)
	f.Active, f.Draggable = true, true
	Instance.new("UICorner", f)

	local t = Instance.new("TextLabel", f)
	t.Text = "NAHBRO HUB • KEY"
	t.Size = UDim2.new(1,0,0,40)
	t.BackgroundTransparency = 1
	t.TextColor3 = Color3.fromRGB(0,255,200)
	t.Font = Enum.Font.GothamBold
	t.TextSize = 18

	local box = Instance.new("TextBox", f)
	box.PlaceholderText = "ENTER KEY"
	box.Size = UDim2.new(.9,0,0,40)
	box.Position = UDim2.new(.05,0,.35,0)
	box.BackgroundColor3 = Color3.fromRGB(22,22,30)
	box.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", box)

	local b = Instance.new("TextButton", f)
	b.Text = "VERIFY (WEB)"
	b.Size = UDim2.new(.9,0,0,36)
	b.Position = UDim2.new(.05,0,.62,0)
	b.BackgroundColor3 = Color3.fromRGB(0,255,200)
	b.TextColor3 = Color3.new(0,0,0)
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(function()
		if VALID_KEYS[box.Text] then
			writefile(KEY_FILE, box.Text)
			g:Destroy()
		else
			box.Text = "INVALID KEY"
		end
	end)

	repeat task.wait() until isfile(KEY_FILE)
end
keyGate()

-- =========================
-- 🧠 CONFIG (ADVANCED)
-- =========================
local Config = {
	Movement = {Speed=16, Jump=50, Fly=false, Noclip=false},
	Visuals = {ESP=false, FPSBoost=false},
	Combat  = {AimAssist=false, FOV=120, Smooth=0.15},
	Player  = {},
	Settings= {Theme="Neon"}
}

pcall(function()
	if isfile(CFG_FILE) then
		Config = HS:JSONDecode(readfile(CFG_FILE))
	end
end)

local function saveCfg()
	pcall(function()
		writefile(CFG_FILE, HS:JSONEncode(Config))
	end)
end

-- =========================
-- 🎨 UI (SpeedHub / HoHo style)
-- =========================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NahBroHubUltra"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,420)
main.Position = UDim2.new(.5,-260,.5,-210)
main.BackgroundColor3 = Color3.fromRGB(12,12,18)
main.Active, main.Draggable = true, true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0,255,200)
stroke.Transparency = .4
stroke.Thickness = 2

-- Sidebar
local side = Instance.new("Frame", main)
side.Size = UDim2.new(0,120,1,0)
side.BackgroundColor3 = Color3.fromRGB(16,16,24)
Instance.new("UICorner", side).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", side)
title.Text = "NAHBRO"
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,200)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Tabs
local pages = {}
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,130,0,10)
content.Size = UDim2.new(1,-140,1,-20)
content.BackgroundTransparency = 1

local function mkPage(name)
	local f = Instance.new("Frame", content)
	f.Size = UDim2.new(1,0,1,0)
	f.Visible = false
	f.BackgroundTransparency = 1
	pages[name] = f
end

for _,n in ipairs({"Movement","Visuals","Combat","Player","Settings"}) do mkPage(n) end
pages.Movement.Visible = true

local y=60
local function tabBtn(name)
	local b = Instance.new("TextButton", side)
	b.Text = name
	b.Size = UDim2.new(1,-10,0,36)
	b.Position = UDim2.new(0,5,0,y)
	y+=42
	b.BackgroundColor3 = Color3.fromRGB(22,22,30)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function()
		for _,p in pairs(pages) do p.Visible=false end
		pages[name].Visible=true
	end)
end
for _,n in ipairs({"Movement","Visuals","Combat","Player","Settings"}) do tabBtn(n) end

-- =========================
-- 🧩 UI Helpers
-- =========================
local function btn(parent, txt, posY, cb)
	local b = Instance.new("TextButton", parent)
	b.Text = txt
	b.Size = UDim2.new(.48,0,0,36)
	b.Position = UDim2.new(0,0,0,posY)
	b.BackgroundColor3 = Color3.fromRGB(22,22,30)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function() cb() saveCfg() end)
	return b
end

local function slider(parent, label, posY, min, max, val, cb)
	local l = Instance.new("TextLabel", parent)
	l.Text = label..": "..val
	l.Position = UDim2.new(0,0,0,posY)
	l.Size = UDim2.new(1,0,0,20)
	l.BackgroundTransparency=1
	l.TextColor3 = Color3.fromRGB(200,200,200)

	local bar = Instance.new("Frame", parent)
	bar.Position = UDim2.new(0,0,0,posY+24)
	bar.Size = UDim2.new(1,0,0,8)
	bar.BackgroundColor3 = Color3.fromRGB(30,30,40)
	Instance.new("UICorner", bar)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(0,255,200)
	Instance.new("UICorner", fill)

	local drag=false
	bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end end)
	UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
	UIS.InputChanged:Connect(function(i)
		if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
			local p=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			local v=math.floor(min+(max-min)*p)
			fill.Size=UDim2.new(p,0,1,0)
			l.Text=label..": "..v
			cb(v) saveCfg()
		end
	end)
end

-- =========================
-- 🚀 MOVEMENT
-- =========================
slider(pages.Movement,"Speed",10,16,150,Config.Movement.Speed,function(v)
	Config.Movement.Speed=v hum.WalkSpeed=v
end)
slider(pages.Movement,"Jump",70,50,200,Config.Movement.Jump,function(v)
	Config.Movement.Jump=v hum.JumpPower=v
end)

btn(pages.Movement,"Fly",130,function()
	Config.Movement.Fly=not Config.Movement.Fly
	if Config.Movement.Fly then
		local bv=Instance.new("BodyVelocity",hrp)
		local bg=Instance.new("BodyGyro",hrp)
		bv.MaxForce=Vector3.new(1e5,1e5,1e5)
		bg.MaxTorque=Vector3.new(1e5,1e5,1e5)
		RS.RenderStepped:Connect(function()
			if Config.Movement.Fly then
				bv.Velocity=cam.CFrame.LookVector*80
				bg.CFrame=cam.CFrame
			end
		end)
	end
end)

-- =========================
-- 👁️ VISUALS
-- =========================
btn(pages.Visuals,"ESP",10,function()
	Config.Visuals.ESP=not Config.Visuals.ESP
	for _,p in pairs(Players:GetPlayers()) do
		if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local box=Instance.new("BoxHandleAdornment",gui)
			box.Adornee=p.Character.HumanoidRootPart
			box.Size=Vector3.new(4,6,4)
			box.Color3=Color3.fromRGB(0,255,200)
			box.AlwaysOnTop=true
			box.Transparency=.5
		end
	end
end)

btn(pages.Visuals,"FPS Boost",60,function()
	settings().Rendering.QualityLevel=1
end)

-- =========================
-- 🎮 COMBAT (AIM ASSIST – PRACTICE)
-- =========================
slider(pages.Combat,"FOV",10,60,300,Config.Combat.FOV,function(v) Config.Combat.FOV=v end)
slider(pages.Combat,"Smooth",70,1,50,math.floor(Config.Combat.Smooth*100),function(v)
	Config.Combat.Smooth=v/100
end)

btn(pages.Combat,"Aim Assist",130,function()
	Config.Combat.AimAssist=not Config.Combat.AimAssist
end)

RS.RenderStepped:Connect(function()
	if not Config.Combat.AimAssist then return end
	local best,dist=nil,Config.Combat.FOV
	for _,p in pairs(Players:GetPlayers()) do
		if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local pos,vis=cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
			if vis then
				local d=(Vector2.new(pos.X,pos.Y)-UIS:GetMouseLocation()).Magnitude
				if d<dist then dist=d best=p.Character.HumanoidRootPart end
			end
		end
	end
	if best then
		cam.CFrame=cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position,best.Position),Config.Combat.Smooth)
	end
end)

-- =========================
-- 🧩 PLUGINS
-- =========================
for _,f in ipairs(listfiles(PLUGINS_DIR)) do
	if f:sub(-4)==".lua" then
		pcall(function()
			loadstring(readfile(f))()
		end)
	end
end

-- =========================
-- ⚙️ SETTINGS
-- =========================
btn(pages.Settings,"Save Config",10,saveCfg)
btn(pages.Settings,"Reset Config",60,function()
	delfile(CFG_FILE)
end)

-- Hide
UIS.InputBegan:Connect(function(i)
	if i.KeyCode==Enum.KeyCode.RightShift then
		main.Visible=not main.Visible
	end
end)

-- Apply
hum.WalkSpeed=Config.Movement.Speed
hum.JumpPower=Config.Movement.Jump
