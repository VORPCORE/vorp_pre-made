Logs = {
WebHook = {
        -- =================== INVENTORY LOGS =====================--

    webhookname = "INVENTORY LOGS",
    webhook                  = "LOG URL HERR", 
   
    --Gold Logs Color
   colorpickedgold = 65280,
   colorgiveGold = 4286945,
   colorDropGold = 16711680,
   
   --Money log color
   colorgiveMoney = 4286945,
   colormoneypickup= 65280,
   colorDropMoney = 16711680,
   
   --Item log color
   coloritemDrop =16711680,
   coloritempickup = 65280,
   colorgiveitem  = 4286945,
   
   --Weapon log color
   colorweppickupd = 65280 ,
   colorgiveWep = 4286945,
   colordropedwep = 16711680,
    -- =================== CUSTOM INVENTORY LOGS =====================--

    cuscolor = 16711680,
    custitle = "CUSTOM INV LOGS",
    cusavatar = "",
    cuslogo = "",
    cusfooterlogo = "",
    cuswebhookname = "CUSTOM INV LOGS",
    CustomInventoryTakeFrom = "Took From LOG URL HERR ",
    CustomInventoryMoveTo = "Moved Item To LOG URL HERR ",
},


NetDupWebHook            = {
    -- somone tries to use dev tools to cheat
    Active = true,
    color =16711680,
    webhook ="",
    Language = {
        title = "Possible Cheater Detected",
        descriptionstart = "Invalid NUI Callback performed by...\n **Playername** `",
        descriptionend = "`\n"
    }
},
	
}