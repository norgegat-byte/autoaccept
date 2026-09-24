repeat task.wait() until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")

--- ANTI-AFK ---
for _, v in pairs(getconnections(plr.Idled)) do
	if v.Disable then v:Disable() end
end
plr.Idled:Connect(function() end)

--- SINGLE INSTANCE ---
local existingGui = plr.PlayerGui:FindFirstChild("BoaGuiSmall")
if existingGui then existingGui:Destroy() end

------------------------------------------------------------
-- THEME
------------------------------------------------------------
local Theme = {
	Panel = Color3.fromRGB(14, 15, 21),
	Moonlight = Color3.fromRGB(223, 229, 240),
	Moonbeam = Color3.fromRGB(168, 183, 214),
	Silver = Color3.fromRGB(120, 132, 158),
	Glow = Color3.fromRGB(199, 210, 235),
	DeepGlow = Color3.fromRGB(58, 66, 92),
}
local FontTitle = Enum.Font.Michroma
local FontBody = Enum.Font.Nunito

------------------------------------------------------------
-- TARGET BRAINROTS — base income OVER 10M/s
-- Source: RBLXGUIDE full roster (atradescam requires Discord login)
-- Cancel ONLY if a non-target DisplayName appears on THEIR side.
------------------------------------------------------------
local TargetBrainrots = {
	-- OG / top
	["Spyder Elephant"] = true,          -- 1B
	["Strawberry Elephant"] = true,      -- 750M
	["Meowl"] = true,                    -- 600M
	["Headless Horseman"] = true,        -- 550M
	["John Pork"] = true,                -- 500M
	["Skibidi Toilet"] = true,           -- 450M
	["Los Dragons"] = true,              -- 425M
	["Griffin"] = true,                  -- 400M
	["Dragon Aquanini"] = true,          -- 375M
	["Dragon Gingerini"] = true,         -- 350M
	["Hydra Dragon Cannelloni"] = true,  -- 300M
	["Dragon Cannelloni"] = true,        -- 250M
	["Moby Bros"] = true,                -- 225M
	["Love Love Bear"] = true,           -- 225M
	["Digi Narwhal"] = true,             -- 200M
	["Kraken"] = true,                   -- 200M
	["La Supreme Combinasion"] = true,   -- 200M
	["Hydra Bunny"] = true,              -- 185M
	["Cerberus"] = true,                 -- 175M
	["Jelly Moby"] = true,               -- 175M
	["Celestial Pegasus"] = true,        -- 175M
	["Venuspino"] = true,                -- 175M
	["Bumbatron"] = true,                -- 172.5M
	["Bunny and Eggy"] = true,           -- 170M
	["Popcuru and Fizzuru"] = true,      -- 170M
	["Rosey and Teddy"] = true,          -- 165M
	["La Breakfast Combinasion"] = true, -- 165M
	["Capitano Moby"] = true,            -- 160M
	["Orchidox"] = true,                 -- 155M
	["Cooki and Milki"] = true,          -- 155M
	["Los Secret Combinasionas"] = true, -- 150M
	["Arcadragon"] = true,               -- 150M
	["Burguro And Fryuro"] = true,       -- 150M
	["Ketupat Bros"] = true,             -- 145M
	["Reinito Sleighito"] = true,        -- 140M
	["Fortunu and Cashuru"] = true,      -- 130M
	["Los Amigos"] = true,               -- 130M
	["Pizza and Ranch"] = true,          -- 130M
	["Pancake and Syrup"] = true,        -- 125M
	["La Secret Combinasion"] = true,    -- 125M
	["Foxini Lanternini"] = true,        -- 115M
	["Kalika Bros"] = true,              -- 115M
	["Sammyni Truckini"] = true,         -- 110M
	["Los Sekolahs"] = true,             -- 110M
	["Signore Carapace"] = true,         -- 105M
	["Cash or Card"] = true,             -- 100M
	["Fragrama and Chocrama"] = true,    -- 100M
	["La Casa Boo"] = true,              -- 100M

	-- 50M–99M
	["Los Admins"] = true,               -- 95M
	["La Fuse Machine"] = true,          -- 95M
	["Duggy Bros"] = true,               -- 90M
	["La Food Combinasion"] = true,      -- 90M
	["Yetimatic"] = true,                -- 87.5M
	["Gold and Diamond"] = true,         -- 85M
	["S'more Serat"] = true,             -- 85M
	["S&#x27;more Serat"] = true,
	["Sammyni Cakini"] = true,           -- 85M
	["Elefanto Frigo"] = true,           -- 85M
	["Boppin Bunny"] = true,             -- 80M
	["Spooky and Pumpky"] = true,        -- 80M
	["Cangurato Gelato"] = true,         -- 77.5M
	["La Craft Machine"] = true,         -- 75M
	["Ginger Gerat"] = true,             -- 75M
	["La Ginger Sekolah"] = true,        -- 75M
	["Los Chillis"] = true,              -- 75M
	["Los Hackers"] = true,              -- 75M
	["Bearito Cabinito"] = true,         -- 72.5M
	["Rubiko and Kubiko"] = true,        -- 72.5M
	["Capitano Americano"] = true,       -- 72.5M
	["Examen Bros"] = true,              -- 70M
	["Los Spaghettis"] = true,           -- 70M
	["Rubrikiko"] = true,                -- 70M
	["Sammyni Fattini"] = true,          -- 70M
	["Panda Popanda"] = true,            -- 67M
	["Festive 67"] = true,               -- 67M
	["Queen Bee"] = true,                -- 65M
	["Quackini Snackini"] = true,        -- 65M
	["Ventoliero Pavonero"] = true,      -- 65M
	["Pop Pop Petalini"] = true,         -- 62.5M
	["Grabatron"] = true,                -- 62.5M
	["Los Tictacs"] = true,              -- 60M
	["Spaghetti Tualetti"] = true,       -- 60M
	["Cloverat Clapat"] = true,          -- 60M
	["Candini Fluffini"] = true,         -- 57.5M
	["Polaroidini"] = true,              -- 55M
	["Caylusaurus"] = true,              -- 55M
	["Hopilikalika Hopilikalako"] = true,-- 55M
	["La Easter Grande"] = true,         -- 55M
	["Steakini Fattini"] = true,         -- 55M
	["Antonio"] = true,                  -- 55M
	["Garama and Madundung"] = true,     -- 50M
	["La Anniversary Grande"] = true,    -- 50M
	["Nacho Spyder"] = true,             -- 50M
	["Rosetti Tualetti"] = true,         -- 50M

	-- 20M–49.9M
	["Scorpino Coasterino"] = true,      -- 47.5M
	["Chicli Chicla"] = true,            -- 47.5M
	["Nachorilla"] = true,               -- 47.5M
	["Money Money Bros"] = true,         -- 47M
	["Fishino Clownino"] = true,         -- 47M
	["Jolly Jolly Sahur"] = true,        -- 45M
	["Gold Gold Gold"] = true,           -- 45M
	["Lavadorito Spinito"] = true,       -- 45M
	["Los Tangcitos"] = true,            -- 42.5M
	["Rico Dinero"] = true,              -- 42.5M
	["Gym Bros"] = true,                 -- 42.5M
	["Ketchuru and Musturu"] = true,     -- 42.5M
	["Tirilikalika Tirilikalako"] = true,-- 42.5M
	["Swaggy Bros"] = true,              -- 40M
	["La Lucky Grande"] = true,          -- 40M
	["La Romantic Grande"] = true,       -- 40M
	["Orcaledon"] = true,                -- 40M
	["Los Losers"] = true,               -- 37.5M
	["Tictac Sahur"] = true,             -- 37.5M
	["Dug Dug Dug"] = true,              -- 35M
	["Dug dug dug"] = true,
	["Ketupat Kepat"] = true,            -- 35M
	["La Taco Combinasion"] = true,      -- 35M
	["Coco and Mango"] = true,           -- 33.5M
	["Tang Tang Keletang"] = true,       -- 33.5M
	["Abyssaloco"] = true,               -- 33.33M
	["Esok Goala"] = true,               -- 32.5M
	["Lovin Rose"] = true,               -- 32.5M
	["Noo my Resume"] = true,            -- 32.5M
	["Noo my Examen"] = true,            -- 32.5M
	["Honey Honey Bear"] = true,         -- 32M
	["Los Tacoritas"] = true,            -- 32M
	["Bufalino Boomberino"] = true,      -- 32M
	["Eviledon"] = true,                 -- 31.5M
	["Puffino Builderino"] = true,       -- 31M
	["Los Primos"] = true,               -- 31M
	["Sand Sand Sand"] = true,           -- 30M
	["Los Mariachis"] = true,            -- 30M
	["Los Puggies"] = true,              -- 30M
	["Los Cupids"] = true,               -- 30M
	["Esok Sekolah"] = true,             -- 30M
	["La Jolly Grande"] = true,          -- 30M
	["W or L"] = true,                   -- 30M
	["Noodle Noodle Poodle"] = true,     -- 27.5M
	["Globa Steppa"] = true,             -- 27.5M
	["Tralaledon"] = true,               -- 27.5M
	["Gobblino Uniciclino"] = true,      -- 27.5M
	["Tacoturbo Tacorito"] = true,       -- 26M
	["Tuff Toucan"] = true,              -- 26M
	["Mieteteira Bicicleteira"] = true,  -- 26M
	["Money Money Reindeer"] = true,     -- 25M
	["Chillin Chili"] = true,            -- 25M
	["Chipso and Queso"] = true,         -- 25M
	["La Spooky Grande"] = true,         -- 24.5M
	["Bacuru and Egguru"] = true,        -- 24M
	["Los Bros"] = true,                 -- 24M
	["La Extinct Grande"] = true,        -- 23.5M
	["Los Candies"] = true,              -- 23M
	["Los Fruits"] = true,               -- 23M
	["Celularcini Viciosini"] = true,    -- 22.5M
	["Los 67"] = true,                   -- 22.5M
	["Capitano Gullini"] = true,         -- 22M
	["Los Mobilis"] = true,              -- 22M
	["Churrito Bunnito"] = true,         -- 21M
	["Money Money Puggy"] = true,        -- 21M
	["Cigno Fulgoro"] = true,            -- 20M
	["Los Hotspotsitos"] = true,         -- 20M
	["Los Jolly Combinasionas"] = true,  -- 20M
	["Los Spooky Combinasionas"] = true, -- 20M
	["Frullato Framingo"] = true,        -- 20M

	-- 10.01M–19.9M
	["Peschito Machito"] = true,         -- 19M
	["Chicleteira Champeona"] = true,    -- 19M
	["Deputy Leopard"] = true,           -- 18M
	["Girafini Raftini"] = true,         -- 18M
	["Snailo Clovero"] = true,           -- 18.5M
	["Los Planitos"] = true,             -- 18.5M
	["Chicleteira Cupideira"] = true,    -- 17.5M
	["Las Sis"] = true,                  -- 17.5M
	["Camera Ramena"] = true,            -- 17M
	["Spinny Hammy"] = true,             -- 17M
	["Motorino Bumbino"] = true,         -- 16.5M
	["Tacorita Bicicleta"] = true,       -- 16.5M
	["Los Sweethearts"] = true,          -- 16.5M
	["Baskito"] = true,                  -- 16M
	["Chicleteira Surfeiteira"] = true,  -- 16M
	["Chicleteira Noelteira"] = true,    -- 15M
	["Bananito"] = true,                 -- 15M
	["Los Combinasionas"] = true,        -- 15M
	["Nuclearo Dinossauro"] = true,      -- 15M
	["Gattino Hydrantino"] = true,       -- 14.5M
	["Chimnino"] = true,                 -- 14M
	["Noo my Gold"] = true,              -- 13.5M
	["Noo my Heart"] = true,             -- 13M
	["Swag Soda"] = true,                -- 13M
	["Pogo Pogo Penguin"] = true,        -- 12.5M
	["Mariachi Corazoni"] = true,        -- 12.5M
	["Tacorillo Crocodillo"] = true,     -- 12.5M
}

