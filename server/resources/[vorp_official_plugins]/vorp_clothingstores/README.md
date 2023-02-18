# VORP-ClothingStore Lua

Clothing Store for VORP Core

Refactored from C# to Lua with improvements

## Requirements
- [VORP-Core](https://github.com/VORPCORE/vorp-core-lua)
- [VORP-Inputs](https://github.com/VORPCORE/vorp_inputs-lua)
- [VORP-MenuAPI](https://github.com/outsider31000/menuapi)

~~- [VORP-Character](https://github.com/VORPCORE/VORP-Character/releases)~~  Until a stable new release is pushed, use VORP characters from the prebuild

## How to install
* disable clothing stores C# if you are using replace with this one.
* Download the lastest version of VORP ClothingStore using ```Code > DownloadZip```
* Copy and paste ```vorp_clothingstore``` folder to ```resources/vorp_clothingstore```
* Add ```ensure vorp_clothingstore``` to your ```server.cfg``` file
* To change the language go to ```Config.lua``` and change the default language
* If language does not exist in ```vorp_clothingstore/languages```, please translate and PR :)
* Now you are ready!

### Optimizations

Client and Server side threads are completely idle until called upon. The previous version was calling everything together at once leading to substantial resource usage. You can see the difference down below.

<p align="left">
  <img src="https://i.ibb.co/vBkPVmW/comparison-vorpclothingstore.png" width="650">
</p>

## Credits

- [@VORPCORE](https://github.com/VORPCORE)
- [@UnderworldServers](https://github.com/UnderworldServers) Core rework into Lua

- [@Blue](https://github.com/kamelzarandah) - [@Outsider](https://github.com/outsider31000) - [@Artzalez](https://github.com/Artzalez) - [@rubi216](https://github.com/rubi216)  Original Authors

## License

[Apache](https://choosealicense.com/licenses/apache-2.0/)
