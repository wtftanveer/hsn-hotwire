# UNMAINTAINED | NOT SUPPORTED

# hsn-hotwire
Basic hotwiring script for breaking into cars you do not own.

# exports
exports['hsn-hotwire']:AddKeys(plate)

# important
You will need to add something like the following in any scripts that spawn your own car:

> local plate = GetVehicleNumberPlateText(vehicle)

> local plate = GetVehicleNumberPlateText(veh, vehicle)

# config
Out of the box this supports luke_textui or cd_drawtextui. *(see below)*

Set which one in the config.lua:

Config.TextUI = 'cd_drawtextui'

or

Config.TextUI = 'luke_textui'

Then in client/client.lua comment/uncomment the following lines based on what you set in your config.lua

* 40 for (luke_textui) 

* 41 for (cd_drawtextui) 

* 43 for (luke_textui) 

* 44 for (cd_drawtextui)

# Requirements
* Mythic_Notify [Link](https://github.com/JayMontana36/mythic_notify)
* rprogress [Link](https://github.com/Mobius1/rprogress)
* ESX Legacy [Link](https://github.com/thelindat/es_extended)
* luke_textui [Link](https://forum.cfx.re/t/release-standalone-free-text-ui/3987367) **or** cd_drawtextui [Link](https://forum.cfx.re/t/free-release-draw-text-ui/1885313)

# Credits:
[hsnnnnn](https://github.com/hsnnnnn/) for original script.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/P5P57KRR9)
