-- K2 Auto Accept = Chocola UI/flow + cancel on non-target brainrots
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")

------------------------------------------------------------
-- WHITELIST (cancel if THEIR side has a brainrot not in this list)
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
-- CANCEL REMOTE only (getupvalue + name fallback, no indexes)
------------------------------------------------------------
local CANCEL_GUID = "171b5ced-5729-49c0-8d80-9c1897ff1ea3"
local cancelRE = nil
local lastCancelAt = 0

local TradeController
pcall(function()
	TradeController = require(ReplicatedStorage.Controllers.TradeController)
end)

local function resolveCancel()
	if cancelRE and cancelRE.Parent then return cancelRE end
	if TradeController and getupvalue then
		for _, methodName in ipairs({ "CancelTrade", "Cancel", "Decline", "DeclineInvite", "_createLiveTrade", "_createPlayerList" }) do
			local fn = TradeController[methodName]
			if type(fn) == "function" then
				for i = 1, 40 do
					local ok, up = pcall(getupvalue, fn, i)
					if ok and typeof(up) == "Instance" and up:IsA("RemoteEvent") then
						local n = string.lower(up.Name)
						if n:find("cancel", 1, true) then
							cancelRE = up
							return cancelRE
						end
					end
				end
			end
		end
	end
	for _, c in ipairs(Net:GetChildren()) do
		if c:IsA("RemoteEvent") then
			local n = string.lower(c.Name)
			if n:find("canceltrade", 1, true) or (n:find("cancel", 1, true) and n:find("trade", 1, true)) then
				cancelRE = c
				return cancelRE
			end
		end
	end
	local exact = Net:FindFirstChild("RE/TradeService/Cancel") or Net:FindFirstChild("RE/TradeService/CancelTrade")
	if exact and exact:IsA("RemoteEvent") then
		cancelRE = exact
	end
	return cancelRE
end

resolveCancel()
print("[K2] Cancel remote:", cancelRE and cancelRE.Name or "MISSING (will retry on cancel)")

local function cancelTrade(reason)
	if (tick() - lastCancelAt) < 1.5 then return end
	resolveCancel()
	if not cancelRE then
		warn("[K2] Cancel remote still missing")
		return
	end
	lastCancelAt = tick()
	print("[K2] AUTO-CANCEL:", reason or "unknown")
	pcall(function()
		cancelRE:FireServer(CANCEL_GUID)
	end)
end

local function isUnderLocalSide(obj)
	local cur = obj
	while cur and cur ~= LocalPlayer.PlayerGui do
		local n = string.lower(tostring(cur.Name))
		if n:find("local", 1, true) or n:find("self", 1, true) or n:find("mine", 1, true)
			or n:find("myoffer", 1, true) or n:find("my_side", 1, true)
			or n == string.lower(LocalPlayer.Name) or n == string.lower(LocalPlayer.DisplayName)
			or n:find("you", 1, true)
		then
			return true
		end
		if cur:IsA("TextLabel") or cur:IsA("TextButton") then
			local t = cur.Text
			if t == LocalPlayer.Name or t == LocalPlayer.DisplayName then
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
	if next(TargetBrainrots) == nil or next(knownAnimalNames) == nil then return false end
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
-- CHOCOLA GUI + FLOW
------------------------------------------------------------
local uDim2 = nil
pcall(function()
	local raw = readfile("ChocolaAcceptPos.txt")
	local data = HttpService:JSONDecode(raw)
	if data then
		uDim2 = UDim2.new(data.X, data.XOffset, data.Y, data.YOffset)
	end
end)

local function savePos(frame)
	if not frame then return end
	pcall(function()
		local p = frame.Position
		writefile("ChocolaAcceptPos.txt", HttpService:JSONEncode({
			X = p.X.Scale, XOffset = p.X.Offset,
			Y = p.Y.Scale, YOffset = p.Y.Offset,
		}))
	end)
end

local acceptEnabled = true
local statusLabel = nil
local mainFrame = nil
local toggleBtn = nil

local Theme = {
	Dark = Color3.fromRGB(8, 18, 40),
	Light = Color3.fromRGB(0, 200, 255),
	Border = Color3.fromRGB(100, 200, 255),
	Gradient1 = Color3.fromRGB(0, 80, 255),
	Gradient2 = Color3.fromRGB(0, 200, 255),
	Discord = Color3.fromRGB(160, 200, 255),
	Success = Color3.fromRGB(0, 255, 120),
	Error = Color3.fromRGB(255, 80, 100),
}

