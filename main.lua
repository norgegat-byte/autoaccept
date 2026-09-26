repeat task.wait() until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")

--- ANTI-AFK ---
pcall(function()
	for _, v in pairs(getconnections(plr.Idled)) do
		if v.Disable then v:Disable() end
	end
end)
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
-- TARGET BRAINROTS
------------------------------------------------------------
local TargetBrainrots = {
	["Spyder Elephant"] = true, ["Strawberry Elephant"] = true, ["Meowl"] = true,
	["Headless Horseman"] = true, ["John Pork"] = true, ["Skibidi Toilet"] = true,
	["Los Dragons"] = true, ["Griffin"] = true, ["Dragon Aquanini"] = true,
	["Dragon Gingerini"] = true, ["Hydra Dragon Cannelloni"] = true, ["Dragon Cannelloni"] = true,
	["Moby Bros"] = true, ["Love Love Bear"] = true, ["Digi Narwhal"] = true,
	["Kraken"] = true, ["La Supreme Combinasion"] = true, ["Hydra Bunny"] = true,
	["Cerberus"] = true, ["Jelly Moby"] = true, ["Celestial Pegasus"] = true,
	["Venuspino"] = true, ["Bumbatron"] = true, ["Bunny and Eggy"] = true,
	["Popcuru and Fizzuru"] = true, ["Rosey and Teddy"] = true, ["La Breakfast Combinasion"] = true,
	["Capitano Moby"] = true, ["Orchidox"] = true, ["Cooki and Milki"] = true,
	["Los Secret Combinasionas"] = true, ["Arcadragon"] = true, ["Burguro And Fryuro"] = true,
	["Ketupat Bros"] = true, ["Reinito Sleighito"] = true, ["Fortunu and Cashuru"] = true,
	["Los Amigos"] = true, ["Pizza and Ranch"] = true, ["Pancake and Syrup"] = true,
	["La Secret Combinasion"] = true, ["Foxini Lanternini"] = true, ["Kalika Bros"] = true,
	["Sammyni Truckini"] = true, ["Los Sekolahs"] = true, ["Signore Carapace"] = true,
	["Cash or Card"] = true, ["Fragrama and Chocrama"] = true, ["La Casa Boo"] = true,
	["Los Admins"] = true, ["La Fuse Machine"] = true, ["Duggy Bros"] = true,
	["La Food Combinasion"] = true, ["Yetimatic"] = true, ["Gold and Diamond"] = true,
	["S'more Serat"] = true, ["Sammyni Cakini"] = true, ["Elefanto Frigo"] = true,
	["Boppin Bunny"] = true, ["Spooky and Pumpky"] = true, ["Cangurato Gelato"] = true,
	["La Craft Machine"] = true, ["Ginger Gerat"] = true, ["La Ginger Sekolah"] = true,
	["Los Chillis"] = true, ["Los Hackers"] = true, ["Bearito Cabinito"] = true,
	["Rubiko and Kubiko"] = true, ["Capitano Americano"] = true, ["Examen Bros"] = true,
	["Los Spaghettis"] = true, ["Rubrikiko"] = true, ["Sammyni Fattini"] = true,
	["Panda Popanda"] = true, ["Festive 67"] = true, ["Queen Bee"] = true,
	["Quackini Snackini"] = true, ["Ventoliero Pavonero"] = true, ["Pop Pop Petalini"] = true,
	["Grabatron"] = true, ["Los Tictacs"] = true, ["Spaghetti Tualetti"] = true,
	["Cloverat Clapat"] = true, ["Candini Fluffini"] = true, ["Polaroidini"] = true,
	["Caylusaurus"] = true, ["Hopilikalika Hopilikalako"] = true, ["La Easter Grande"] = true,
	["Steakini Fattini"] = true, ["Antonio"] = true, ["Garama and Madundung"] = true,
	["La Anniversary Grande"] = true, ["Nacho Spyder"] = true, ["Rosetti Tualetti"] = true,
	["Scorpino Coasterino"] = true, ["Chicli Chicla"] = true, ["Nachorilla"] = true,
	["Money Money Bros"] = true, ["Fishino Clownino"] = true, ["Jolly Jolly Sahur"] = true,
	["Gold Gold Gold"] = true, ["Lavadorito Spinito"] = true, ["Los Tangcitos"] = true,
	["Rico Dinero"] = true, ["Gym Bros"] = true, ["Ketchuru and Musturu"] = true,
	["Tirilikalika Tirilikalako"] = true, ["Swaggy Bros"] = true, ["La Lucky Grande"] = true,
	["La Romantic Grande"] = true, ["Orcaledon"] = true, ["Los Losers"] = true,
	["Tictac Sahur"] = true, ["Dug Dug Dug"] = true, ["Dug dug dug"] = true,
	["Ketupat Kepat"] = true, ["La Taco Combinasion"] = true, ["Coco and Mango"] = true,
	["Tang Tang Keletang"] = true, ["Abyssaloco"] = true, ["Esok Goala"] = true,
	["Lovin Rose"] = true, ["Noo my Resume"] = true, ["Noo my Examen"] = true,
	["Honey Honey Bear"] = true, ["Los Tacoritas"] = true, ["Bufalino Boomberino"] = true,
	["Eviledon"] = true, ["Puffino Builderino"] = true, ["Los Primos"] = true,
	["Sand Sand Sand"] = true, ["Los Mariachis"] = true, ["Los Puggies"] = true,
	["Los Cupids"] = true, ["Esok Sekolah"] = true, ["La Jolly Grande"] = true,
	["W or L"] = true, ["Noodle Noodle Poodle"] = true, ["Globa Steppa"] = true,
	["Tralaledon"] = true, ["Gobblino Uniciclino"] = true, ["Tacoturbo Tacorito"] = true,
	["Tuff Toucan"] = true, ["Mieteteira Bicicleteira"] = true, ["Money Money Reindeer"] = true,
	["Chillin Chili"] = true, ["Chipso and Queso"] = true, ["La Spooky Grande"] = true,
	["Bacuru and Egguru"] = true, ["Los Bros"] = true, ["La Extinct Grande"] = true,
	["Los Candies"] = true, ["Los Fruits"] = true, ["Celularcini Viciosini"] = true,
	["Los 67"] = true, ["Capitano Gullini"] = true, ["Los Mobilis"] = true,
	["Churrito Bunnito"] = true, ["Money Money Puggy"] = true, ["Cigno Fulgoro"] = true,
	["Los Hotspotsitos"] = true, ["Los Jolly Combinasionas"] = true, ["Los Spooky Combinasionas"] = true,
	["Frullato Framingo"] = true, ["Peschito Machito"] = true, ["Chicleteira Champeona"] = true,
	["Deputy Leopard"] = true, ["Girafini Raftini"] = true, ["Snailo Clovero"] = true,
	["Los Planitos"] = true, ["Chicleteira Cupideira"] = true, ["Las Sis"] = true,
	["Camera Ramena"] = true, ["Spinny Hammy"] = true, ["Motorino Bumbino"] = true,
	["Tacorita Bicicleta"] = true, ["Los Sweethearts"] = true, ["Baskito"] = true,
	["Chicleteira Surfeiteira"] = true, ["Chicleteira Noelteira"] = true, ["Bananito"] = true,
	["Los Combinasionas"] = true, ["Nuclearo Dinossauro"] = true, ["Gattino Hydrantino"] = true,
	["Chimnino"] = true, ["Noo my Gold"] = true, ["Noo my Heart"] = true,
	["Swag Soda"] = true, ["Pogo Pogo Penguin"] = true, ["Mariachi Corazoni"] = true,
	["Tacorillo Crocodillo"] = true,
}

