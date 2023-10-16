
Config = {}

Config.defaultlang = "en" -- Default language ("en" English, "es" Español)

Config.SearchTimeMin = 5000 -- Minimum time, in milliseconds (1000 milliseconds = 1 second), taken to search a crawfish hole.
Config.SearchTimeMax = 10000 -- Maximum time, in milliseconds (1000 milliseconds = 1 second), taken to search a crawfish hole.
Config.SearchDelay = 600 -- Time, in seconds, before a crawfish hole can be search again.
Config.SearchRewardCount = 1 -- How many crawfish players can find per hole; Set this to a table like so {min,max} for random reward count per search; eg {0,3} will mean a random reward count between 0 and 3.

Config.CrawfishItemName = "animal_crawfish" -- The item name of a Crawfish; given to player on successful search (MUST be registered in your items database!).
Config.CrawfishItemLabel = _U("item_crawfish") -- The display name of a Crawfish. _U("item_crawfish") will pull the name from your language file, or you can just put a name here yourself.

Config.CrawfishCustomUseFunction = false -- Set true if you already have a script which handles the usage of an item with the same name as Config.CrawfishItemName.

-- The following settings are only used if Config.CrawfishCustomUseFunction is not set to true
Config.CrawfishGivenItemName = "provision_meat_crustacean" -- The item name of what is rewarded when using a Crawfish from inventory (MUST be registered in your items database!).
Config.CrawfishGivenItemLabel = _U("item_harvest") -- The display name of Config.CrawfishGivenItemName. _U("item_harvest") will pull the name from your language file, or you can just put a name here yourself.
Config.CrawfishGivenItemAmount = 1 -- How many items (Config.CrawfishGivenItemName) players can obtain when using a Crawfish from inventory; Set this to a table like so {min,max} for random item count when used; eg {1,3} will mean a random item count between 1 and 3.

Config.CrawfishHoles = { -- vector3(x,y,z)
	-- Crawdad Willies
	vector3(2021.29150390625, -1789.32958984375, 40.51888656616211),
	vector3(2027.25390625, -1722.359619140625, 40.6132583618164),
	vector3(2042.18701171875, -1885.94384765625, 40.39377975463867),
	vector3(2045.3292236328125, -1785.771240234375, 40.67805480957031),
	vector3(2058.18505859375, -1866.734619140625, 40.50119018554687),
	vector3(2087.13134765625, -1859.825439453125, 40.5162353515625),
	-- Lagras/Lakay
	vector3(2176.2734375, -693.794677734375, 40.6646499633789),
	vector3(2216.02978515625, -679.2449951171875, 40.62735748291015),
	vector3(2253.82666015625, -549.8944091796875, 40.5958137512207),
	vector3(2258.76611328125, -720.3011474609375, 40.47812271118164),
	vector3(2301.9091796875, -515.6649169921875, 40.82343673706055),
	vector3(2339.40478515625, -544.3302001953125, 40.8292007446289)
}
