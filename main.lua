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
    ToggleOff = Color3.fromRGB(40, 43, 54),
}
local FontTitle = Enum.Font.Michroma
local FontBody = Enum.Font.Nunito

------------------------------------------------------------
-- BRAINROT LIST
------------------------------------------------------------
local ALL_BRAINROTS = {
    "Strawberry Elephant", "Headless Horseman", "Meowl", "John Pork", "Skibidi Toilet",
    "Griffin", "Dragon Aquanini", "Dragon Gingerini", "Hydra Dragon Cannelloni", "Signore Carapace",
    "Dragon Cannelloni", "Love Love Bear", "Moby Bros", "Digi Narwhal", "Kraken",
    "La Supreme Combinasion", "Elefanto Frigo", "Hydra Bunny", "Celestial Pegasus", "Cerberus",
    "Jelly Moby", "Bumbatron", "Bunny and Eggy", "Popcuru and Fizzuru", "Rosey and Teddy",
    "Capitano Moby", "Cooki and Milki", "Arcadragon", "Burguro And Fryuro", "Los Secret Combinasionas",
    "Ketupat Bros", "Reinito Sleighito", "Fortunu and Cashuru", "Los Amigos", "Pizza and Ranch",
    "Antonio", "La Secret Combinasion", "Pancake and Syrup", "Foxini Lanternini", "Kalika Bros",
    "Los Sekolahs", "Sammyni Fattini", "Fishino Clownino", "Cash or Card", "Fragrama and Chocrama",
    "La Casa Boo", "Los Admins", "Duggy Bros", "La Food Combinasion", "S'more Serat",
    "Sammyni Cakini", "Boppin Bunny", "Spooky and Pumpky", "Ginger Gerat", "La Ginger Sekolah",
    "Los Chillis", "Los Hackers", "Bearito Cabinito", "Rubiko and Kubiko", "Capitano Americano",
    "Examen Bros", "Los Spaghettis", "Rubrikiko", "Festive 67", "Guest 666",
    "Quackini Snackini", "Queen Bee", "Cloverat Clapat", "La Summer Grande", "Los Tictacs",
    "Spaghetti Tualetti", "Caylusaurus", "Hopilikalika Hopilikalako", "La Easter Grande", "Steakini Fattini",
    "Garama and Madundung", "La Anniversary Grande", "Nacho Spyder", "Rosetti Tualetti", "Scorpino Coasterino",
    "Money Money Bros", "Gold Gold Gold", "Jolly Jolly Sahur", "Lavadorito Spinito", "Gym Bros",
    "Ketchuru and Musturu", "Los Tangcitos", "Rico Dinero", "Tirilikalika Tirilikalako", "La Lucky Grande",
    "La Romantic Grande", "Orcaledon", "Swaggy Bros", "Tictac Sahur", "Dug Dug Dug",
    "Ketupat Kepat", "La Taco Combinasion", "Coco and Mango", "Tang Tang Keletang", "Abyssaloco",
    "Esok Goala", "Fragola La La La", "Lovin Rose", "Los Tacoritas", "Eviledon",
    "Los Primos", "Esok Sekolah", "La Jolly Grande", "Los Cupids", "Los Mariachis",
    "Los Puggies", "Sand Sand Sand", "W or L", "Globa Steppa", "Gobblino Uniciclino",
    "Tralaledon", "Mieteteira Bicicleteira", "Tuff Toucan", "Chillin Chili", "Chipso and Queso",
    "Money Money Reindeer", "La Spooky Grande", "Bacuru and Egguru", "Los Bros", "La Extinct Grande",
    "Los Candies", "Los Fruits", "Celularcini Viciosini", "Los 67", "Capitano Gullini",
    "Los Mobilis", "Churrito Bunnito", "Money Money Puggy", "Cigno Fulgoro", "Los Hotspotsitos",
    "Los Jolly Combinasionas", "Los Spooky Combinasionas", "Los Planitos", "Snailo Clovero", "Girafini Raftini",
    "Chicleteira Cupideira", "DJ Panda", "Las Sis", "Camera Ramena", "Spinny Hammy",
    "Los Sweethearts", "Baskito", "Chicleteira Surfeiteira", "Tacorita Bicicleta", "Bananito",
    "Chicleteira Noelteira", "Los Combinasionas", "Nuclearo Dinossauro", "Chimnino", "Noo My Gold",
    "Noo My Heart", "Swag Soda", "Mariachi Corazoni", "Tacorillo Crocodillo", "La Grande Combinasion",
    "Los 25", "Donkeyturbo Express", "John Doe", "Los Chicleteiras", "Quesadillo Vampiro",
    "Octoball", "Horegini Boom", "Glaciator", "La Sahur Combinasion", "Noo my examine",
    "1x1x1x1",
}