local AnimalsData
pcall(function()
	AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
end)

local function normKey(s)
	return (tostring(s or ""):lower():gsub("%s+", ""):gsub("'", ""):gsub("'", ""))
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
-- REMOTES via TradeController getupvalue (no hard indexes)
------------------------------------------------------------
local TradeController
pcall(function()
	TradeController = require(ReplicatedStorage.Controllers.TradeController)
end)

local readyRE, acceptRE, acceptInviteRF, createInviteRE, cancelRE

local function nameSearch(keywords, className)
	for _, c in ipairs(Net:GetChildren()) do
		if (not className or c:IsA(className)) and (c:IsA("RemoteEvent") or c:IsA("RemoteFunction")) then
			local n = string.lower(c.Name)
			local ok = true
			for _, kw in ipairs(keywords) do
				if not n:find(kw, 1, true) then ok = false break end
			end
			if ok then return c end
		end
	end
	-- also try exact path names
	for _, leaf in ipairs({
		"RE/TradeService/Ready", "RE/TradeService/Accept",
		"RF/TradeService/AcceptInvite", "RE/TradeService/CreateInvite",
		"RE/TradeService/Cancel", "RE/TradeService/CancelTrade",
	}) do
		local c = Net:FindFirstChild(leaf)
		if c and (c:IsA("RemoteEvent") or c:IsA("RemoteFunction")) then
			local n = string.lower(leaf)
			local ok = true
			for _, kw in ipairs(keywords) do
				if not n:find(kw, 1, true) then ok = false break end
			end
			if ok then return c end
		end
	end
	return nil