local AnimalsData
pcall(function()
	AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
end)

local function normKey(s)
	return (tostring(s or ""):lower():gsub("%s+", ""):gsub("'", ""):gsub("’", ""))
end

local knownAnimalNames = {}
pcall(function()
	if AnimalsData then
		for _, info in pairs(AnimalsData) do
			if type(info) == "table" and type(info.DisplayName) == "string" and #info.DisplayName >= 3 then
				knownAnimalNames[info.DisplayName] = true
			end
		end
	end
end)

local function isTargetName(name)
	if not name or name == "" then return false end
	if TargetBrainrots[name] then return true end
	local key = normKey(name)
	for t, _ in pairs(TargetBrainrots) do
		if normKey(t) == key then return true end
	end
	return false
end

------------------------------------------------------------
-- REMOTES
------------------------------------------------------------
local function getRemote(name)
	local children = Net:GetChildren()
	local indexMap = {
		["RE/TradeService/Ready"] = 172,
		["RE/TradeService/Accept"] = 171,
		["RF/TradeService/AcceptInvite"] = 177,
		["RE/TradeService/CreateInvite"] = 181,
		["RE/TradeService/Cancel"] = 162,
	}
	local idx = indexMap[name]
	if idx then
		local remote = children[idx]
		if remote and (remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent")) then
			return remote
		end
	end
	return nil
end

local READY_GUID = "23f15b0b-b633-4f6b-888f-5924b7425522"
local ACCEPT_GUID = "86eea964-f19e-4ac6-b401-a71ecc89e596"
local ACCEPT_INVITE_GUID = "8c94acca-6417-45e5-89f0-efb8b910cde7"
local CANCEL_GUID = "171b5ced-5729-49c0-8d80-9c1897ff1ea3"

local acceptInviteRF = getRemote("RF/TradeService/AcceptInvite")
local createInviteRE = getRemote("RE/TradeService/CreateInvite")
local readyRE = getRemote("RE/TradeService/Ready")
local acceptRE = getRemote("RE/TradeService/Accept")
local cancelRE = getRemote("RE/TradeService/Cancel")

print("[K2] Ready :", readyRE and readyRE.Name or "MISSING")
print("[K2] Accept:", acceptRE and acceptRE.Name or "MISSING")
print("[K2] Invite:", acceptInviteRF and acceptInviteRF.Name or "MISSING")
print("[K2] Create:", createInviteRE and createInviteRE.Name or "MISSING")
print("[K2] Cancel:", cancelRE and cancelRE.Name or "MISSING")

local function cancelTrade(reason)
	if not cancelRE then return end
	print("[K2] AUTO-CANCEL:", reason or "unknown")
	pcall(function()
		cancelRE:FireServer(CANCEL_GUID)
	end)
end

------------------------------------------------------------
-- THEIR SIDE ONLY
------------------------------------------------------------
local function isUnderLocalSide(obj)
	local cur = obj
	while cur and cur ~= plr.PlayerGui do
		local n = string.lower(tostring(cur.Name))
		if n:find("local", 1, true) or n:find("self", 1, true) or n:find("mine", 1, true)
			or n:find("myoffer", 1, true) or n:find("my_side", 1, true)
			or n == string.lower(plr.Name) or n == string.lower(plr.DisplayName)
			or n:find("you", 1, true)
		then
			return true
		end
		if cur:IsA("TextLabel") or cur:IsA("TextButton") then
			local t = cur.Text
			if t == plr.Name or t == plr.DisplayName then
				return true
			end
		end
		cur = cur.Parent
	end
	return false
end

local function getOpponentRoot(tradeUI)
	local candidates = {
		"Other", "Others", "Opponent", "Their", "Them", "Enemy",
		"RightOffer", "LeftOffer", "Player2", "Offer2", "RemotePlayer",
		"OtherOffer", "TheirOffer", "Partner",
	}
	for _, name in ipairs(candidates) do
		local f = tradeUI:FindFirstChild(name, true)
		if f then return f end
	end
	return tradeUI
end

local function scanTradeForNonTargets(tradeUI)
	if not tradeUI or not tradeUI.Parent then return false end
	if next(TargetBrainrots) == nil then return false end
	if next(knownAnimalNames) == nil then return false end
	local root = getOpponentRoot(tradeUI)
	for _, d in ipairs(root:GetDescendants()) do
		if (d:IsA("TextLabel") or d:IsA("TextButton")) and not isUnderLocalSide(d) then
			local text = d.Text
			if type(text) == "string"
				and #text >= 3
				and knownAnimalNames[text] == true
				and d.Visible ~= false
				and d.AbsoluteSize.X > 2
				and d.AbsoluteSize.Y > 2
			then
				if not isTargetName(text) then
					cancelTrade("Non-target on THEIR side: " .. text)
					return true
				end
			end
		end
	end
	return false
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

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = MainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.4
stroke.Color = Theme.Glow
stroke.Transparency = 0.05
stroke.Parent = MainFrame

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Theme.DeepGlow),
	ColorSequenceKeypoint.new(0.5, Theme.Moonlight),
	ColorSequenceKeypoint.new(1, Theme.DeepGlow),
}
grad.Parent = stroke

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
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

