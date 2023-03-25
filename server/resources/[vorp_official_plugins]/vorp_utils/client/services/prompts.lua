PromptsAPI = {}
function PromptsAPI:SetupPromptGroup()
    ----------------- Setup PromptGroup class and add attributes to prompt-----------------
    local GroupsClass = {}
    GroupsClass.PromptGroup = GetRandomIntInRange(0, 0xffffff)
    ----------------- ----------------- ----------------- ----------------- ----------

    ----------------- PromptGroup Specific APIs below -----------------
    function GroupsClass:ShowGroup(text)
        local playerPed = PlayerPedId()
        local isDead = IsEntityDead(playerPed)


        if isDead then
            return
        end

        PromptSetActiveGroupThisFrame(self.PromptGroup, CreateVarString(10, 'LITERAL_STRING', CheckVar(text, 'Prompt Info')))
    end


    function GroupsClass:RegisterPrompt(title, button, enabled, visible, pulsing, mode, options)
        
        ----------------- Setup Prompt class and add attributes to prompt-----------------
        local PromptClass = {}
        PromptClass.Prompt = PromptRegisterBegin()
        PromptClass.Mode = mode
        ----------------- ----------------- ----------------- ----------------- ----------

        PromptSetControlAction(PromptClass.Prompt, CheckVar(button, 0x4CC0E2FE))
        PromptSetText(PromptClass.Prompt, CreateVarString(10, 'LITERAL_STRING', CheckVar(title, 'Title')))
        PromptSetEnabled(PromptClass.Prompt, CheckVar(enabled, 1))
        PromptSetVisible(PromptClass.Prompt, CheckVar(visible, 1))

        if mode == 'click' then
            PromptSetStandardMode(PromptClass.Prompt, 1)
        end

        if mode == 'customhold' then
            Citizen.InvokeNative(0x94073D5CA3F16B7B, PromptClass.Prompt, CheckVar(options and options.holdtime, 3000)) -- UiPromptSetHoldMode
        end

        if mode == 'hold' then
            -- Posible hashes SHORT_TIMED_EVENT_MP, SHORT_TIMED_EVENT, MEDIUM_TIMED_EVENT, LONG_TIMED_EVENT, RUSTLING_CALM_TIMING, PLAYER_FOCUS_TIMING, PLAYER_REACTION_TIMING
            Citizen.InvokeNative(0x74C7D7B72ED0D3CF, PromptClass.Prompt, CheckVar(options and options.timedeventhash, 'MEDIUM_TIMED_EVENT')) -- PromptSetStandardizedHoldMode
        end

        if mode == 'mash' then
            Citizen.InvokeNative(0xDF6423BF071C7F71, PromptClass.Prompt, CheckVar(options and options.mashamount, 20))
        end

        if mode == 'timed' then
            print('timed mode set!')
            Citizen.InvokeNative(0x1473D3AF51D54276, PromptClass.Prompt, CheckVar(options and options.depletiontime, 10000))
        end

        PromptSetGroup(PromptClass.Prompt, self.PromptGroup)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C, PromptClass.Prompt, CheckVar(pulsing, true))
        PromptRegisterEnd(PromptClass.Prompt)
    
        ----------------- Prompt Specific APIs below -----------------
        function PromptClass:TogglePrompt(toggle)
            Citizen.InvokeNative(0x71215ACCFDE075EE, self.Prompt, toggle)
        end

        function PromptClass:DeletePrompt()
            Citizen.InvokeNative(0x00EDE88D4D13CF59, self.Prompt) -- UiPromptDelete
        end

        function PromptClass:HasCompleted(hideoncomplete)
            if self.Mode == 'click' then
                return Citizen.InvokeNative(0xC92AC953F0A982AE, self.Prompt) --UiPromptHasStandardModeCompleted
            end
    
            if self.Mode == 'hold' or self.Mode == 'customhold' then
                local result = Citizen.InvokeNative(0xE0F65F0640EF0617, self.Prompt) --UiPromptHasHoldModeCompleted

                if result then 
                    Wait(500) --Prevents the spamming of the result (ensures it only gets triggered 1 time)
                end
    
                return result
            end
    
            if self.Mode == 'mash' then
                local result = Citizen.InvokeNative(0x845CE958416DC473, self.Prompt) --UiPromptHasMashModeCompleted
                if result then 
                    Wait(500) --Prevents the spamming of the result (ensures it only gets triggered 1 time)
                end

                return result
            end
    
            if self.Mode == 'timed' then
                local result = Citizen.InvokeNative(0x3CE854D250A88DAF, self.Prompt) --UiPromptHasPressedTimedModeCompleted

                if result and CheckVar(hideoncomplete, true) then
                    self:TogglePrompt(false)
                    Wait(200)
                end

                return result
            end
        end

        function PromptClass:HasFailed(hideoncomplete)
            if self.Mode == 'click' or self.Mode == 'hold' or self.Mode == 'customhold' then
                return false
            end
    
            if self.Mode == 'mash' then
                local result = Citizen.InvokeNative(0x25B18E530CF39D6F, self.Prompt) --UiPromptHasMashModeFailed

                if result then
                    self:TogglePrompt(false)
                end
    
                return result
            end
    
            if self.Mode == 'timed' then
                local result = Citizen.InvokeNative(0x1A17B9ECFF617562, self.Prompt) --UiPromptHasPressedTimedModeFailed

                if result and CheckVar(hideoncomplete, true) then
                    self:TogglePrompt(false)
                    Wait(200)
                end

                return result
            end
        end

        return PromptClass
    end

    return GroupsClass
end