end

local function resolveRemotes()
	-- Chocola-style getupvalue for Ready / Accept
	if TradeController and getupvalue then
		pcall(function()
			readyRE = getupvalue(TradeController._createLiveTrade, 24)
			acceptRE = getupvalue(TradeController._createLiveTrade, 23)
		end)
		-- Try common upvalues on AcceptInvite / Cancel / CreateInvite style methods
		for _, methodName in ipairs({
			"AcceptInvite", "acceptInvite", "RespondInvite", "JoinTrade",
			"CancelTrade", "Cancel", "Decline", "DeclineInvite",
			"CreateInvite", "OnCreateInvite", "_createPlayerList",
		}) do
			local fn = TradeController[methodName]
			if type(fn) == "function" then
				for i = 1, 30 do
					local ok, up = pcall(getupvalue, fn, i)
					if ok and typeof(up) == "Instance" then
						if up:IsA("RemoteFunction") and not acceptInviteRF then
							local n = string.lower(up.Name)
							if n:find("acceptinvite", 1, true) or n:find("accept", 1, true) then
								acceptInviteRF = up
							end
						elseif up:IsA("RemoteEvent") then
							local n = string.lower(up.Name)
							if (n:find("cancel", 1, true)) and not cancelRE then
								cancelRE = up
							elseif (n:find("createinvite", 1, true) or (n:find("create", 1, true) and n:find("invite", 1, true))) and not createInviteRE then
								createInviteRE = up
							end
						end
					end
				end
			end
		end
		-- Also scan getupvalues of _createLiveTrade for AcceptInvite / Cancel
		if type(TradeController._createLiveTrade) == "function" then
			for i = 1, 40 do
				local ok, up = pcall(getupvalue, TradeController._createLiveTrade, i)
				if ok and typeof(up) == "Instance" then
					local n = string.lower(up.Name)
					if up:IsA("RemoteFunction") and n:find("acceptinvite", 1, true) and not acceptInviteRF then
						acceptInviteRF = up
					elseif up:IsA("RemoteEvent") and n:find("cancel", 1, true) and not cancelRE then
						cancelRE = up
					elseif up:IsA("RemoteEvent") and n:find("createinvite", 1, true) and not createInviteRE then
						createInviteRE = up
					end
				end
			end
		end
	end

	-- Name-based fallback (still no indexes)
	readyRE = readyRE or nameSearch({ "ready" }, "RemoteEvent")
	acceptRE = acceptRE or nameSearch({ "accept" }, "RemoteEvent")
	-- prefer AcceptInvite over generic Accept for RF
	acceptInviteRF = acceptInviteRF
		or nameSearch({ "acceptinvite" }, "RemoteFunction")
		or nameSearch({ "accept", "invite" }, "RemoteFunction")
	createInviteRE = createInviteRE
		or nameSearch({ "createinvite" }, "RemoteEvent")
		or nameSearch({ "create", "invite" }, "RemoteEvent")
	cancelRE = cancelRE
		or nameSearch({ "canceltrade" }, "RemoteEvent")
		or nameSearch({ "cancel" }, "RemoteEvent")

	-- Validate types
	if readyRE and not readyRE:IsA("RemoteEvent") then readyRE = nil end
	if acceptRE and not acceptRE:IsA("RemoteEvent") then acceptRE = nil end
	if acceptInviteRF and not acceptInviteRF:IsA("RemoteFunction") then acceptInviteRF = nil end
	if createInviteRE and not createInviteRE:IsA("RemoteEvent") then createInviteRE = nil end
	if cancelRE and not cancelRE:IsA("RemoteEvent") then cancelRE = nil end
end

-- Resolve with short wait (controllers may need a tick)
for _ = 1, 50 do
	resolveRemotes()
	if readyRE and acceptRE and acceptInviteRF then break end
	task.wait(0.1)
end
resolveRemotes()

