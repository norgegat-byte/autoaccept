repeat task.wait() until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

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
-- MOON THEME
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
    ToggleOff = Color3.fromRGB(40, 43, 54),
}
local FontTitle = Enum.Font.Michroma
local FontBody = Enum.Font.Nunito

------------------------------------------------------------
-- SETTINGS
------------------------------------------------------------
local SETTINGS_FILE = "K2AutoAccept_Settings.json"
local Settings = {
    TradeBlockingEnabled = true,
    TradeBlockMinimum = 2,   -- max trades from same user before block
    TradeBlockWindow = 30,   -- max seconds in a trade before auto-cancel
}

local function saveSettings()
    if not writefile then return end
    local ok, encoded = pcall(function() return HttpService:JSONEncode(Settings) end)
    if ok then pcall(writefile, SETTINGS_FILE, encoded) end
end

local function loadSettings()
    if not (isfile and readfile) then return end
    local ok1, exists = pcall(isfile, SETTINGS_FILE)
    if not (ok1 and exists) then return end
    local ok2, content = pcall(readfile, SETTINGS_FILE)
    if not (ok2 and content) then return end
    local ok3, decoded = pcall(function() return HttpService:JSONDecode(content) end)
    if ok3 and type(decoded) == "table" then
        if decoded.TradeBlockingEnabled ~= nil then Settings.TradeBlockingEnabled = decoded.TradeBlockingEnabled end
        if decoded.TradeBlockMinimum ~= nil then Settings.TradeBlockMinimum = decoded.TradeBlockMinimum end
        if decoded.TradeBlockWindow ~= nil then Settings.TradeBlockWindow = decoded.TradeBlockWindow end
    end
end
loadSettings()

------------------------------------------------------------
-- TRADE BLOCKING TRACKER (by userId)
------------------------------------------------------------
local inviteHistory = {} -- [userId] = { timestamps }

local function isBlocked(userId)
    if not Settings.TradeBlockingEnabled or not userId then return false end
    local history = inviteHistory[userId]
    if not history then return false end
    local now = tick()
    local window = math.max(Settings.TradeBlockWindow or 30, 1)
    local minCount = math.max(Settings.TradeBlockMinimum or 2, 1)
    local recent = {}
    for _, t in ipairs(history) do
        if now - t <= window then
            table.insert(recent, t)
        end
    end
    inviteHistory[userId] = recent
    return #recent >= minCount
end

local function recordInvite(userId)
    if not userId then return end
    inviteHistory[userId] = inviteHistory[userId] or {}
    table.insert(inviteHistory[userId], tick())
end

local function rejoin()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, plr)
    end)
end

