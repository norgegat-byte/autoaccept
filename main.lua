repeat task.wait() until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local LP = plr
local TargetBrainrots = _G.TargetBrainrots or {}
local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")

--- ANTI-AFK ---
for i, v in pairs(getconnections(plr.Idled)) do
	if v.Disable then v:Disable() end
end
plr.Idled:Connect(function() end)

--- SINGLE INSTANCE CHECK ---
local existingGui = plr.PlayerGui:FindFirstChild("BoaGuiSmall")
if existingGui then existingGui:Destroy() end

------------------------------------------------------------
-- THEME
------------------------------------------------------------
local Theme = {
	Void = Color3.fromRGB(8, 9, 13),
	Panel = Color3.fromRGB(14, 15, 21),
	PanelSoft = Color3.fromRGB(20, 22, 30),
	Moonlight = Color3.fromRGB(223, 229, 240),
	Moonbeam = Color3.fromRGB(168, 183, 214),
	Silver = Color3.fromRGB(120, 132, 158),
	Glow = Color3.fromRGB(199, 210, 235),
	DeepGlow = Color3.fromRGB(58, 66, 92),
}
local FontTitle = Enum.Font.Michroma
local FontBody = Enum.Font.Nunito

------------------------------------------------------------
-- TRADE BLOCKING (fixed defaults — no settings UI)
------------------------------------------------------------
local TradeBlockingEnabled = true
local TradeBlockMinimum = 2
local TradeBlockWindow = 30 -- max seconds in a trade before auto-cancel

local inviteHistory = {}

local function isBlocked(userId)
	if not TradeBlockingEnabled or not userId then return false end
	local history = inviteHistory[userId]
	if not history then return false end
	local now = tick()
	local recent = {}
	for _, t in ipairs(history) do
		if now - t <= TradeBlockWindow then
			table.insert(recent, t)
		end
	end
	inviteHistory[userId] = recent
	return #recent >= TradeBlockMinimum
end

local function recordInvite(userId)
	if not userId then return end
	inviteHistory[userId] = inviteHistory[userId] or {}
	table.insert(inviteHistory[userId], tick())
end

------------------------------------------------------------
-- REMOTES
------------------------------------------------------------
local function getRemote(name)
	local children = Net:GetChildren()
	local indexMap = {
		["RE/TradeService/Ready"] = 45,
		["RE/TradeService/Accept"] = 46,
		["RE/TradeService/CancelTrade"] = 55,
		["RF/TradeService/AcceptInvite"] = 40,
		["RE/TradeService/CreateInvite"] = 44,
	}
	local idx = indexMap[name]
	if idx then
		local remote = children[idx]
		if remote and (remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent")) then
			return remote
		end
	end
	local byName = Net:FindFirstChild(name)
	if byName and (byName:IsA("RemoteFunction") or byName:IsA("RemoteEvent")) then
		return byName
	end
	for _, child in ipairs(children) do
		if string.find(child.Name, name, 1, true) then
			if child:IsA("RemoteFunction") or child:IsA("RemoteEvent") then
				return child
			end
		end
	end
	return nil
end

local CANCEL_GUID = "9d1937e7-6262-487b-98be-af45618270c9"
local READY_GUID = "d73acf93-6f32-44df-b813-0f6b32c7afd9"
local ACCEPT_GUID = "918ee0f5-e98f-413f-b76e-baee47b021cb"
local ACCEPT_INVITE_GUID = "57624f2b-8aa9-4974-bb7a-08f058af33ef"

local acceptInviteRF = getRemote("RF/TradeService/AcceptInvite")
local createInviteRE = getRemote("RE/TradeService/CreateInvite")
local readyRE = getRemote("RE/TradeService/Ready")
local acceptRE = getRemote("RE/TradeService/Accept")
local cancelRE = getRemote("RE/TradeService/CancelTrade")

local function cancelTrade()
	if cancelRE then
		pcall(function()
			cancelRE:FireServer(CANCEL_GUID)
		end)
	end
end

------------------------------------------------------------
-- GUI (main only — no settings / no brainrot picker)
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BoaGuiSmall"
ScreenGui.Parent = plr:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Panel
MainFrame.BackgroundTransparency = 1
MainFrame.Position = UDim2.new(0, 111, 0, 55)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BorderSizePixel = 0

local function makeRounded(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 12)
	c.Parent = parent
end

local sweepGradients = {}
local function applyMoonGlow(parent, thickness)
	local s = Instance.new("UIStroke")
	s.Thickness = thickness or 1.4
	s.Color = Theme.Glow
	s.Transparency = 0.05
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Theme.DeepGlow),
		ColorSequenceKeypoint.new(0.5, Theme.Moonlight),
		ColorSequenceKeypoint.new(1, Theme.DeepGlow),
	}
	g.Parent = s
	s.Parent = parent
	table.insert(sweepGradients, g)
end

makeRounded(MainFrame, 14)
applyMoonGlow(MainFrame, 1.4)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 8)
Title.Size = UDim2.new(1, -14, 0, 18)
Title.Font = FontTitle
Title.Text = "K2 Auto Accept"
Title.TextColor3 = Theme.Moonlight
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextTransparency = 1

local DiscordLabel = Instance.new("TextButton")
DiscordLabel.Parent = MainFrame
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Position = UDim2.new(0, 12, 0, 25)
DiscordLabel.Size = UDim2.new(1, -14, 0, 10)
DiscordLabel.Font = FontBody
DiscordLabel.Text = "discord.gg/bxjXucMVqB"
DiscordLabel.TextColor3 = Theme.Silver
DiscordLabel.TextSize = 8
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left
DiscordLabel.TextTransparency = 1
DiscordLabel.AutoButtonColor = false
DiscordLabel.MouseButton1Click:Connect(function()
	local fn = (getgenv and getgenv().setclipboard) or setclipboard or toclipboard
	if fn then pcall(fn, "discord.gg/bxjXucMVqB") end
	DiscordLabel.Text = "Copied!"
	task.delay(1.1, function()
		DiscordLabel.Text = "discord.gg/bxjXucMVqB"
	end)
end)