print("[K2] Ready       :", readyRE and readyRE.Name or "MISSING")
print("[K2] Accept      :", acceptRE and acceptRE.Name or "MISSING")
print("[K2] AcceptInvite:", acceptInviteRF and acceptInviteRF.Name or "MISSING")
print("[K2] CreateInvite:", createInviteRE and createInviteRE.Name or "MISSING")
print("[K2] Cancel      :", cancelRE and cancelRE.Name or "MISSING")

local READY_GUID = "23f15b0b-b633-4f6b-888f-5924b7425522"
local ACCEPT_GUID = "86eea964-f19e-4ac6-b401-a71ecc89e596"
local ACCEPT_INVITE_GUID = "8c94acca-6417-45e5-89f0-efb8b910cde7"
local CANCEL_GUID = "171b5ced-5729-49c0-8d80-9c1897ff1ea3"

local function cancelTrade(reason)
	if not cancelRE then
		-- re-resolve once
		resolveRemotes()
		if not cancelRE then return end
	end
	print("[K2] AUTO-CANCEL:", reason or "unknown")
	pcall(function()
		cancelRE:FireServer(CANCEL_GUID)
	end)
end

local function isGuid(s)
	return type(s) == "string"
		and s:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
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

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.4
stroke.Color = Theme.Glow
stroke.Transparency = 0.05
stroke.Parent = MainFrame

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Theme.DeepGlow),
	ColorSequenceKeypoint.new(0.5, Theme.Moonlight),
	ColorSequenceKeypoint.new(1, Theme.DeepGlow)
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
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

TweenService:Create(MainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back), {
	Size = UDim2.new(0, 190, 0, 48),
	BackgroundTransparency = 0.08
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
local lastAcceptAt = 0

local function tryAcceptInvite(tradeId)
	if not tradeId then return false end
	if not acceptInviteRF then
		resolveRemotes()
	end
	if not acceptInviteRF then return false end
	ListeningLabel.Text = "accepting.."
	local ok, res = pcall(function()
		return acceptInviteRF:InvokeServer(ACCEPT_INVITE_GUID, tradeId)
	end)
	if ok and res then
		ListeningLabel.Text = "in trade ✓"
		MoonIcon.Text = "✅"
		currentTradeActive = true
		tradeOpenAt = tick()
		return true
	end
	ListeningLabel.Text = "error"
	task.delay(2, function()
		if not currentTradeActive then
			ListeningLabel.Text = "listening.."
			MoonIcon.Text = "💫"
		end
	end)
	return false
end

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
					if not readyRE or not acceptRE then resolveRemotes() end
					if readyRE then
						pcall(function() readyRE:FireServer(READY_GUID) end)
					end
					task.wait(0.8)
					if acceptRE then
						pcall(function() acceptRE:FireServer(ACCEPT_GUID) end)
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

-- Bind CreateInvite + catch-all GUID listener
local hooked = {}
local function onPossibleInvite(tradeId, sourceName)
	if not tradeId or not isGuid(tostring(tradeId)) then return end
	if (tick() - lastAcceptAt) < 1.0 then return end
	lastAcceptAt = tick()
	print("[K2] Incoming invite via", sourceName, "id=", tradeId)
	tryAcceptInvite(tradeId)
end

local function bindCreateInvite()
	if not createInviteRE then resolveRemotes() end
	if createInviteRE and not hooked[createInviteRE] then
		hooked[createInviteRE] = true
		createInviteRE.OnClientEvent:Connect(function(tradeId, ...)
			onPossibleInvite(tradeId, createInviteRE.Name)
		end)
		print("[K2] CreateInvite hooked:", createInviteRE.Name)
		return true
	end
	return createInviteRE ~= nil
end

if not bindCreateInvite() then
	warn("[K2] CreateInvite unresolved — using catch-all client hook")
end

for _, child in ipairs(Net:GetChildren()) do
	if child:IsA("RemoteEvent") and not hooked[child] then
		hooked[child] = true
		child.OnClientEvent:Connect(function(a, ...)
			if isGuid(a) then
				onPossibleInvite(a, child.Name)
			end
		end)
	end
end

-- New remotes that appear later
Net.ChildAdded:Connect(function(child)
	task.wait()
	if child:IsA("RemoteEvent") and not hooked[child] then
		hooked[child] = true
		child.OnClientEvent:Connect(function(a, ...)
			if isGuid(a) then
				onPossibleInvite(a, child.Name)
			end
		end)
	end
end)

local n = 0
for _ in pairs(TargetBrainrots) do n = n + 1 end
print("[K2] Loaded | getupvalue + name fallback | whitelist:", n)