------------------------------------------------------------
-- REMOTES (spy-confirmed indexes)
------------------------------------------------------------
local function getRemote(name)
    local children = Net:GetChildren()
    local indexMap = {
        -- spy-confirmed
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
    -- name fallback
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

print("[K2] AcceptInvite:", acceptInviteRF and acceptInviteRF.Name or "MISSING")
print("[K2] CreateInvite:", createInviteRE and createInviteRE.Name or "MISSING")
print("[K2] Ready:", readyRE and readyRE.Name or "MISSING")
print("[K2] Accept:", acceptRE and acceptRE.Name or "MISSING")
print("[K2] Cancel:", cancelRE and cancelRE.Name or "MISSING")

local function cancelTrade()
    if cancelRE then
        pcall(function()
            cancelRE:FireServer(CANCEL_GUID)
        end)
        print("[K2] CancelTrade fired")
    end
end

------------------------------------------------------------
-- GUI
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local DiscordLabel = Instance.new("TextButton")
local Separator = Instance.new("Frame")
local ListeningLabel = Instance.new("TextLabel")
local MoonIcon = Instance.new("TextLabel")
local SettingsBtn = Instance.new("TextButton")
local SettingsFrame = Instance.new("Frame")
local SettingsTitle = Instance.new("TextLabel")
local SettingsClose = Instance.new("TextButton")
local SettingsScroll = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local DetailFrame = Instance.new("Frame")
local DetailTitle = Instance.new("TextLabel")
local DetailContent = Instance.new("TextLabel")
local DetailClose = Instance.new("TextButton")

ScreenGui.Name = "BoaGuiSmall"
ScreenGui.Parent = plr:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Panel
MainFrame.BackgroundTransparency = 1
MainFrame.Position = UDim2.new(0, 16 + 95, 0, 16 + 39)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BorderSizePixel = 0

SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Parent = ScreenGui
SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsFrame.BackgroundColor3 = Theme.Panel
SettingsFrame.BackgroundTransparency = 1
SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
SettingsFrame.Size = UDim2.new(0, 0, 0, 0)
SettingsFrame.BorderSizePixel = 0
SettingsFrame.Visible = false
SettingsFrame.ClipsDescendants = true

DetailFrame.Name = "DetailFrame"
DetailFrame.Parent = ScreenGui
DetailFrame.Size = UDim2.new(0, 190, 0, 120)
DetailFrame.Position = UDim2.new(0.5, -95, 0.5, -60)
DetailFrame.BackgroundColor3 = Theme.Panel
DetailFrame.BackgroundTransparency = 0.05
DetailFrame.BorderSizePixel = 0
DetailFrame.Visible = false
DetailFrame.ZIndex = 10

DetailTitle.Parent = DetailFrame
DetailTitle.Size = UDim2.new(1, 0, 0, 22)
DetailTitle.Text = "TRACKED ITEMS"
DetailTitle.Font = FontTitle
DetailTitle.TextColor3 = Theme.Moonlight
DetailTitle.TextSize = 11
DetailTitle.BackgroundTransparency = 1

DetailContent.Parent = DetailFrame
DetailContent.Size = UDim2.new(1, -10, 1, -32)
DetailContent.Position = UDim2.new(0, 5, 0, 27)
DetailContent.TextWrapped = true
DetailContent.TextYAlignment = Enum.TextYAlignment.Top
DetailContent.Font = FontBody
DetailContent.TextColor3 = Theme.Moonbeam
DetailContent.TextSize = 11
DetailContent.Text = ""
DetailContent.BackgroundTransparency = 1

DetailClose.Parent = DetailFrame
DetailClose.Size = UDim2.new(0, 16, 0, 16)
DetailClose.Position = UDim2.new(1, -22, 0, 4)
DetailClose.Text = "×"
DetailClose.Font = FontTitle
DetailClose.TextSize = 14
DetailClose.TextColor3 = Theme.Silver
DetailClose.BackgroundTransparency = 1
DetailClose.MouseButton1Click:Connect(function()
    DetailFrame.Visible = false
end)
DetailClose.MouseEnter:Connect(function()
    TweenService:Create(DetailClose, TweenInfo.new(0.15), {TextColor3 = Theme.Moonlight}):Play()
end)
DetailClose.MouseLeave:Connect(function()
    TweenService:Create(DetailClose, TweenInfo.new(0.15), {TextColor3 = Theme.Silver}):Play()
end)

local function makeRounded(parent, radius)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, radius or 12)
    UICorner.Parent = parent
    return UICorner
end

local sweepGradients = {}
local function applyMoonGlow(parent, thickness)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = thickness or 1.4
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Theme.Glow
    UIStroke.Transparency = 0.05
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.DeepGlow),
        ColorSequenceKeypoint.new(0.5, Theme.Moonlight),
        ColorSequenceKeypoint.new(1, Theme.DeepGlow),
    }
    UIGradient.Parent = UIStroke
    UIStroke.Parent = parent
    table.insert(sweepGradients, UIGradient)
    return UIStroke
end

makeRounded(MainFrame, 14)
applyMoonGlow(MainFrame, 1.4)
makeRounded(SettingsFrame, 14)
applyMoonGlow(SettingsFrame, 1.4)
makeRounded(DetailFrame, 12)
applyMoonGlow(DetailFrame, 1.4)

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

