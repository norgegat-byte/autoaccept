
------------------------------------------------------------
-- K2: INCOMING TRADE REQUEST AUTO-ACCEPT
-- UI-based handler; does not guess remote arguments.
------------------------------------------------------------
task.spawn(function()
    local pg = plr:WaitForChild("PlayerGui")
    local root = pg:FindFirstChild("DuelsMachinePrompt")
        or pg:WaitForChild("DuelsMachinePrompt", 30)

    if not root then
        warn("[K2] Trade prompt UI not found.")
        ListeningLabel.Text = "prompt unavailable"
        return
    end

    local handled = setmetatable({}, { __mode = "k" })

    local function normalizedText(obj)
        if obj:IsA("TextLabel")
            or obj:IsA("TextButton")
            or obj:IsA("TextBox") then
            return (obj.Text or "")
                :lower()
                :gsub("%s+", " ")
                :match("^%s*(.-)%s*$")
        end
        return ""
    end

    local function isTradeRequest(prompt)
        for _, obj in ipairs(prompt:GetDescendants()) do
            local text = normalizedText(obj)
            if text == "trade request"
                or text == "trade request!" then
                return true
            end
        end
        return false
    end

    local function findYesButton(prompt)
        for _, obj in ipairs(prompt:GetDescendants()) do
            if obj:IsA("TextButton")
                and normalizedText(obj) == "yes"
                and obj.Visible
                and obj.Active then
                return obj
            end
        end
        return nil
    end

    local function processPrompt(prompt)
        if not prompt or not prompt.Parent then
            return
        end

        if handled[prompt] then
            return
        end

        if not isTradeRequest(prompt) then
            return
        end

        local yes = findYesButton(prompt)
        if not yes then
            return
        end

        -- Mark before clicking to prevent duplicate processing.
        handled[prompt] = true

        ListeningLabel.Text = "accepting..."
        MoonIcon.Text = "✓"

        print("[K2] Incoming trade request detected")

        clickGui(yes)

        task.delay(0.5, function()
            if not ScreenGui.Parent then
                return
            end

            local tradeUI =
                pg:FindFirstChild("TradeLiveTrade")

            if tradeUI and tradeUI.Enabled then
                ListeningLabel.Text = "in trade ✓"
                MoonIcon.Text = "✓"
            else
                ListeningLabel.Text = "listening.."
                MoonIcon.Text = "💫"
            end
        end)
    end

    local function watchPrompt(prompt)
        if prompt.Name ~= "Prompt" then
            return
        end

        processPrompt(prompt)

        -- Some games populate prompt contents after creating it.
        prompt.DescendantAdded:Connect(function()
            task.defer(function()
                processPrompt(prompt)
            end)
        end)

        -- Retry briefly while the prompt's UI finishes loading.
        task.spawn(function()
            for _ = 1, 20 do
                if not prompt.Parent or handled[prompt] then
                    break
                end

                processPrompt(prompt)
                task.wait(0.15)
            end
        end)
    end

    local function inspectContainer(container)
        for _, obj in ipairs(container:GetDescendants()) do
            if obj.Name == "Prompt" then
                watchPrompt(obj)
            end
        end
    end

    -- Listen for prompts under the entire GUI, including nested containers.
    root.DescendantAdded:Connect(function(obj)
        if obj.Name == "Prompt" then
            task.defer(function()
                watchPrompt(obj)
            end)
        end
    end)

    inspectContainer(root)

    print("[K2] Incoming trade-request UI listener active")
end)
