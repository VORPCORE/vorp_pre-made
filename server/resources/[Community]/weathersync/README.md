# FiveM/RedM weather and time sync

# Features

- Syncs time and weather for all players

- Configurable weather pattern

- Weather is queued so players can get a forecast of upcoming weather

- Different weather for different regions

- Adjustable timescale

- Players can temporarily disable sync and set local time/weather

- TxAdmin Restart Integration
  - Easily Toggle On/Off
  - Customize at what times the weather will change leading up to the restart
  - Set desired Weather changes leading up to Server Restart
  - Customize weather transition time
  - Added Fallback if Restart is cancelled for any reason
    - Configurable fallback weather

- "Winter-Mode" allows for changing weather patterns into snow variants
  - Easily Toggle On/Off
  - Combine with Permanent Snow config option for 'true' winter
  - Changes output Forecast as well for exports and command usage

# Examples

| Forecast and admin UI | Region-specific weather | Adjustable timescale | Winter-Mode |
|---|---|---|---|
| [![Forecast and admin UI](https://i.imgur.com/Scn0z0Em.jpg)](https://imgur.com/Scn0z0E) | [![Region-specific weather](https://i.imgur.com/Loif9SMm.jpg)](https://imgur.com/Loif9SM) | [![Adjustable timescale](https://i.imgur.com/WkqHAs4m.jpg)](https://imgur.com/WkqHAs4) | [![Winter-Mode](https://i.imgur.com/3qE4sxs.png)](https://imgur.com/cc957Ax) |

# Installation

1. Create a `weathersync` folder within your resources directory, for example, `resources/[local]/weathersync`.

2. Copy the files from this repository into the `weathersync` folder.

3. Add the following to your `server.cfg`:

```
exec resources/[local]/weathersync/permissions.cfg
start weathersync
```

# Commands

| Command        | Description                                               |
|----------------|-----------------------------------------------------------|
| `/forecast`    | Displays a forecast of upcoming weather.                  |
| `/mytime`      | Set local time (if sync is off).                          |
| `/myweather`   | Set local weather (if sync is off).                       |
| `/syncdelay`   | Set how often the server syncs with clients.              |
| `/time`        | Set the server time.                                      |
| `/timescale`   | Set the ratio of in-game seconds to real-time seconds.    |
| `/weather`     | Set the server weather.                                   |
| `/weathersync` | Toggle time/weather sync on/off.                          |
| `/weatherui`   | Opens the admin UI for changing the time/weather/wind.    |
| `/wind`        | Set the wind direction and base speed.                    |

# Configuration

| Variable                         | Description                                                    | Example                                   |
|----------------------------------|----------------------------------------------------------------|-------------------------------------------|
| `Config.time`                    | Default time when the resource starts.                         | `DHMSToTime(0, 6, 0, 0)` (Sun 06:00:00)   |
| `Config.timescale`               | Default timescale when the resource starts                     | `30` (30 in-game secs per real sec)       |
| `Config.realTimeOffset`          | Offset of the real server time in seconds.                     | `0`                                       |
| `Config.timeIsFrozen`            | Whether time is frozen when the resource starts.               | `false`                                   |
| `Config.weather`                 | Default weather when the resource starts.                      | `"sunny"`                                 |
| `Config.weatherInterval`         | How often the weather changes.                                 | `DHMSToTime(0, 1, 0, 0)` (1 in-game hour) |
| `Config.weatherIsFrozen`         | Whether weather is frozen when the resource starts.            | `false`                                   |
| `Config.permanentSnow`           | Whether to permanently add snow on the ground.                 | `false`                                   |
| `Config.toggleWinter`            | Whether to convert weather to winter variants                  | `false`                                   |
| `Config.dynamicSnow`             | Whether to dynamically add snow on the ground in cold regions  | `true`                                    |
| `Config.maxForecast`             | Number of weather intervals to queue up.                       | `23` (24-hour forecast)                   |
| `Config.windDirection`           | Default wind direction when the resource starts.               | `0.0` (North)                             |
| `Config.windSpeed`               | Default base wind speed when the resource starts.              | `0.0`                                     |
| `Config.windShearDirection`      | Degrees by which wind direction changes at higher altitudes.   | `45`                                      |
| `Config.windShearSpeed`          | Amount by which base wind speed increases at higher altitudes. | `2.0`                                     |
| `Config.windShearInterval`       | Interval in metres where wind direction/speed changes.         | `50.0`                                    |
| `Config.windIsFrozen`            | Whether wind direction is frozen.                              | `false`                                   |
| `Config.syncDelay`               | How often in ms to sync with clients.                          | `5000`                                    |
| `Config.ToggleTxAdmin`           | TxAdmin Integration. See [config.lua](config.lua) for sub-options   | `false`                              |
| `Config.ToggleWeatherTips`           | Toggles the weather alerts during TxAdmin Restarts.   | `false`                                        |
| `Config.TxpermanentSnow`           | Toggles permanent snow during TxAdmin Restart weather.   | `0` (0 is off, 1 is on)            |
| `Config.weatherTransition`           | Sets the weather transition time during TxAdmin Restart weather.   | `120.0` (**use decimal**)          |
| `Config.restartTimeoutWeather`           | Sets the fallback weather if TxAdmin restart is cancelled   | `sunny` See [config.lua](config.lua)  |
| `Config.FirstTimeToRestart`           | Sets the ammount of time remaining to trigger weather change   | `1800` (1800 seconds is 30 minutes)   |
| `Config.FirstAlert`           | Sets the custom alert message if enabled by ToggleWeatherTips. | `Weather Alert Goes Here` (any string of text)|
| `Config.Firstweather`           | Sets the weather type to use leading up to the restart  | `drizzle`    See [config.lua](config.lua)     |
| `Config.weatherPattern`          | A table describing the the weather pattern.                    | See [config.lua](config.lua)              |
| `Config.disableSnowOnCayoPerico` | Disables permanent and dynamic snow while on Cayo Perico.      | `false`               |

# Exports

## Server-side

### getTime
Get the current server time.

#### Usage
```lua
exports.weathersync:getTime()
```

#### Return value
A table with the current day, hour, minute and second:

```lua
{
	day = 0,
	hour = 6,
	minute = 0,
	second = 0
}
```
### setTime
Set the current time.

#### Usage
```lua
exports.weathersync:setTime(day, hour, minute, second, transition, freeze)
```

### resetTime
Reset the time to the default configured time.

#### Usage
```lua
exports.weathersync:resetTime()
```

### setTimescale
Set the ratio of in-game seconds to real seconds.

#### Usage
```lua
exports.weathersync:setTimescale(timescale)
```

### resetTimescale
Reset the timescale to the default configured value.

#### Usage
```lua
exports.weathersync:resetTimescale()
```

### getWeather
Get the current weather.

#### Usage
```lua
exports.weathersync:getWeather()
```

#### Return value
The name of the current weather type.

### setWeather
Set the current weather.

#### Usage
```lua
exports.weathersync:setWeather()
```

### resetWeather
Reset the weather to the default configured weather type.

#### Usage
```lua
exports.weathersync:resetWeather()
```

### setWeatherPattern
Set the weather pattern.

#### Usage
```lua
exports.weathersync:setWeatherPattern(pattern)
```

### resetWeatherPattern
Reset the weather pattern to the default configured pattern.

#### Usage
```lua
exports.weathersync:resetWeatherPattern()
```

### getWind
Get the current wind direction and base speed.

#### Usage
```lua
exports.weathersync:getWind()
```

#### Return value
A table containing the wind direction and base speed:

```lua
{
	direction = 180.0,
	speed = 0.0
}
```

### setWind
Set the current wind direction and base speed.

#### Usage
```lua
exports.weathersync:setWind(direction, speed)
```

### resetWind
Reset the wind direction and speed to the default configured values.

#### Usage
```lua
exports.weathersync:resetWind()
```

### setSyncDelay
Set the current synchronization interval.

#### Usage
```lua
exports.weathersync:setSyncDelay(delay)
```

### resetSyncDelay
Reset the sync delay to the default configured value.

#### Usage
```lua
exports.weathersync:resetSyncDelay()
```

### getForecast
Get the current weather forecast.

#### Usage
```lua
exports.weathersync:getForecast()
```

#### Return value
A table containing the weather forecast:

```lua
{
	{
		day = 0,
		hour = 6,
		minute = 0,
		second = 0,
		weather = "sunny",
		wind = 0.0
	},
	{
		day = 0,
		hour = 7,
		minute = 0,
		second = 0,
		weather = "clouds",
		wind = 10.0
	},
	...
}
```

## Client-side

### isSnowOnGround
Check if there is snow on the ground.

#### Usage
```lua
exports.weathersync:isSnowOnGround()
```

#### Return value
true if there is snow on the ground, false if there is not.

### setMyWeather
Disable weather and time sync and set a local weather type for this client.

#### Usage
```lua
exports.weathersync:setMyWeather(weather, transition, permanentSnow)
```

### setMyTime
Disable weather and time sync and set a local time for this client.

#### Usage
```lua
exports.weathersync:setMyTime(hour, minute, second, transition, freeze)
```

### setSyncEnabled
Enable or disable weather and time sync for this client.

#### Usage
```lua
exports.weathersync:setSyncEnabled(toggle)
```

### toggleSync
Toggle weather and time sync on/off for this client.

#### Usage
```lua
exports.weathersync:toggleSync()
```
