# vorp_radius

Dynamically manage the player radius for Onesync RedM

(config on server.lua)
- local maxCulling = 350.0 -- Normal radius
- local minCulling = 100.0 -- Minimum Radius
- local stepCulling = 80.0 -- When there are people, the radius is 80


Change line '29' to define the number of players in the area where the script acts  -> "if nbPlayerAround >= 28 then"

# How to install (Remember to download the lastest releases)
- Download files
- Copy and paste vorp_radius folder to resources/
- Add ensure vorp_radius to your server.cfg file