------------------------------------------------------------
-- SETTINGS
------------------------------------------------------------
local SETTINGS_FILE = "K2AutoAccept_Settings.json"
local Settings = {
    TradeBlockingEnabled = true,
    TradeBlockMinimum = 2,
    TradeBlockWindow = 30,
    SelectedBrainrots = {},
    WebhookURL = "",
    AutoSellInterval = 10,
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
        if type(decoded.SelectedBrainrots) == "table" then Settings.SelectedBrainrots = decoded.SelectedBrainrots end
        if type(decoded.WebhookURL) == "string" then Settings.WebhookURL = decoded.WebhookURL end
        if decoded.AutoSellInterval ~= nil then Settings.AutoSellInterval = math.max(1, tonumber(decoded.AutoSellInterval) or 10) end
    end
end
loadSettings()

local function syncTargetBrainrots()
    TargetBrainrots = {}
    for name, selected in pairs(Settings.SelectedBrainrots) do
        if selected then TargetBrainrots[name] = true end
    end
    _G.TargetBrainrots = TargetBrainrots
end
syncTargetBrainrots()

------------------------------------------------------------
-- TRADE BLOCKING
------------------------------------------------------------
local inviteHistory = {}

local function isBlocked(userId)
    if not Settings.TradeBlockingEnabled or not userId then return false end
    local history = inviteHistory[userId]
    if not history then return false end
    local now = tick()
    local window = math.max(Settings.TradeBlockWindow or 30, 1)
    local minCount = math.max(Settings.TradeBlockMinimum or 2, 1)
    local recent = {}
    for _, t in ipairs(history) do
        if now - t <= window then table.insert(recent, t) end
    end
    inviteHistory[userId] = recent
    return #recent >= minCount
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
        ["RE/PlotService/Sell"] = 189,
        ["RF/PlotService/Sell"] = 189,
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
local sellRE = getRemote("RE/PlotService/Sell") or getRemote("RF/PlotService/Sell") or getRemote("PlotService/Sell")

print("[K2] Sell remote:", sellRE and sellRE.Name or "MISSING")

local function cancelTrade()
    if cancelRE then pcall(function() cancelRE:FireServer(CANCEL_GUID) end) end
end

local function sellSlot(slot)
    if not sellRE then
        warn("[K2] No sell remote")
        return false
    end
    local ok = pcall(function()
        if sellRE:IsA("RemoteEvent") then
            sellRE:FireServer(tonumber(slot) or slot)
        else
            sellRE:InvokeServer(tonumber(slot) or slot)
        end
    end)
    if not ok then
        pcall(function()
            if sellRE:IsA("RemoteEvent") then
                sellRE:InvokeServer(tonumber(slot) or slot)
            else
                sellRE:FireServer(tonumber(slot) or slot)
            end
        end)
    end
    return true
end

------------------------------------------------------------
-- WEBHOOK EMBEDS
------------------------------------------------------------
local function sendWebhookEmbed(title, description, color, fields)
    local url = Settings.WebhookURL
    if type(url) ~= "string" or url == "" or not string.find(url, "discord.com/api/webhooks") then
        warn("[K2] Invalid webhook URL")
        return
    end

    local embed = {
        title = title,
        description = description,
        color = color,
        fields = fields or {},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        footer = { text = "K2 Auto Accept" }
    }

    local body = HttpService:JSONEncode({
        username = "K2 Auto Accept",
        embeds = { embed }
    })

    local function doRequest(fn)
        return pcall(function()
            fn({
                Url = url,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = body
            })
        end)
    end

    local success = false
    if request then
        success = doRequest(request)
    elseif syn and syn.request then
        success = doRequest(syn.request)
    elseif http_request then
        success = doRequest(http_request)
    else
        success = pcall(function() HttpService:PostAsync(url, body) end)
    end

    if success then
        print("[K2] Webhook sent")
    else
        warn("[K2] Webhook failed")
    end
end

------------------------------------------------------------
-- GUI
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

local SettingsFrame = Instance.new("Frame")
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

local BrainrotFrame = Instance.new("Frame")
BrainrotFrame.Name = "BrainrotFrame"
BrainrotFrame.Parent = ScreenGui
BrainrotFrame.Size = UDim2.new(0, 280, 0, 360)
BrainrotFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
BrainrotFrame.BackgroundColor3 = Theme.Panel
BrainrotFrame.BackgroundTransparency = 0.02
BrainrotFrame.BorderSizePixel = 0
BrainrotFrame.Visible = false
BrainrotFrame.ZIndex = 20
BrainrotFrame.ClipsDescendants = true

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
makeRounded(SettingsFrame, 14)
applyMoonGlow(SettingsFrame, 1.4)
makeRounded(BrainrotFrame, 12)
applyMoonGlow(BrainrotFrame, 1.6)

-- Main Frame content
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
    task.delay(1.1, function() DiscordLabel.Text = "discord.gg/bxjXucMVqB" end)
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

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Parent = MainFrame
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

-- Settings Frame
local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Parent = SettingsFrame
SettingsTitle.Size = UDim2.new(1, 0, 0, 28)
SettingsTitle.Position = UDim2.new(0, 0, 0, 4)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Font = FontTitle
SettingsTitle.Text = "SETTINGS"
SettingsTitle.TextColor3 = Theme.Moonlight
SettingsTitle.TextSize = 11

local SettingsClose = Instance.new("TextButton")
SettingsClose.Parent = SettingsFrame
SettingsClose.Size = UDim2.new(0, 20, 0, 20)
SettingsClose.Position = UDim2.new(1, -28, 0, 6)
SettingsClose.Text = "×"
SettingsClose.Font = FontTitle
SettingsClose.TextSize = 16
SettingsClose.TextColor3 = Theme.Silver
SettingsClose.BackgroundTransparency = 1
SettingsClose.MouseEnter:Connect(function() TweenService:Create(SettingsClose, TweenInfo.new(0.15), {TextColor3 = Theme.Moonlight}):Play() end)
SettingsClose.MouseLeave:Connect(function() TweenService:Create(SettingsClose, TweenInfo.new(0.15), {TextColor3 = Theme.Silver}):Play() end)

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Parent = SettingsFrame
SettingsScroll.Position = UDim2.new(0, 6, 0, 32)
SettingsScroll.Size = UDim2.new(1, -12, 1, -40)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.BorderSizePixel = 0
SettingsScroll.ScrollBarThickness = 3
SettingsScroll.ScrollBarImageColor3 = Theme.Moonbeam
SettingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SettingsScroll.ScrollingEnabled = true

local UIListLayout = Instance.new("UIListLayout")
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
        TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Moonbeam or Theme.ToggleOff}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = state and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
        if onChanged then onChanged(state) end
    end)
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
        local n = tonumber(box.Text:gsub("%D", "")) or defaultValue
        box.Text = tostring(n)
        if onChanged then onChanged(n) end
    end)