local DISCORD_LINK = "discord.gg/bxjXucMVqB"
DiscordLabel.Parent = MainFrame
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Position = UDim2.new(0, 12, 0, 25)
DiscordLabel.Size = UDim2.new(1, -14, 0, 10)
DiscordLabel.Font = FontBody
DiscordLabel.Text = DISCORD_LINK
DiscordLabel.TextColor3 = Theme.Silver
DiscordLabel.TextSize = 8
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left
DiscordLabel.TextTransparency = 1
DiscordLabel.AutoButtonColor = false
DiscordLabel.MouseButton1Click:Connect(function()
    local copied = false
    local copyFn = (getgenv and getgenv().setclipboard) or setclipboard or toclipboard
    if copyFn then
        local ok = pcall(copyFn, DISCORD_LINK)
        copied = ok
    end
    DiscordLabel.Text = copied and "Copied!" or "Copy unsupported"
    DiscordLabel.TextColor3 = copied and Theme.Moonlight or Theme.Silver
    task.delay(1.1, function()
        DiscordLabel.Text = DISCORD_LINK
        DiscordLabel.TextColor3 = Theme.Silver
    end)
end)
DiscordLabel.MouseEnter:Connect(function()
    TweenService:Create(DiscordLabel, TweenInfo.new(0.15), {TextColor3 = Theme.Moonbeam}):Play()
end)
DiscordLabel.MouseLeave:Connect(function()
    TweenService:Create(DiscordLabel, TweenInfo.new(0.15), {TextColor3 = Theme.Silver}):Play()
end)

Separator.Parent = MainFrame
Separator.BackgroundColor3 = Theme.Moonbeam
Separator.BackgroundTransparency = 1
Separator.BorderSizePixel = 0
Separator.Position = UDim2.new(0, 6, 0, 39)
Separator.Size = UDim2.new(1, -12, 0, 1)

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

MoonIcon.Parent = MainFrame
MoonIcon.BackgroundTransparency = 1
MoonIcon.Position = UDim2.new(1, -24, 0, 7)
MoonIcon.Size = UDim2.new(0, 16, 0, 16)
MoonIcon.Font = FontTitle
MoonIcon.Text = "💫"
MoonIcon.TextColor3 = Theme.Moonlight
MoonIcon.TextSize = 15
MoonIcon.TextTransparency = 1

SettingsBtn.Parent = MainFrame
SettingsBtn.Name = "SettingsBtn"
SettingsBtn.BackgroundColor3 = Theme.PanelSoft
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Position = UDim2.new(0, 10, 0, 48)
SettingsBtn.Size = UDim2.new(1, -20, 0, 22)
SettingsBtn.Font = FontBody
SettingsBtn.Text = "Settings"
SettingsBtn.TextColor3 = Theme.Moonlight
SettingsBtn.TextSize = 10
SettingsBtn.TextTransparency = 1
SettingsBtn.AutoButtonColor = false
makeRounded(SettingsBtn, 8)
SettingsBtn.MouseEnter:Connect(function()
    TweenService:Create(SettingsBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
end)
SettingsBtn.MouseLeave:Connect(function()
    TweenService:Create(SettingsBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
end)

SettingsTitle.Parent = SettingsFrame
SettingsTitle.Size = UDim2.new(1, 0, 0, 28)
SettingsTitle.Position = UDim2.new(0, 0, 0, 4)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Font = FontTitle
SettingsTitle.Text = "SETTINGS"
SettingsTitle.TextColor3 = Theme.Moonlight
SettingsTitle.TextSize = 11

SettingsClose.Parent = SettingsFrame
SettingsClose.Size = UDim2.new(0, 20, 0, 20)
SettingsClose.Position = UDim2.new(1, -28, 0, 6)
SettingsClose.Text = "×"
SettingsClose.Font = FontTitle
SettingsClose.TextSize = 16
SettingsClose.TextColor3 = Theme.Silver
SettingsClose.BackgroundTransparency = 1
SettingsClose.MouseEnter:Connect(function()
    TweenService:Create(SettingsClose, TweenInfo.new(0.15), {TextColor3 = Theme.Moonlight}):Play()
end)
SettingsClose.MouseLeave:Connect(function()
    TweenService:Create(SettingsClose, TweenInfo.new(0.15), {TextColor3 = Theme.Silver}):Play()
end)

SettingsScroll.Parent = SettingsFrame
SettingsScroll.Position = UDim2.new(0, 6, 0, 32)
SettingsScroll.Size = UDim2.new(1, -12, 1, -38)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.BorderSizePixel = 0
SettingsScroll.ScrollBarThickness = 2
SettingsScroll.ScrollBarImageColor3 = Theme.Moonbeam
SettingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

UIListLayout.Parent = SettingsScroll
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function makeRow(height)
    local row = Instance.new("Frame")
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, 0, 0, height)
    row.Parent = SettingsScroll
    return row
end

local function makeToggle(parent, initial, onChanged)
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 36, 0, 18)
    track.Position = UDim2.new(1, -36, 0, 2)
    track.BackgroundColor3 = initial and Theme.Moonbeam or Theme.ToggleOff
    track.BorderSizePixel = 0
    track.Parent = parent
    makeRounded(track, 9)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = initial and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Theme.Moonlight
    knob.BorderSizePixel = 0
    knob.Parent = track
    makeRounded(knob, 7)

    local hitbox = Instance.new("TextButton")
    hitbox.BackgroundTransparency = 1
    hitbox.Size = UDim2.new(1, 0, 1, 0)
    hitbox.Text = ""
    hitbox.Parent = track

    local state = initial
    hitbox.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundColor3 = state and Theme.Moonbeam or Theme.ToggleOff
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = state and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2)
        }):Play()
        if onChanged then onChanged(state) end
    end)
    return track