------------------------------------------------------------
-- Entrance
------------------------------------------------------------
TweenService:Create(MainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back), {
	Size = UDim2.new(0, 190, 0, 48),
	BackgroundTransparency = 0.08,
}):Play()

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
	grad.Rotation = (t * 45) % 360
end)

------------------------------------------------------------
-- TRADE AUTOMATION
------------------------------------------------------------
local currentTradeActive = false
local lastCancelAt = 0
local tradeOpenAt = 0

task.spawn(function()
	while true do
		local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
		if tradeUI and tradeUI.Enabled then
			if not currentTradeActive then
				currentTradeActive = true
				tradeOpenAt = tick()
				ListeningLabel.Text = "in trade ✓"
				MoonIcon.Text = "✅"
			end
			local openedFor = tick() - tradeOpenAt
			if openedFor >= 1.0 and (tick() - lastCancelAt) > 1.5 then
				local cancelled = scanTradeForNonTargets(tradeUI)
				if cancelled then
					lastCancelAt = tick()
					currentTradeActive = false
					ListeningLabel.Text = "cancelled"
					MoonIcon.Text = "🚫"
					task.delay(1.2, function()
						if not currentTradeActive then
							ListeningLabel.Text = "listening.."
							MoonIcon.Text = "💫"
						end
					end)
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
			end
		elseif currentTradeActive then
			currentTradeActive = false
			ListeningLabel.Text = "listening.."
			MoonIcon.Text = "💫"
		end
		task.wait(0.5)
	end
end)