end

-- Settings rows
local blockingRow = makeRow(48)
local blockingLabel = Instance.new("TextLabel")
blockingLabel.BackgroundTransparency = 1
blockingLabel.Size = UDim2.new(1, -46, 0, 16)
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
blockingSub.Parent = blockingRow
makeToggle(blockingRow, Settings.TradeBlockingEnabled, function(s)
    Settings.TradeBlockingEnabled = s
    saveSettings()
end)

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
makeNumberBox(minRow, Settings.TradeBlockMinimum, function(v)
    Settings.TradeBlockMinimum = v
    saveSettings()
end)

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
makeNumberBox(windowRow, Settings.TradeBlockWindow, function(v)
    Settings.TradeBlockWindow = v
    saveSettings()
end)

local intervalRow = makeRow(24)
local intervalLabel = Instance.new("TextLabel")
intervalLabel.BackgroundTransparency = 1
intervalLabel.Size = UDim2.new(1, -66, 1, 0)
intervalLabel.Font = FontBody
intervalLabel.Text = "Auto-Sell Interval (Minutes)"
intervalLabel.TextColor3 = Theme.Moonbeam
intervalLabel.TextSize = 10
intervalLabel.TextXAlignment = Enum.TextXAlignment.Left
intervalLabel.Parent = intervalRow
makeNumberBox(intervalRow, Settings.AutoSellInterval, function(v)
    Settings.AutoSellInterval = math.max(1, v)
    saveSettings()
end)