end

local function makeNumberBox(parent, defaultValue, onChanged)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 60, 0, 22)
    box.Position = UDim2.new(1, -60, 0, 0)
    box.BackgroundColor3 = Theme.PanelSoft
    box.BorderSizePixel = 0
    box.Font = FontBody
    box.Text = tostring(defaultValue)
    box.TextColor3 = Theme.Moonlight
    box.TextSize = 11
    box.ClearTextOnFocus = false
    box.Parent = parent
    makeRounded(box, 6)
    applyMoonGlow(box, 1)
    box.FocusLost:Connect(function()
        local digitsOnly = box.Text:gsub("[^%d]", "")
        if digitsOnly == "" then digitsOnly = tostring(defaultValue) end
        box.Text = digitsOnly
        if onChanged then onChanged(tonumber(digitsOnly)) end
    end)
    return box
end

-- Row 1: Trade Blocking toggle
local blockingRow = makeRow(48)
local blockingLabel = Instance.new("TextLabel")
blockingLabel.BackgroundTransparency = 1
blockingLabel.Size = UDim2.new(1, -46, 0, 16)
blockingLabel.Position = UDim2.new(0, 0, 0, 0)
blockingLabel.Font = FontTitle
blockingLabel.Text = "Trade Blocking"
blockingLabel.TextColor3 = Theme.Moonlight
blockingLabel.TextSize = 10
blockingLabel.TextXAlignment = Enum.TextXAlignment.Left
blockingLabel.Parent = blockingRow

local blockingSub = Instance.new("TextLabel")
blockingSub.BackgroundTransparency = 1
blockingSub.Size = UDim2.new(1, 0, 0, 28)
blockingSub.Position = UDim2.new(0, 0, 0, 18)
blockingSub.Font = FontBody
blockingSub.Text = "Limit repeats + auto-cancel long trades"
blockingSub.TextColor3 = Theme.Silver
blockingSub.TextSize = 9
blockingSub.TextWrapped = true
blockingSub.TextXAlignment = Enum.TextXAlignment.Left
blockingSub.TextYAlignment = Enum.TextYAlignment.Top
blockingSub.Parent = blockingRow

makeToggle(blockingRow, Settings.TradeBlockingEnabled, function(state)
    Settings.TradeBlockingEnabled = state
    saveSettings()
end)

-- Row 2: Max trades from same user
local minRow = makeRow(24)
local minLabel = Instance.new("TextLabel")
minLabel.BackgroundTransparency = 1
minLabel.Size = UDim2.new(1, -66, 1, 0)
minLabel.Font = FontBody
minLabel.Text = "Max Trades From Same User"
minLabel.TextColor3 = Theme.Moonbeam
minLabel.TextSize = 10
minLabel.TextXAlignment = Enum.TextXAlignment.Left
minLabel.Parent = minRow
makeNumberBox(minRow, Settings.TradeBlockMinimum, function(value)
    Settings.TradeBlockMinimum = value
    saveSettings()
end)

-- Row 3: Max trade duration (seconds) → auto cancel
local windowRow = makeRow(24)
local windowLabel = Instance.new("TextLabel")
windowLabel.BackgroundTransparency = 1
windowLabel.Size = UDim2.new(1, -66, 1, 0)
windowLabel.Font = FontBody
windowLabel.Text = "Max Trade Duration (Seconds)"
windowLabel.TextColor3 = Theme.Moonbeam
windowLabel.TextSize = 10
windowLabel.TextXAlignment = Enum.TextXAlignment.Left
windowLabel.Parent = windowRow
makeNumberBox(windowRow, Settings.TradeBlockWindow, function(value)
    Settings.TradeBlockWindow = value
    saveSettings()
end)