local Separator = Instance.new("Frame")
Separator.Parent = MainFrame
Separator.BackgroundColor3 = Theme.Moonbeam
Separator.BackgroundTransparency = 1
Separator.BorderSizePixel = 0
Separator.Position = UDim2.new(0, 6, 0, 39)
Separator.Size = UDim2.new(1, -12, 0, 1)

local ListeningLabel = Instance.new("TextLabel")
ListeningLabel.Parent = MainFrame
ListeningLabel.BackgroundTransparency = 1
ListeningLabel.Position = UDim2.new(1, -85, 0, 10)
ListeningLabel.Size = UDim2.new(0, 60, 0, 15)
ListeningLabel.Font = FontBody
ListeningLabel.Text = "listening.."
ListeningLabel.TextColor3 = Theme.Moonbeam
ListeningLabel.TextSize = 9
ListeningLabel.TextXAlignment = Enum.TextXAlignment.Right
ListeningLabel.TextTransparency = 1

local MoonIcon = Instance.new("TextLabel")
MoonIcon.Parent = MainFrame
MoonIcon.BackgroundTransparency = 1
MoonIcon.Position = UDim2.new(1, -24, 0, 7)
MoonIcon.Size = UDim2.new(0, 16, 0, 16)
MoonIcon.Font = FontTitle
MoonIcon.Text = "💫"
MoonIcon.TextColor3 = Theme.Moonlight
MoonIcon.TextSize = 15
MoonIcon.TextTransparency = 1

------------------------------------------------------------
-- Drag
------------------------------------------------------------
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end
makeDraggable(MainFrame)

------------------------------------------------------------
-- Entrance (smaller — no Settings button)
------------------------------------------------------------
local growTween = TweenService:Create(MainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back), {
	Size = UDim2.new(0, 190, 0, 48),
	BackgroundTransparency = 0.08,
})
growTween:Play()

local function fadeIn(obj, delayTime)
	task.delay(delayTime, function()
		TweenService:Create(obj, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()
	end)
end
fadeIn(Title, 0.18)
fadeIn(DiscordLabel, 0.24)
fadeIn(ListeningLabel, 0.3)
fadeIn(MoonIcon, 0.3)
task.delay(0.3, function()
	TweenService:Create(Separator, TweenInfo.new(0.4), { BackgroundTransparency = 0.5 }):Play()
end)

RunService.RenderStepped:Connect(function()
	local t = tick()
	MoonIcon.Rotation = (t * 90) % 360
	ListeningLabel.TextTransparency = 0.15 + math.abs(math.sin(t * 1.2)) * 0.35
	for _, g in ipairs(sweepGradients) do
		g.Rotation = (t * 45) % 360
	end
end)

------------------------------------------------------------
-- TRADE AUTOMATION
------------------------------------------------------------
local currentTradeActive = false
local tradeStartedAt = nil

task.spawn(function()
	while true do
		local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
		if tradeUI and tradeUI.Enabled then
			if not currentTradeActive then
				currentTradeActive = true
				tradeStartedAt = tick()
				ListeningLabel.Text = "in trade ✓"
				MoonIcon.Text = "✅"
			end
			if TradeBlockingEnabled and tradeStartedAt and (tick() - tradeStartedAt >= TradeBlockWindow) then
				ListeningLabel.Text = "time limit"
				MoonIcon.Text = "⏱"
				cancelTrade()
				currentTradeActive = false
				tradeStartedAt = nil
				task.wait(1)
				ListeningLabel.Text = "listening.."
				MoonIcon.Text = "💫"
			else
				if readyRE then
					pcall(function()
						readyRE:FireServer(READY_GUID)
					end)
				end
				task.wait(0.8)
				if acceptRE then
					pcall(function()
						acceptRE:FireServer(ACCEPT_GUID)
					end)
				end
			end
		elseif currentTradeActive then
			currentTradeActive = false
			tradeStartedAt = nil
			ListeningLabel.Text = "listening.."
			MoonIcon.Text = "💫"
		end
		task.wait(0.5)
	end
end)

if createInviteRE then
	createInviteRE.OnClientEvent:Connect(function(tradeId, ...)
		if not tradeId then return end
		local inviter = nil
		for _, arg in ipairs({ ... }) do
			if typeof(arg) == "Instance" and arg:IsA("Player") and arg ~= plr then
				inviter = arg
				break
			elseif type(arg) == "number" then
				inviter = Players:GetPlayerByUserId(arg)
				if inviter and inviter ~= plr then break end
			end
		end
		local userId = inviter and inviter.UserId
		if userId then recordInvite(userId) end
		if isBlocked(userId) then
			ListeningLabel.Text = "blocked"
			MoonIcon.Text = "🚫"
			return
		end
		ListeningLabel.Text = "accepting.."
		local ok, res = pcall(function()
			return acceptInviteRF:InvokeServer(ACCEPT_INVITE_GUID, tradeId)
		end)
		if ok and res then
			ListeningLabel.Text = "in trade ✓"
			MoonIcon.Text = "✅"
			currentTradeActive = true
			tradeStartedAt = tick()
		else
			ListeningLabel.Text = "error"
			task.wait(2)
			ListeningLabel.Text = "listening.."
			MoonIcon.Text = "💫"
		end
	end)
end

print("[K2] Loaded (no settings / no auto-sell)")