local brainrotRow = makeRow(30)
local brainrotBtn = Instance.new("TextButton")
brainrotBtn.Size = UDim2.new(1, 0, 1, 0)
brainrotBtn.BackgroundColor3 = Theme.PanelSoft
brainrotBtn.BorderSizePixel = 0
brainrotBtn.Font = FontBody
brainrotBtn.Text = "Brainrots  ▼  (click to select)"
brainrotBtn.TextColor3 = Theme.Moonlight
brainrotBtn.TextSize = 12
brainrotBtn.AutoButtonColor = false
brainrotBtn.Parent = brainrotRow
makeRounded(brainrotBtn, 6)
applyMoonGlow(brainrotBtn, 1)
brainrotBtn.MouseEnter:Connect(function() TweenService:Create(brainrotBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.DeepGlow}):Play() end)
brainrotBtn.MouseLeave:Connect(function() TweenService:Create(brainrotBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.PanelSoft}):Play() end)

local webhookRow = makeRow(48)
local webhookLabel = Instance.new("TextLabel")
webhookLabel.BackgroundTransparency = 1
webhookLabel.Size = UDim2.new(1, 0, 0, 14)
webhookLabel.Font = FontTitle
webhookLabel.Text = "Webhook URL"
webhookLabel.TextColor3 = Theme.Moonlight
webhookLabel.TextSize = 10
webhookLabel.TextXAlignment = Enum.TextXAlignment.Left
webhookLabel.Parent = webhookRow
local webhookBox = Instance.new("TextBox")
webhookBox.Size = UDim2.new(1, 0, 0, 22)
webhookBox.Position = UDim2.new(0, 0, 0, 18)
webhookBox.BackgroundColor3 = Theme.PanelSoft
webhookBox.BorderSizePixel = 0
webhookBox.Font = FontBody
webhookBox.Text = Settings.WebhookURL
webhookBox.PlaceholderText = "https://discord.com/api/webhooks/..."
webhookBox.TextColor3 = Theme.Moonlight
webhookBox.PlaceholderColor3 = Theme.Silver
webhookBox.TextSize = 9
webhookBox.ClearTextOnFocus = false
webhookBox.Parent = webhookRow
makeRounded(webhookBox, 6)
applyMoonGlow(webhookBox, 1)
webhookBox.FocusLost:Connect(function()
    Settings.WebhookURL = webhookBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    saveSettings()
end)

-- Brainrot Frame content
local BrainrotTitle = Instance.new("TextLabel")
BrainrotTitle.Parent = BrainrotFrame
BrainrotTitle.Size = UDim2.new(1, -40, 0, 26)
BrainrotTitle.Position = UDim2.new(0, 10, 0, 6)
BrainrotTitle.BackgroundTransparency = 1
BrainrotTitle.Font = FontTitle
BrainrotTitle.Text = "BRAINROTS  (keep these)"
BrainrotTitle.TextColor3 = Theme.Moonlight
BrainrotTitle.TextSize = 12
BrainrotTitle.TextXAlignment = Enum.TextXAlignment.Left
BrainrotTitle.ZIndex = 21

