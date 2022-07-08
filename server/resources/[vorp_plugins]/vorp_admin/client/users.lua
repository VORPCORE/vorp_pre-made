------------------------------------------------------------------------------------------------------
------------------------------------------ USERS MENU ------------------------------------------------
local VORPNotify = {}

TriggerEvent("getCore", function(core)
    VORPNotify = core
end)

function OpenUsersMenu()
    MenuData.CloseAll()
    local elements = {
        { label = _U("Scoreboard"), value = 'scoreboard', desc = _U("scoreboard_desc") },
        { label = _U("Report"), value = 'report', desc = _U("reportoptions_desc") },
        { label = _U("requeststaff"), value = 'requestStaff', desc = _U("Requeststaff_desc") },
        { label = _U("createticket"), value = 'ticket', desc = _U("tickectdiscord_desc") },
        { label = _U("showMyInfo"), value = 'showinfo', desc = _U("showmyinfo_desc") },
        { label = _U("showJobsOnline"), value = 'showjobs', desc = _U("showjobsonline_desc") },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("MenuSubTitle"),
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            end

            if data.current.value == "scoreboard" then
                ScoreBoard()
            elseif data.current.value == "report" then

                VORPNotify.displayRightTip(_U("notyetavailable"), 4000)

            elseif data.current.value == "requeststaff" then

                VORPNotify.displayRightTip(_U("notyetavailable"), 4000)
            elseif data.current.value == "ticket" then

                VORPNotify.displayRightTip(_U("notyetavailable"), 4000)
            elseif data.current.value == "showinfo" then

                VORPNotify.displayRightTip(_U("notyetavailable"), 4000)
            elseif data.current.value == "showjobs" then

                VORPNotify.displayRightTip(_U("notyetavailable"), 4000)
            end


        end,

        function(data, menu)
            menu.close()

        end)
end

function ScoreBoard()
    MenuData.CloseAll()
    local elements = {
    }

    local players = GetPlayers()
    for key, playersInfo in pairs(players) do

        elements[#elements + 1] = {
            label =  playersInfo.PlayerName ,
            value = "players",
            desc = "</span><br>Server ID:  <span style=color:MediumSeaGreen;>" ..
                playersInfo.serverId ..
                "</span><br>Player Group:  <span style=color:MediumSeaGreen;>" ..
                playersInfo.Group ..
                "</span><br>Player Job: <span style=color:MediumSeaGreen;> " .. playersInfo.Job .. ""
        }
    end

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = "SCOREBOARD",
            subtext  = "Players online",
            align    = 'top-left',
            elements = elements,
            lastmenu = 'OpenUsersMenu', --Go back
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            end

        end,

        function(data, menu)
            menu.close()

        end)
end

function ShowMyInfo()
    MenuData.CloseAll()
    local elements = {
        label = "",
        value = "",
        desc = ""
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = "SCOREBOARD",
            subtext  = "Players online",
            align    = 'top-left',
            elements = elements,
            lastmenu = 'OpenUsersMenu', --Go back
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            end

        end,

        function(data, menu)
            menu.close()

        end)
end

function Report()
    local myInput = {
        type = "enableinput", -- dont touch
        inputType = "textarea",
        button = "Confirm", -- button name
        placeholder = "Your message", --placeholdername
        style = "block", --- dont touch
        attributes = {
            inputHeader = "REPORT SITUATION", -- header
            type = "text", -- inputype text, number,date.etc if number comment out the pattern
            pattern = "[A-Za-z ]{5,10}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
            title = "Must only contain numbers.", -- if input doesnt match show this message
            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
        }
    }

    TriggerEvent("vorpinputs:advancedInput", myInput, function(result)
        local message = result
        print(message)
        -- send to discord
        -- send as a notification for all available staff
        -- send chat message for all available staff
    end)

end