plr.PlayerGui.DescendantAdded:Connect(function(obj)
	if not currentTradeActive then return end
	if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
	if (tick() - tradeOpenAt) < 1.0 then return end
	if (tick() - lastCancelAt) < 1.5 then return end
	local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
	if tradeUI and tradeUI.Enabled then
		task.defer(function()
			if scanTradeForNonTargets(tradeUI) then
				lastCancelAt = tick()
				currentTradeActive = false
				ListeningLabel.Text = "cancelled"
				MoonIcon.Text = "🚫"
			end
		end)
	end
end)

if createInviteRE then
	createInviteRE.OnClientEvent:Connect(function(tradeId, ...)
		if not tradeId then return end
		ListeningLabel.Text = "accepting.."
		local ok, res = pcall(function()
			return acceptInviteRF:InvokeServer(ACCEPT_INVITE_GUID, tradeId)
		end)
		if ok and res then
			ListeningLabel.Text = "in trade ✓"
			MoonIcon.Text = "✅"
			currentTradeActive = true
			tradeOpenAt = tick()
		else
			ListeningLabel.Text = "error"
			task.wait(2)
			ListeningLabel.Text = "listening.."
			MoonIcon.Text = "💫"
		end
	end)
end

local n = 0
for _ in pairs(TargetBrainrots) do n = n + 1 end
print("[K2] Loaded | whitelist:", n, "brainrots (>10M/s) | cancel ONLY non-target on THEIR side")