local BrainrotClose = Instance.new("TextButton")
BrainrotClose.Parent = BrainrotFrame
BrainrotClose.Size = UDim2.new(0, 22, 0, 22)
BrainrotClose.Position = UDim2.new(1, -28, 0, 6)
BrainrotClose.Text = "×"
BrainrotClose.Font = FontTitle
BrainrotClose.TextSize = 18
BrainrotClose.TextColor3 = Theme.Silver
BrainrotClose.BackgroundTransparency = 1
BrainrotClose.ZIndex = 21
BrainrotClose.MouseButton1Click:Connect(function() BrainrotFrame.Visible = false end)

local BrainrotSearch = Instance.new("TextBox")
BrainrotSearch.Parent = BrainrotFrame
BrainrotSearch.Size = UDim2.new(1, -20, 0, 26)
BrainrotSearch.Position = UDim2.new(0, 10, 0, 34)
BrainrotSearch.BackgroundColor3 = Theme.PanelSoft
BrainrotSearch.BorderSizePixel = 0
BrainrotSearch.Font = FontBody
BrainrotSearch.PlaceholderText = "Search brainrots..."
BrainrotSearch.Text = ""
BrainrotSearch.TextColor3 = Theme.Moonlight
BrainrotSearch.PlaceholderColor3 = Theme.Silver
BrainrotSearch.TextSize = 12
BrainrotSearch.ClearTextOnFocus = false
BrainrotSearch.ZIndex = 21
makeRounded(BrainrotSearch, 6)
applyMoonGlow(BrainrotSearch, 1)

local BrainrotScroll = Instance.new("ScrollingFrame")
BrainrotScroll.Parent = BrainrotFrame
BrainrotScroll.Position = UDim2.new(0, 6, 0, 68)
BrainrotScroll.Size = UDim2.new(1, -12, 1, -76)
BrainrotScroll.BackgroundTransparency = 1
BrainrotScroll.BorderSizePixel = 0
BrainrotScroll.ScrollBarThickness = 4
BrainrotScroll.ScrollBarImageColor3 = Theme.Moonbeam
BrainrotScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
BrainrotScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
BrainrotScroll.ZIndex = 21

local BrainrotLayout = Instance.new("UIListLayout")
BrainrotLayout.Parent = BrainrotScroll
BrainrotLayout.Padding = UDim.new(0, 3)
BrainrotLayout.SortOrder = Enum.SortOrder.LayoutOrder

local brainrotRows = {}
for i, name in ipairs(ALL_BRAINROTS) do
    local row = Instance.new("Frame")
    row.Name = name
    row.BackgroundColor3 = Theme.PanelSoft
    row.BackgroundTransparency = 0.35
    row.Size = UDim2.new(1, -4, 0, 26)
    row.LayoutOrder = i
    row.Parent = BrainrotScroll
    makeRounded(row, 6)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -48, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.Font = FontBody
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(235, 240, 250)
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.ZIndex = 22
    lbl.Parent = row

    local isOn = Settings.SelectedBrainrots[name] == true
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 36, 0, 18)
    track.Position = UDim2.new(1, -42, 0.5, -9)
    track.BackgroundColor3 = isOn and Theme.Moonbeam or Color3.fromRGB(55, 60, 75)
    track.BorderSizePixel = 0
    track.ZIndex = 22
    track.Parent = row
    makeRounded(track, 9)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = isOn and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 23
    knob.Parent = track
    makeRounded(knob, 7)

    local hitbox = Instance.new("TextButton")
    hitbox.BackgroundTransparency = 1
    hitbox.Size = UDim2.new(1, 0, 1, 0)
    hitbox.Text = ""
    hitbox.ZIndex = 24
    hitbox.Parent = track

    local state = isOn
    hitbox.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(track, TweenInfo.new(0.18), {BackgroundColor3 = state and Theme.Moonbeam or Color3.fromRGB(55, 60, 75)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Back), {Position = state and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
        if state then
            Settings.SelectedBrainrots[name] = true
        else
            Settings.SelectedBrainrots[name] = nil
        end
        syncTargetBrainrots()
        saveSettings()
    end)
    brainrotRows[name] = row
end

BrainrotSearch:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(BrainrotSearch.Text)
    for name, row in pairs(brainrotRows) do
        row.Visible = (q == "" or string.find(string.lower(name), q, 1, true) ~= nil)
    end
end)