local function buildGui()
	local old = CoreGui.RobloxGui:FindFirstChild("ChocolaAutoAccept")
	if old then old:Destroy() end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ChocolaAutoAccept"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = CoreGui.RobloxGui

	local Frame = Instance.new("Frame")
	Frame.Name = "MainFrame"
	Frame.Size = UDim2.new(0, 230, 0, 0)
	Frame.Position = uDim2 or UDim2.new(0.5, -115, 0.6, 0)
	Frame.BackgroundColor3 = Theme.Dark
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = true
	Frame.Parent = ScreenGui
	Frame.ClipsDescendants = true
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

	local UIStroke = Instance.new("UIStroke", Frame)
	UIStroke.Color = Theme.Border
	UIStroke.Thickness = 2
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local n1 = 0
	local strokeConn = RunService.Heartbeat:Connect(function()
		n1 = n1 + 0.005
		if n1 > 1 then n1 = 0 end
		local v90 = n1 * math.pi
		local v91 = 80 + 120 * math.sin(v90)
		local v93 = 180 + 75 * math.sin(v90 + 0.5)
		UIStroke.Color = Color3.fromRGB(0, v91, v93)
	end)

	local Header = Instance.new("Frame", Frame)
	Header.Size = UDim2.new(1, 0, 0, 30)
	Header.BackgroundTransparency = 1

	local Title = Instance.new("TextLabel", Header)
	Title.Size = UDim2.new(1, -40, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)
	Title.Text = "K2 AUTO ACCEPT"
	Title.Font = Enum.Font.GothamBlack
	Title.TextSize = 12
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.BackgroundTransparency = 1
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UIGradient", Title).Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Theme.Gradient1),
		ColorSequenceKeypoint.new(0.5, Theme.Gradient2),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})

	local MinBox = Instance.new("Frame", Header)
	MinBox.BackgroundColor3 = Color3.fromRGB(25, 40, 70)
	MinBox.Size = UDim2.new(0, 20, 0, 20)
	MinBox.Position = UDim2.new(1, -26, 0.5, -10)
	Instance.new("UICorner", MinBox).CornerRadius = UDim.new(0, 5)

	local MinBtn = Instance.new("TextButton", MinBox)
	MinBtn.Text = "-"
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.TextSize = 15
	MinBtn.TextColor3 = Theme.Light
	MinBtn.BackgroundTransparency = 1
	MinBtn.Size = UDim2.new(1, 0, 1, 0)

	local Content = Instance.new("Frame", Frame)
	Content.Name = "ContentFrame"
	Content.Size = UDim2.new(1, -16, 1, -45)
	Content.Position = UDim2.new(0, 8, 0, 35)
	Content.BackgroundTransparency = 1
	Content.ClipsDescendants = true

	local Layout = Instance.new("UIListLayout", Content)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Padding = UDim.new(0, 5)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		task.wait()
		Frame.Size = UDim2.new(0, 230, 0, Layout.AbsoluteContentSize.Y + 45)
	end)

	local Row = Instance.new("Frame", Content)
	Row.Size = UDim2.new(0.95, 0, 0, 28)
	Row.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
	Row.BorderSizePixel = 0
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

	local RowLabel = Instance.new("TextLabel", Row)
	RowLabel.Size = UDim2.new(0.6, 0, 1, 0)
	RowLabel.Position = UDim2.new(0, 10, 0, 0)
	RowLabel.Text = "Accept Trades"
	RowLabel.Font = Enum.Font.GothamBold
	RowLabel.TextSize = 11
	RowLabel.TextColor3 = Color3.fromRGB(160, 200, 255)
	RowLabel.BackgroundTransparency = 1
	RowLabel.TextXAlignment = Enum.TextXAlignment.Left

	local Toggle = Instance.new("TextButton", Row)
	Toggle.Size = UDim2.new(0, 50, 0, 22)
	Toggle.Position = UDim2.new(1, -55, 0.5, -11)
	Toggle.BackgroundColor3 = Theme.Success
	Toggle.Text = "ON"
	Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	Toggle.TextSize = 10
	Toggle.Font = Enum.Font.GothamBold
	Toggle.BorderSizePixel = 0
	Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

	Toggle.MouseButton1Click:Connect(function()
		acceptEnabled = not acceptEnabled
		if acceptEnabled then
			Toggle.BackgroundColor3 = Theme.Success
			Toggle.Text = "ON"
			if statusLabel then
				statusLabel.Text = "● Active"
				statusLabel.TextColor3 = Theme.Success
			end
		else
			Toggle.BackgroundColor3 = Theme.Error
			Toggle.Text = "OFF"
			if statusLabel then
				statusLabel.Text = "● Paused"
				statusLabel.TextColor3 = Theme.Error
			end
		end
	end)

	local Status = Instance.new("TextLabel", Content)
	Status.Size = UDim2.new(0.95, 0, 0, 22)
	Status.Text = "● Active"
	Status.Font = Enum.Font.GothamBold
	Status.TextSize = 13
	Status.TextColor3 = Theme.Success
	Status.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
	Status.BorderSizePixel = 0
	Instance.new("UICorner", Status).CornerRadius = UDim.new(0, 6)
	Status.TextXAlignment = Enum.TextXAlignment.Center

	local Disc = Instance.new("TextLabel", Content)
	Disc.Size = UDim2.new(0.95, 0, 0, 18)
	Disc.Text = "discord.gg/bxjXucMVqB"
	Disc.Font = Enum.Font.GothamBold
	Disc.TextSize = 12
	Disc.TextColor3 = Theme.Discord
	Disc.BackgroundTransparency = 1
	Disc.TextXAlignment = Enum.TextXAlignment.Center

	local collapsed = false
	local savedH = 0
	MinBtn.MouseButton1Click:Connect(function()
		collapsed = not collapsed
		if not collapsed then
			Frame.Size = UDim2.new(0, 230, 0, savedH)
			Content.Visible = true
			MinBtn.Text = "-"
			task.wait(0.05)
			local h = Layout.AbsoluteContentSize.Y + 45
			if h ~= savedH then
				savedH = h
				Frame.Size = UDim2.new(0, 230, 0, h)
			end
		else
			savedH = Frame.Size.Y.Offset
			Frame.Size = UDim2.new(0, 230, 0, 30)
			Content.Visible = false
			MinBtn.Text = "+"
		end
		task.wait(0.1)
		savePos(Frame)
	end)

	-- drag + save
	local dragging, dragStart, startPos
	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local d = input.Position - dragStart
			Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			savePos(Frame)
		end
	end)

	Frame.AncestryChanged:Connect(function()
		if not Frame.Parent and strokeConn then
			strokeConn:Disconnect()
		end
	end)

	task.defer(function()
		Frame.Size = UDim2.new(0, 230, 0, Layout.AbsoluteContentSize.Y + 45)
	end)

	return Toggle, Status, Frame