------------------------------------------------------------
-- Drag
------------------------------------------------------------
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
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
            update(input)
        end
    end)
end
makeDraggable(MainFrame)
makeDraggable(DetailFrame)
makeDraggable(SettingsFrame)

------------------------------------------------------------
-- Settings open/close
------------------------------------------------------------
local settingsOpen = false
local settingsTweening = false
local SETTINGS_SIZE = UDim2.new(0, 220, 0, 210)

local function toggleSettingsPanel()
    if settingsTweening then return end
    settingsTweening = true
    settingsOpen = not settingsOpen
    if settingsOpen then
        SettingsFrame.Visible = true
        local openTween = TweenService:Create(
            SettingsFrame,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Size = SETTINGS_SIZE, BackgroundTransparency = 0.05 }
        )
        openTween.Completed:Connect(function() settingsTweening = false end)
        openTween:Play()
    else
        local closeTween = TweenService:Create(
            SettingsFrame,
            TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
            { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }
        )
        closeTween.Completed:Connect(function()
            SettingsFrame.Visible = false
            settingsTweening = false
        end)
        closeTween:Play()
    end
end

SettingsBtn.MouseButton1Click:Connect(function()
    local original = SettingsBtn.Size
    local pressed = UDim2.new(original.X.Scale, original.X.Offset - 6, original.Y.Scale, original.Y.Offset - 3)
    TweenService:Create(SettingsBtn, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = pressed}):Play()
    task.delay(0.08, function()
        TweenService:Create(SettingsBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = original}):Play()
    end)
    toggleSettingsPanel()
end)

SettingsClose.MouseButton1Click:Connect(function()
    if settingsOpen then toggleSettingsPanel() end
end)

------------------------------------------------------------
-- Entrance animation
------------------------------------------------------------
local growTween = TweenService:Create(
    MainFrame,
    TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    { Size = UDim2.new(0, 190, 0, 78), BackgroundTransparency = 0.08 }
)

local function fadeInText(obj, targetTransparency, delayTime, bgTarget)
    task.delay(delayTime, function()
        local goal = { TextTransparency = targetTransparency }
        if bgTarget then goal.BackgroundTransparency = bgTarget end
        TweenService:Create(obj, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), goal):Play()
    end)
end

growTween:Play()
fadeInText(Title, 0, 0.18)
fadeInText(DiscordLabel, 0, 0.24)
fadeInText(ListeningLabel, 0, 0.3)
fadeInText(MoonIcon, 0, 0.3)
fadeInText(SettingsBtn, 0, 0.36, 0.1)
task.delay(0.3, function()
    TweenService:Create(Separator, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.5}):Play()
end)

RunService.RenderStepped:Connect(function()
    local t = tick()
    MoonIcon.Rotation = (t * 90) % 360
    ListeningLabel.TextTransparency = 0.15 + math.abs(math.sin(t * 1.2)) * 0.35
    for _, grad in ipairs(sweepGradients) do
        grad.Rotation = (t * 45) % 360
    end
end)

------------------------------------------------------------
-- TRACKING
------------------------------------------------------------
local function getTrackedBrainrots()
    local brainrotQueue = {}
    local SYNC_DATA = _G.SYNC_DATA
    if type(SYNC_DATA) == "table" then
        for _, plotData in pairs(SYNC_DATA) do
            if type(plotData) == "table" then
                local owner = plotData.Owner or (type(plotData.Get) == "function" and plotData:Get("Owner"))
                local isOwner = (typeof(owner) == "Instance" and owner == LP)
                    or (typeof(owner) == "table" and owner.UserId == LP.UserId)
                if isOwner then
                    local animalList = plotData.AnimalList or (type(plotData.Get) == "function" and plotData:Get("AnimalList"))
                    if type(animalList) == "table" then
                        for slotKey, data in pairs(animalList) do
                            if type(data) == "table" and data.Index and TargetBrainrots[data.Index] then
                                table.insert(brainrotQueue, tostring(data.Index))
                            end
                        end
                    end
                end
            end
        end
    end
    return brainrotQueue