brainrotBtn.MouseButton1Click:Connect(function()
    BrainrotFrame.Visible = not BrainrotFrame.Visible
    if BrainrotFrame.Visible then
        BrainrotSearch.Text = ""
        for _, row in pairs(brainrotRows) do row.Visible = true end
    end
end)

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
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(MainFrame)
makeDraggable(SettingsFrame)
makeDraggable(BrainrotFrame)

------------------------------------------------------------
-- Settings open/close
------------------------------------------------------------
local settingsOpen = false
local settingsTweening = false
local SETTINGS_SIZE = UDim2.new(0, 250, 0, 320)

local function toggleSettingsPanel()
    if settingsTweening then return end
    settingsTweening = true
    settingsOpen = not settingsOpen
    if settingsOpen then
        SettingsFrame.Visible = true
        local t = TweenService:Create(SettingsFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = SETTINGS_SIZE, BackgroundTransparency = 0.05})
        t.Completed:Connect(function() settingsTweening = false end)
        t:Play()
    else
        local t = TweenService:Create(SettingsFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        t.Completed:Connect(function()
            SettingsFrame.Visible = false
            settingsTweening = false
        end)
        t:Play()
    end
end

SettingsBtn.MouseButton1Click:Connect(toggleSettingsPanel)
SettingsClose.MouseButton1Click:Connect(function() if settingsOpen then toggleSettingsPanel() end end)

------------------------------------------------------------
-- Entrance
------------------------------------------------------------
local growTween = TweenService:Create(MainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 190, 0, 78), BackgroundTransparency = 0.08
})
growTween:Play()

local function fadeIn(obj, delayTime, bg)
    task.delay(delayTime, function()
        local g = {TextTransparency = 0}
        if bg then g.BackgroundTransparency = bg end
        TweenService:Create(obj, TweenInfo.new(0.35), g):Play()
    end)
end
fadeIn(Title, 0.18)
fadeIn(DiscordLabel, 0.24)
fadeIn(ListeningLabel, 0.3)
fadeIn(MoonIcon, 0.3)
fadeIn(SettingsBtn, 0.36, 0.1)
task.delay(0.3, function()
    TweenService:Create(Separator, TweenInfo.new(0.4), {BackgroundTransparency = 0.5}):Play()
end)

RunService.RenderStepped:Connect(function()
    local t = tick()
    MoonIcon.Rotation = (t * 90) % 360
    ListeningLabel.TextTransparency = 0.15 + math.abs(math.sin(t * 1.2)) * 0.35
    for _, g in ipairs(sweepGradients) do g.Rotation = (t * 45) % 360 end
end)