end

local function clickGui(btn)
	if not btn then return end
	if firesignal then
		pcall(function() firesignal(btn.Activated) end)
		pcall(function() firesignal(btn.MouseButton1Click) end)
		return
	end
	pcall(function()
		local VIM = game:GetService("VirtualInputManager")
		local pos = btn.AbsolutePosition + btn.AbsoluteSize / 2
		VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
		VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
	end)
end

local function init()
	print("[K2] Initializing...")
	toggleBtn, statusLabel, mainFrame = buildGui()

	-- Anti-AFK jump every 45s
	task.spawn(function()
		while task.wait(45) do
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				pcall(function()
					hum:ChangeState(Enum.HumanoidStateType.Jumping)
				end)
			end
			if statusLabel then
				statusLabel.Text = "🔄 AFK"
				statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
				task.wait(2)
				if not acceptEnabled then
					statusLabel.Text = "● Paused"
					statusLabel.TextColor3 = Theme.Error
				else
					statusLabel.Text = "● Active"
					statusLabel.TextColor3 = Theme.Success
				end
			end
		end
	end)

	task.delay(5, function()
		local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

		-- AFK tag above head
		local function addAfkTag()
			local head = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChild("Head")
			if not head or head:FindFirstChild("AFKTag") then return end
			local bill = Instance.new("BillboardGui")
			bill.Name = "AFKTag"
			bill.Size = UDim2.new(0, 200, 0, 50)
			bill.StudsOffset = Vector3.new(0, 2.5, 0)
			bill.AlwaysOnTop = true
			bill.Parent = head
			local t = Instance.new("TextLabel")
			t.Size = UDim2.new(1, 0, 1, 0)
			t.BackgroundTransparency = 1
			t.Text = "K2 Auto Accept AFK"
			t.TextColor3 = Theme.Light
			t.TextStrokeTransparency = 0
			t.TextScaled = true
			t.Font = Enum.Font.GothamBold
			t.Parent = bill
		end
		addAfkTag()
		LocalPlayer.CharacterAdded:Connect(function()
			task.wait(1)
			addAfkTag()
		end)

		-- DuelsMachinePrompt Trade Request → Yes
		local root = PlayerGui:FindFirstChild("DuelsMachinePrompt") or PlayerGui:WaitForChild("DuelsMachinePrompt", 60)
		if root then
			local inner = root:FindFirstChild("DuelsMachinePrompt") or root:WaitForChild("DuelsMachinePrompt", 10) or root
			local function tryPrompt(prompt)
				if not acceptEnabled then return end
				local label = prompt:FindFirstChild("Label", true)
				if label and label.Text == "Trade Request" then
					local yes = prompt:FindFirstChild("Yes", true)
					if yes then
						print("[K2] Trade Request → Yes")
						clickGui(yes)
					end
				end
			end
			inner.ChildAdded:Connect(function(child)
				if child.Name == "Prompt" then
					task.defer(function() tryPrompt(child) end)
				end
			end)
			for _, child in ipairs(inner:GetChildren()) do
				if child.Name == "Prompt" then tryPrompt(child) end
			end
			print("[K2] DuelsMachinePrompt hooked")
		else
			warn("[K2] DuelsMachinePrompt not found")
		end

		-- ReadyButton on Other + non-target cancel scan
		task.spawn(function()
			local tradeOpenAt = 0
			local wasInTrade = false
			while task.wait(0.5) do
				if statusLabel then
					if not acceptEnabled then
						statusLabel.Text = "● Paused"
						statusLabel.TextColor3 = Theme.Error
					elseif statusLabel.Text ~= "🔄 AFK" then
						statusLabel.Text = "● Active"
						statusLabel.TextColor3 = Theme.Success
					end
				end

				if not acceptEnabled then continue end

				local tradeUI = PlayerGui:FindFirstChild("TradeLiveTrade")
				if tradeUI and tradeUI.Enabled ~= false then
					if not wasInTrade then
						wasInTrade = true
						tradeOpenAt = tick()
					end
					-- ReadyButton (Chocola)
					local inner = tradeUI:FindFirstChild("TradeLiveTrade", true) or tradeUI
					local other = inner:FindFirstChild("Other", true)
					if other then
						local readyBtn = other:FindFirstChild("ReadyButton") or other:FindFirstChild("ReadyButton", true)
						if readyBtn then
							clickGui(readyBtn)
						end
					end
					-- Cancel if non-target on THEIR side (only after 1s open)
					if (tick() - tradeOpenAt) >= 1.0 then
						scanTradeForNonTargets(tradeUI)
					end
				else
					wasInTrade = false
				end
			end
		end)

		-- Instant scan when labels appear in trade
		PlayerGui.DescendantAdded:Connect(function(obj)
			if not acceptEnabled then return end
			if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
			local tradeUI = PlayerGui:FindFirstChild("TradeLiveTrade")
			if tradeUI and tradeUI.Enabled ~= false then
				task.defer(function()
					scanTradeForNonTargets(tradeUI)
				end)
			end
		end)
	end)

	print("[K2] Initialized (Chocola flow + whitelist cancel)")
end

init()

-- Restart GUI on character respawn (Chocola)
LocalPlayer.CharacterAdded:Connect(function()
	print("[K2] Character added — restarting GUI")
	task.wait(3)
	local old = CoreGui.RobloxGui:FindFirstChild("ChocolaAutoAccept")
	if old then old:Destroy() end
	acceptEnabled = true
	statusLabel = nil
	mainFrame = nil
	toggleBtn = nil
	init()
end)

-- Anti-restart click every 60s
task.spawn(function()
	local VIM = Instance.new("VirtualInputManager")
	print("[K2] Anti-restart click every 60s")
	while task.wait(60) do
		pcall(function()
			VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
			task.wait(0.1)
			VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
		end)
	end
end)

local n = 0
for _ in pairs(TargetBrainrots) do n = n + 1 end
print("[K2] Whitelist size:", n)