end

local function tryGetTraderFromUI()
    local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
    if not tradeUI then return nil end
    for _, desc in ipairs(tradeUI:GetDescendants()) do
        if desc:IsA("TextLabel") or desc:IsA("TextButton") then
            local text = desc.Text
            if text and text ~= "" and text ~= plr.Name then
                local other = Players:FindFirstChild(text)
                if other then return other end
            end
        elseif desc:IsA("ObjectValue") and desc.Value and desc.Value:IsA("Player") and desc.Value ~= plr then
            return desc.Value
        end
    end
    return nil
end

------------------------------------------------------------
-- AUTOMATION
------------------------------------------------------------
local currentTradeActive = false
local tradeStartedAt = nil
local lastTrackedItems = {}
local lastKnownTrader = nil

task.spawn(function()
    while true do
        local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
        if tradeUI and tradeUI.Enabled then
            if not currentTradeActive then
                currentTradeActive = true
                tradeStartedAt = tick()
                lastTrackedItems = getTrackedBrainrots()
                local trader = tryGetTraderFromUI()
                if trader then lastKnownTrader = trader end
                ListeningLabel.Text = "in trade ✓"
                MoonIcon.Text = "✅"
            end

            -- Auto-cancel if trade lasts longer than Max Trade Duration
            if Settings.TradeBlockingEnabled and tradeStartedAt then
                local maxDur = Settings.TradeBlockWindow or 30
                if tick() - tradeStartedAt >= maxDur then
                    ListeningLabel.Text = "time limit"
                    MoonIcon.Text = "⏱"
                    cancelTrade()
                    currentTradeActive = false
                    tradeStartedAt = nil
                    lastKnownTrader = nil
                    task.wait(1)
                    ListeningLabel.Text = "listening.."
                    MoonIcon.Text = "💫"
                else
                    if readyRE then pcall(function() readyRE:FireServer(READY_GUID) end) end
                    task.wait(0.8)
                    if acceptRE then pcall(function() acceptRE:FireServer(ACCEPT_GUID) end) end
                end
            else
                if readyRE then pcall(function() readyRE:FireServer(READY_GUID) end) end
                task.wait(0.8)
                if acceptRE then pcall(function() acceptRE:FireServer(ACCEPT_GUID) end) end
            end
        elseif currentTradeActive then
            currentTradeActive = false
            tradeStartedAt = nil
            lastKnownTrader = nil
            ListeningLabel.Text = "listening.."
            MoonIcon.Text = "💫"
        end
        task.wait(0.5)
    end
end)

if createInviteRE then
    createInviteRE.OnClientEvent:Connect(function(tradeId, ...)
        if not tradeId then return end
        local extra = {...}
        local inviter = nil

        for _, arg in ipairs(extra) do
            if typeof(arg) == "Instance" and arg:IsA("Player") and arg ~= plr then
                inviter = arg
                break
            elseif type(arg) == "number" then
                local p = Players:GetPlayerByUserId(arg)
                if p and p ~= plr then
                    inviter = p
                    break
                end
            elseif type(arg) == "string" then
                local p = Players:FindFirstChild(arg)
                if p and p ~= plr then
                    inviter = p
                    break
                end
            end
        end

        if not inviter then
            inviter = tryGetTraderFromUI()
        end

        local userId = inviter and inviter.UserId or nil
        if userId then
            recordInvite(userId)
        end

        -- Block after Max Trades From Same User
        if isBlocked(userId) then
            ListeningLabel.Text = "blocked"
            MoonIcon.Text = "🚫"
            return
        end

        ListeningLabel.Text = "accepting.."
        local success, result = pcall(function()
            return acceptInviteRF:InvokeServer(ACCEPT_INVITE_GUID, tradeId)
        end)

        if success and result then
            ListeningLabel.Text = "in trade ✓"
            MoonIcon.Text = "✅"
            currentTradeActive = true
            tradeStartedAt = tick()
            lastKnownTrader = inviter
        else
            ListeningLabel.Text = "error"
            task.wait(2)
            ListeningLabel.Text = "listening.."
            MoonIcon.Text = "💫"
        end
    end)
else
    warn("[K2] CreateInvite missing — invites won't auto-accept")
end

print("[K2] Auto Accept loaded (spy remotes + trade duration cancel)")