------------------------------------------------------------
-- DETECTION (exact method from the script you provided)
------------------------------------------------------------
local function getMyPlotAndAnimals()
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then return nil, nil end

    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        for _ = 1, 20 do
            task.wait(0.1)
            hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then break end
        end
    end
    if not hrp then return nil, nil end

    local bestPlot, closestDist = nil, math.huge
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local ok, pos = pcall(function()
            return plot:GetPivot().Position
        end)
        if ok and pos then
            local dist = (pos - hrp.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                bestPlot = plot
            end
        end
    end
    if not bestPlot then return nil, nil end

    local syncFolder = ReplicatedStorage.Packages:FindFirstChild("Synchronizer")
    local requestData = syncFolder and syncFolder:FindFirstChild("RequestData")
    if not requestData then return nil, nil end

    local ok, data = pcall(function()
        return requestData:InvokeServer(bestPlot.Name)
    end)
    if not ok or type(data) ~= "table" or type(data.AnimalList) ~= "table" then
        return nil, nil
    end

    return bestPlot, data.AnimalList
end

local function getPlayerAnimals()
    local animals = {} -- [slot] = name

    local myPlot, animalList = getMyPlotAndAnimals()
    if not animalList then
        print("[K2] No AnimalList found")
        return animals
    end

    for slotKey, data in pairs(animalList) do
        if type(data) == "table" and data.Index then
            local name = tostring(data.Index)
            animals[tostring(slotKey)] = name
        end
    end

    local count = 0
    for _ in pairs(animals) do count = count + 1 end
    print("[K2] Found", count, "brainrots")
    for slot, name in pairs(animals) do
        print("  slot", slot, "→", name)
    end

    return animals
end

------------------------------------------------------------
-- AUTO-SELL + WEBHOOK
------------------------------------------------------------
local function doScanAndSell()
    local animals = getPlayerAnimals()
    local kept, sold = {}, {}

    for slot, name in pairs(animals) do
        if Settings.SelectedBrainrots[name] then
            table.insert(kept, name .. " (slot " .. slot .. ")")
        else
            if sellSlot(slot) then
                table.insert(sold, name .. " (slot " .. slot .. ")")
                print("[K2] Sold:", name)
            end
            task.wait(0.4)
        end
    end

    if #sold > 0 then
        local desc = "**Sold " .. #sold .. " unwanted:**\n```\n" .. table.concat(sold, "\n") .. "\n```"
        if #kept > 0 then
            desc = desc .. "\n\n**Still keeping:**\n```\n" .. table.concat(kept, "\n") .. "\n```"
        end
        sendWebhookEmbed("🔴 Auto-Sold Unwanted Brainrots", desc, 15548997, {
            {name = "Sold", value = tostring(#sold), inline = true},
            {name = "Kept", value = tostring(#kept), inline = true},
        })
        ListeningLabel.Text = "sold " .. #sold
        MoonIcon.Text = "💰"
    else
        local desc = #kept > 0
            and ("**All brainrots kept:**\n```\n" .. table.concat(kept, "\n") .. "\n```")
            or "**No brainrots found.**"
        sendWebhookEmbed("🟢 Scan Complete – Nothing Sold", desc, 5763719, {
            {name = "Kept", value = tostring(#kept), inline = true},
            {name = "Sold", value = "0", inline = true},
        })
        ListeningLabel.Text = "clean ✓"
        MoonIcon.Text = "✅"
    end

    task.delay(5, function()
        if not currentTradeActive then
            ListeningLabel.Text = "listening.."
            MoonIcon.Text = "💫"
        end
    end)
end

_G.K2_ForceScan = doScanAndSell

task.spawn(function()
    while true do
        task.wait(math.max(1, Settings.AutoSellInterval or 10) * 60)
        print("[K2] Scheduled scan...")
        doScanAndSell()
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
            if Settings.TradeBlockingEnabled and tradeStartedAt and (tick() - tradeStartedAt >= (Settings.TradeBlockWindow or 30)) then
                ListeningLabel.Text = "time limit"
                MoonIcon.Text = "⏱"
                cancelTrade()
                currentTradeActive = false
                tradeStartedAt = nil
                task.wait(1)
                ListeningLabel.Text = "listening.."
                MoonIcon.Text = "💫"
            else
                if readyRE then pcall(function() readyRE:FireServer(READY_GUID) end) end
                task.wait(0.8)
                if acceptRE then pcall(function() acceptRE:FireServer(ACCEPT_GUID) end) end
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
        for _, arg in ipairs({...}) do
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

print("[K2] Fully loaded. Use _G.K2_ForceScan() to test sell + webhook.")
