------------------------------------------------------------------------------
--- MISSION SCRIPTING
---
--- available in _G:
---  - all classes below
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--- UTILITY CLASSES
------------------------------------------------------------------------------

--- @class vec2
--- @field x number distance north-south
--- @field y number distance east-west

--- @class vec3
--- @field x number distance north-south
--- @field y number distance above height 0
--- @field z number distance east-west

--- @class Position3
--- @field p vec3 position
--- @field x vec3 forward direction vector
--- @field y vec3 upward direction vector
--- @field z vec3 right direction vector

--- @class Box3
--- @field min vec3
--- @field max vec3

--- @class TriggerZone
--- @field point vec3
--- @field radius number

--- @class MGRS
--- @field UTMZone string
--- @field MGRSDigraph string
--- @field Easting number
--- @field Northing number

------------------------------------------------------------------------------
--- SINGLETONS
------------------------------------------------------------------------------

--- @class env
--- @description env contains basic logging functions useful for debugging scripting commands. The input text is automatically added to dcs.log in your saved games folder
--- @field info fun(log:string, showMessageBox:boolean) Prints the passed string to the dcs.log with a prefix of 'info'. The optional variable defines whether or not a message box will pop up when the logging occurs
--- @field warning fun(log:string, showMessageBox:boolean) Prints the passed string to the dcs.log with a prefix of 'warning'. The optional variable defines whether or not a message box will pop up when the logging occurs.
--- @field error fun(log:string, showMessageBox:boolean) Prints the passed string to the dcs.log with a prefix of 'error'. The optional variable defines whether or not a message box will pop up when the logging occurs.
--- @field setErrorMessageBoxEnabled fun(toggle:boolean) Sets the value for whether or not an error message box will be displayed if a lua error occurs. By default the error message box will appear.
--- @field getValueDictByKey fun(value:string):string Returns a string associated with the passed dictionary key value. If the key is not found within the miz the function will return the string that was passed.
--- @field mission env.mission The mission file is a lua table present within a .miz file that is accessible to the scripting engine via the table env.mission. This table is almost the entirety of the contents of a given mission.
--- @field warehouses env.warehouses The warehouses file is a lua table present within a .miz file that is accessible to the scripting engine.

--- @class timer
--- @descriptionThe timer singleton has two important uses. 1. Return the mission time. 2. To schedule functions.
--- @field getTime fun():number Returns the model time in seconds to three decimal places since the mission has started. Time pauses with the game.
--- @field getAbsTime fun():number Returns the game world time in seconds since the mission started. If the value is above 86400, it represents the next day after the mission started.
--- @field getTime0 fun():number Returns the mission start time in seconds. Useful for calculating elapsed time with timer.getAbsTime().
--- @field scheduleFunction fun(functionToCall:function, functionArgs:table, modelTime:number):number Schedules a function to run at a specified future model time. Returns a functionId.
--- @field removeFunction fun(functionId:number) Removes a scheduled function by its functionId, preventing it from executing.
--- @field setFunctionTime fun(functionId:number, modelTime:number) Reschedules an already scheduled function to run at a different model time.

--- @class land
--- @description The land singleton contains functions used to get information about the terrain geometry of a given map. Functions include getting data on the type and height of terrain at a specific points and raytracing functions.
--- @field getHeight fun(point:vec2):number Returns the distance from sea level (y-axis) at a given vec2 point.
--- @field getSurfaceHeightWithSeabed fun(point:vec2):number, number Returns both the surface height and the seabed depth at a point.
--- @field getSurfaceType fun(point:vec2):number Returns an enumerator indicating the surface type at a given vec2 point. (returns land.SurfaceType)
--- @field isVisible fun(origin:vec3, destination:vec3):boolean Determines if a line from origin to destination intersects terrain, used for line of sight.
--- @field getIP fun(origin:vec3, direction:vec3, distance:number):vec3 Returns an intercept point where a ray from origin in the specified direction for a given distance intersects with terrain.
--- @field profile fun(start:vec3, end:vec3):table Returns a profile of the land between two points as a table of vec3 vectors.
--- @field getClosestPointOnRoads fun(roadType:string, xCoord:number, yCoord:number):number, number Returns the closest road coordinate (x, y) from a given point based on specified road type ('roads' or 'railroads').
--- @field findPathOnRoads fun(roadType:string, xCoord:number, yCoord:number, destX:number, destY:number):table Returns a path as a table of vec2 points from a start to a destination along specified road type.

--- @class atmosphere
--- @description atmosphere is a singleton whose functions return atmospheric data about the mission. Currently limited only to wind data. 
--- @field getWind fun(point:vec3):vec3 Returns a velocity vector of the wind at a specified 3D point.
--- @field getWindWithTurbulence fun(point:vec3):vec3 Returns a velocity vector of the wind at a specified 3D point, including effects of turbulence.
--- @field getTemperatureAndPressure fun(point:vec3):number, number Returns the temperature (Kelvins) and pressure (Pascals) at a given 3D point.

--- @class world
--- @description The world singleton contains functions centered around two different but extremely useful functions. 1. Events and event handlers are all governed within world. 2. A number of functions to get information about the game world.
--- @field addEventHandler fun(handler:EventHandler) Adds a function as an event handler that executes when a simulator event occurs.
--- @field removeEventHandler fun(handler:EventHandler) Removes the specified event handler from handling events.
--- @field getPlayer fun():Unit Returns a table representing the single unit object in the game set as "Player".
--- @field getAirbases fun(coalitionId:number|nil):table Returns a table of airbase objects for a specified coalition or all airbases if no coalition is specified. (coalition.side)
--- @field searchObjects fun(category:table|number, searchVolume:number, handler:function, data:any):table Searches a defined volume for specified objects and can execute a function on each found object. (Object.Category, world.VolumeType)
--- @field getMarkPanels fun():table Returns a table of mark panels and shapes drawn within the mission.
--- @field removeJunk fun(searchVolume:table):number Searches a defined area to remove craters, wreckage, and debris within the volume, excluding scenery objects. (world.VolumeType)

--- @class coalition
--- @description The coalition singleton contains functions that gets information on the all of the units within the mission. It also has two of the most powerful functions that are capable of spawning groups and static objects into the mission. 
--- @field addGroup fun(countryId:number, groupCategory:number, groupData:table):Group Adds a group of the specified category for the specified country using provided group data. (country.id, Group.Category)
--- @field addStaticObject fun(countryId:number, groupData:table):StaticObject Dynamically spawns a static object for the specified country based on the provided group data. (country.id)
--- @field getGroups fun(coalitionId:number, groupCategory:number|nil):table Returns a table of group objects within the specified coalition and optionally filtered by group category. (coalition.side)
--- @field getStaticObjects fun(coalitionId:number):table Returns a table of static objects within the specified coalition. (coalition.side)
--- @field getAirbases fun(coalitionId:number|nil):table Returns a table of airbase objects for the specified coalition or all airbases if no coalition is specified. (coalition.side)
--- @field getPlayers fun(coalitionId:number):table Returns a table of unit objects currently occupied by players within the specified coalition. (coalition.side)
--- @field getServiceProviders fun(coalitionId:number, service:number):table Returns a table of unit objects that provide a specified service (ATC, AWACS, TANKER, FAC) within the specified coalition. (coalition.side, coalition.service)
--- @field addRefPoints fun(coalitionId:number, refPoint:table) Adds a reference point for the specified coalition, used by JTACs. (coalition.side)
--- @field getRefPoints fun(coalitionId:number):table Returns a table of reference points defined for the specified coalition, used by JTACs. (coalition.side)
--- @field getMainRefPoint fun(coalitionId:number):vec3 Returns the position of the main reference point ("bullseye") for the specified coalition. (coalition.side)
--- @field getCountryCoalition fun(countryId:number):number Returns the coalition ID that a specified country belongs to. (country.id)

--- @class trigger
--- @description The trigger singleton contains a number of functions that mimic actions and conditions found within the mission editor triggers.
--- @field action triggerAction trigger actions
--- @field misc triggerMisc some misc getters

--- @class triggerAction
--- @description trigger actions
--- @field ctfColorTag fun(unitName:string, smokeColor:number) Creates a smoke plume behind a specified aircraft. When passed 0 for smoke type the plume will be disabled. When triggering the on the same unit with a different color the plume will simply change color. (trigger.smokeColor)
--- @field setUserFlag fun(flag:string, value:number|boolean) Sets the value of a user flag.
--- @field explosion fun(position:vec3, power:number) Creates an explosion at a specified position with a specified power.
--- @field smoke fun(position:vec3, color:number) Creates a smoke plume at a specified position with a specified color. (trigger.smokeColor)
--- @field effectSmokeBig fun(position:vec3, preset:number, density:number, name:string) Creates a large smoke effect at a specified position with a specified preset (1-4=smoke/fire, 5-7=smoke), density (0-1), and name. (trigger.effectSmokePreset)
--- @field effectSmokeStop fun(name:string) Stops a smoke effect with a specified name.
--- @field illuminationBomb fun(position:vec3, power:number) Creates an illumination bomb at a specified position with a specified power. (1-1000000)
--- @field signalFlare fun(position:vec3, color:number, azimuth:number) Creates a signal flare at a specified position with a specified color and azimuth. (trigger.flareColor)
--- @field radioTransmission fun(filename:string, point:vec3, modulation:enum, loop:boolean, frequency:number, power:number, name:string) Transmits an audio file from a specific point on a given frequency. (radio.modulation)
--- @field stopRadioTransmission fun(name:string) Stops the named radio transmission.
--- @field setUnitInternalCargo fun(unitName:string, mass:number) Sets the internal cargo mass for a specified unit.
--- @field outSound fun(soundfile:string) Plays a sound file to all players.
--- @field outSoundForCoalition fun(coalition:number, soundfile:string) Plays a sound file to all players in the specified coalition.
--- @field outSoundForCountry fun(country:number, soundfile:string) Plays a sound file to all players in the specified country.
--- @field outSoundForGroup fun(groupId:number, soundfile:string) Plays a sound file to all players in the specified group.
--- @field outSoundForUnit fun(unitId:number, soundfile:string) Plays a sound file to all players in the specified unit.
--- @field outText fun(text:string, displayTime:number, clearview:boolean) Displays text to all players for the specified time.
--- @field outTextForCoalition fun(coalition:number, text:string, displayTime:number, clearview:boolean) Displays text to players in a specified coalition for a set time.
--- @field outTextForCountry fun(country:number, text:string, displayTime:number, clearview:boolean) Displays text to players in a specified country for a set time.
--- @field outTextForGroup fun(groupId:number, text:string, displayTime:number, clearview:boolean) Displays text to players in a specified group for a set time.
--- @field outTextForUnit fun(unitId:number, text:string, displayTime:number, clearview:boolean) Displays text to players in a specified unit for a set time.
--- @field addOtherCommand fun(name:string, userFlagName:string, userFlagValue:number) Adds a command to the "F10 Other" radio menu to set flags within the mission.
--- @field removeOtherCommand fun(name:string) Removes the specified command from the "F10 Other" radio menu.
--- @field addOtherCommandForCoalition fun(coalition:number, name:string, userFlagName:string, userFlagValue:string) Adds a coalition-specific command to the "F10 Other" menu.
--- @field removeOtherCommandForCoalition fun(coalitionId:number, name:string) Removes a coalition-specific command from the "F10 Other" menu.
--- @field addOtherCommandForGroup fun(groupId:number, name:string, userFlagName:string, userFlagValue:string) Adds a group-specific command to the "F10 Other" menu.
--- @field removeOtherCommandForGroup fun(groupId:number, name:string) Removes a group-specific command from the "F10 Other" menu.
--- @field markToAll fun(id:number, text:string, point:vec3, readOnly:boolean, message:string) Adds a mark point to all on the F10 map.
--- @field markToCoalition fun(id:number, text:string, point:vec3, coalitionId:number, readOnly:boolean, message:string) Adds a mark point to a coalition on the F10 map.
--- @field markToGroup fun(id:number, text:string, point:vec3, groupId:number, readOnly:boolean, message:string) Adds a mark point to a group on the F10 map.
--- @field removeMark fun(id:number) Removes a mark from the F10 map.
--- @field markupToAll fun(shapeId:number, coalition:number, id:number, point1:vec3, param:..., color:table, fillColor:table, lineType:number, readOnly:boolean, message:string) Creates a defined shape on the F10 map.
--- @field lineToAll fun(coalition:number, id:number, startPoint:vec3, endPoint:vec3, color:table, lineType:number, readOnly:boolean, message:string) Creates a line on the F10 map. 0=no line, 1=solid, 2=dashed, 3=dotted, 4=dot dash, 5=long dash, 6=two dash--- @field circleToAll fun(coalition:number, id:number, center:vec3, radius:number, color:table, fillColor:table, lineType:number, readOnly:boolean, message:string) Creates a circle on the F10 map.
--- @field rectToAll fun(coalition:number, id:number, startPoint:vec3, endPoint:vec3, color:table, fillColor:table, lineType:number, readOnly:boolean, message:string) Creates a rectangle on the F10 map. 0=no line, 1=solid, 2=dashed, 3=dotted, 4=dot dash, 5=long dash, 6=two dash
--- @field quadToAll fun(coalition:number, id:number, point1:vec3, point2:vec3, point3:vec3, point4:vec3, color:table, fillColor:table, lineType:number, readOnly:boolean, message:string) Creates a quadrilateral on the F10 map. 0=no line, 1=solid, 2=dashed, 3=dotted, 4=dot dash, 5=long dash, 6=two dash
--- @field arrowToAll fun(coalition:number, id:number, startPoint:vec3, endPoint:vec3, color:table, fillColor:table, lineType:number, readOnly:boolean, message:string) Creates an arrow on the F10 map. 0=no line, 1=solid, 2=dashed, 3=dotted, 4=dot dash, 5=long dash, 6=two dash
--- @field textToAll fun(coalition:number, id:number, point:vec3, color:table, fillColor:table, fontSize:number, readOnly:boolean, text:string) Creates text on the F10 map.
--- @field setMarkupRadius fun(id:number, radius:number) Updates the radius of an existing circular mark.
--- @field setMarkupText fun(id:number, text:string) Updates the text of an existing mark.
--- @field setMarkupFontSize fun(id:number, fontSize:number) Updates the font size of text on an existing mark.
--- @field setMarkupColor fun(id:number, color:table) Updates the color of an existing mark.
--- @field setMarkupColorFill fun(id:number, colorFill:table) Updates the fill color of an existing mark.
--- @field setMarkupTypeLine fun(id:number, typeLine:number) Updates the line type of an existing mark. 0=no line, 1=solid, 2=dashed, 3=dotted, 4=dot dash, 5=long dash, 6=two dash
--- @field setMarkupPositionEnd fun(id:number, vec3:table) Updates the endpoint of an existing line or shape mark.
--- @field setMarkupPositionStart fun(id:number, vec3:table) Updates the start point of an existing line or shape mark.
--- @field setAITask fun(Group:Group, taskIndex:number) Sets the specified task index as the only active task for the group.
--- @field pushAITask fun(Group:Group, taskIndex:number) Pushes the specified task index to the front of the tasking queue for the group.
--- @field activateGroup fun(Group:Group) Activates the specified group if set up for "late activation."
--- @field deactivateGroup fun(Group:Group) Deactivates the specified group.
--- @field setGroupAIOn fun(Group:Group) Turns the group's AI on, only for ground and ship groups.
--- @field setGroupAIOff fun(Group:Group) Turns the group's AI off, only for ground and ship groups.
--- @field groupStopMoving fun(Group:Group) Orders the specified ground group to stop moving.
--- @field groupContinueMoving fun(Group:Group) Orders the specified ground group to resume moving.

--- @class triggerMisc
--- @description trigger misc
--- @field getUserFlag fun(flag:string):number Returns the value of a user flag.
--- @field getZone fun(zoneName:string):TriggerZone Returns a trigger zone table of a given name

--- @class coord
--- @description The coord singleton contains functions used to convert coordinates between the game's XYZ, Longitude and Latitude, and the MGRS coordinate systems.
--- @field LLtoLO fun(latitude:number, longitude:number, altitude:number):vec3 Converts latitude, longitude, and altitude to game world coordinates (vec3).
--- @field LOtoLL fun(point:vec3):number, number, number Converts game world coordinates (vec3) to latitude, longitude, and altitude.
--- @field LLtoMGRS fun(latitude:number, longitude:number):MGRS Returns an MGRS table from the latitude and longitude coordinates provided. Note that in order to get the MGRS coordinate from a vec3 you must first use coord.LOtoLL on it. 
--- @field MGRStoLL fun(mgrs:MGRS):number, number, number Converts an MGRS table to latitude, longitude, and altitude.

--- @class missionCommands
--- @description The missionCommands singleton allows for greater access and flexibility of use for the F10 Other radio menu. Added commands can contain sub-menus and directly call lua functions.
--- @field addCommand fun(name:string, path:table|nil, functionToRun:function, anyArgument:any):table Adds a command to the "F10 Other" menu.
--- @field addSubMenu fun(name:string, path:table|nil):table Creates a submenu in the F10 radio menu.
--- @field removeItem fun(path:table|nil) Removes an item or submenu from the F10 radio menu.
--- @field addCommandForCoalition fun(coalitionSide:number, name:string, path:table|nil, functionToRun:function, anyArgument:any):table Adds a coalition-specific command to the F10 menu.
--- @field addSubMenuForCoalition fun(coalitionSide:number, name:string, path:table|nil):table Creates a coalition-specific submenu in the F10 menu.
--- @field removeItemForCoalition fun(coalitionSide:number, path:table|nil) Removes a coalition-specific item or submenu from the F10 menu.
--- @field addCommandForGroup fun(groupId:number, name:string, path:table|nil, functionToRun:function, anyArgument:any):table Adds a group-specific command to the F10 menu.
--- @field addSubMenuForGroup fun(groupId:number, name:string, path:table|nil):table Creates a group-specific submenu in the F10 menu.
--- @field removeItemForGroup fun(groupId:number, path:table|nil) Removes a group-specific item or submenu from the F10 menu.

--- @class VoiceChat
--- @description The voice chat singleton is a means of creating customized voice chat rooms for players to interact with each other in multiplayer.
--- @field createRoom fun(roomName:string, side:number, roomType:number) Creates a VoiceChat room for multiplayer interaction. (VoiceChat.Side, VoiceChat.RoomType)

--- @class net
--- @description The net singleton are a number of functions from the network API that work in the mission scripting environment. Notably for mission scripting purposes there is now a way to send chat, check if players are in Combined Arms slots, kick people from the server, and move players to certain slots. 
--- @field send_chat fun(message:string, all:boolean) Sends a chat message to all players if true, or team otherwise.
--- @field send_chat_to fun(message:string, playerId:number, fromId:number|nil) Sends a chat message to a specific player, optionally appearing from another player.
--- @field recv_chat fun() Functionality unknown.
--- @field load_mission fun(fileName:string):boolean Loads the specified mission.
--- @field load_next_mission fun():boolean Load the next mission from the server mission list. Returns false if at the end of list.
--- @field get_player_list fun():table Returns a list of players currently connected to the server.
--- @field get_my_player_id fun():number Returns the playerID of the local player; returns 1 for server.
--- @field get_server_id fun():number Returns the playerID of the server; currently always 1.
--- @field get_player_info fun(playerID:number, attribute:string|nil):table Returns player attributes; specific attribute if provided.
--- @field kick fun(playerId:number, message:string):boolean Kicks a player from the server with an optional message.
--- @field get_stat fun(playerID:number, statID:number):number Returns a specific statistic from a given player.
--- @field get_name fun(playerID:number):string Returns the name of a given player.
--- @field get_slot fun(playerID:number):number, number Returns the sideId and slotId of a given player.
--- @field set_slot fun() Functionality unknown.
--- @field force_player_slot fun(playerID:number, sideId:number, slotId:number):boolean Forces a player into a specified slot.
--- @field lua2json fun(lua:any):table Converts a Lua value to a JSON string.
--- @field json2lua fun(json:string):table Converts a JSON string to a Lua value.
--- @field dostring_in fun(environment:string, code:string):string Executes a Lua string in a specified Lua environment within the game. (config: main.cfg/autoexec.cfg state, mission: current mission, export: export.lua)
--- @field log fun(message:string) Writes an "INFO" entry to the DCS log file.
--- @field trace fun() Functionality unknown.

------------------------------------------------------------------------------
--- MISSION
------------------------------------------------------------------------------

--- @class env.mission
--- @description helper class for env.mission table
--- @field coalition table Contains all coalition specific data including bullseye, nav_points, and all units.
--- @field coalitions table Contains a list of country ids that belong to a given coalition.
--- @field currentKey number Value used by the editor to know what index the dictkey and reskeys are on.
--- @field date table The date the mission takes place at with Year, Month, and Day entries.
--- @field descriptionText string Mission briefing defined under the "Situation" page on the briefing panel.
--- @field descriptionBlueTask string Blue coalition task defined on the briefing panel.
--- @field descriptionNeutralsTask string Neutral coalition task defined on the briefing panel.
--- @field descriptionRedTask string Red coalition task defined on the briefing panel.
--- @field drawings table Table containing information on any drawing placed in the editor.
--- @field failures table Only valid for single player missions. Lists failure parameters for whichever aircraft is set to player. If none are set to player it still populates.
--- @field forcedOptions table Options that are forced by the mission and their corresponding settings.
--- @field groundControl table Data on the number of Combined Arms slots and their respective coalitions is found here.
--- @field map table Last position of the map view the user was looking at when the mission was saved.
--- @field maxDictId number Internal value used to keep track of what the next unit and group id to use is.
--- @field pictureFileNameN table Neutral coalition briefing images.
--- @field pictureFileNameB table Blue coalition briefing images.
--- @field pictureFileNameR table Red coalition briefing images.
--- @field requiredModules table Table of mod names whose units are present within the mission.
--- @field result table Conditions and actions defined by mission goals in the editor to decide if a mission is "won".
--- @field start_time number Time in seconds since midnight for the date set when the mission starts.
--- @field sortie string Name of the mission as defined in the briefing panel.
--- @field theatre string Name of the map the mission takes place on.
--- @field triggers env.mission.triggers Contains table of trigger zones.
--- @field trig env.mission.trig Table containing every single trigger (actions, conditions, events, flag, func).
--- @field trigrules missionTrigrule[] Another table containing data on triggers (actions, predicate, eventlist, rules).
--- @field version number Value used by the mission editor to know roughly which iteration of the editor the mission was saved in. Used for compatibility warning messages if you open a newer mission in an older editor.
--- @field weather table Table with weather data.

--- @class env.mission.triggers
--- @description contains table of trigger zones
--- @field zones missionTriggersZone[] Table of trigger zones indexed numerically.

--- @class missionTriggersZone
--- @description helper class for mission trigger zone
--- @field color table
--- @field heading number
--- @field hidden boolean
--- @field name string
--- @field properties table
--- @field radius number
--- @field type number
--- @field x number
--- @field y number
--- @field zoneId number

--- @class env.mission.trig
--- @description contains triggers
--- @field actions table actions lua, alphanumeric indexed
--- @field conditions table conditions lua, alphanumeric indexed
--- @field custom table 
--- @field customStartup table
--- @field events table
--- @field flag table flags
--- @field func table condition/action lua functions, alphanumeric indexed
--- @field funcStartup table startup condition/action lua functions, alphanumeric indexed

--- @class missionTrigrule
--- @description helper class for mission trigrule
--- @field actions table action objects, alphanumeric indexed
--- @field comment string
--- @field eventlist string
--- @field predicate string trigger, triggerOnce, triggerContinious, triggerStart, triggerFront
--- @field rules table rule objects, alphanumeric indexed

------------------------------------------------------------------------------
--- WAREHOUSES
------------------------------------------------------------------------------

--- @class env.warehouses
--- @description helper class for env.warehouses table
--- @field airports warehousesAirport[] array of airports
--- @field warehouses warehousesWarehouse[] array of warehouses

--- @class warehousesAirport
--- @description helper class for mission airports
--- @field aircrafts table
--- @field coalition table
--- @field diesel table
--- @field gasoline table
--- @field jet_fuel table
--- @field methanol_mixture table
--- @field OperatingLevel_Air number
--- @field OperatingLevel_Eqp number
--- @field OperatingLevel_Fuel number
--- @field periodicity number
--- @field size number
--- @field speed number
--- @field suppliers table
--- @field unlimitedAircrafts boolean
--- @field unlimitedFuel boolean
--- @field unlimitedMunitions boolean
--- @field weapons table

--- @class warehousesWarehouse
--- @description helper class for mission warehouses
--- @todo

------------------------------------------------------------------------------
--- EVENT HANDLER
------------------------------------------------------------------------------

--- @class EventHandler
--- @description helper class for world.addEventHandler functions
--- @field onEvent fun(event:Event) Function to be executed when an event occurs.

--- @class Event
--- @description helper class for event handler parameter
--- @field id number Event ID (world.event
--- @field time number Time in seconds since the mission started
--- @field initiator Unit Unit that initiated the event
--- @field target Unit Unit that is the target of the event
--- @field place Unit|nil place
--- @field subPlace number|nil sub place (world.BirthPlace)
--- @field weapon Weapon|nil Weapon object that is the cause of the event

------------------------------------------------------------------------------
--- CLASSES
------------------------------------------------------------------------------

--- @class Object
--- @description Represents an object with body, unique name, category and type.
--- @field isExist fun(self:Object):boolean Returns true if the object currently exists in the mission.
--- @field destroy fun(self:Object) Destroys the object, physically removing it from the game world without creating an event.
--- @field getCategory fun(self:Object):Object.Category Returns the category of the object as an enumerator.
--- @field getTypeName fun(self:Object):string Returns the type name of the object.
--- @field getDesc fun(self:Object):Object.Desc Returns a description table of the object, with entries depending on the object's category.
--- @field hasAttribute fun(self:Object, attribute:string):boolean Returns true if the object has the specified attribute.
--- @field getName fun(self:Object):string Returns the name of the object as defined in the mission editor or by dynamic spawning.
--- @field getPoint fun(self:Object):vec3 Returns a vec3 table with x, y, and z coordinates of the object's position in 3D space.
--- @field getPosition fun(self:Object):Position3 Returns a Position3 table with the object's current position and orientation in 3D space.
--- @field getVelocity fun(self:Object):vec3 Returns a vec3 table of the object's velocity vectors.
--- @field inAir fun(self:Object):boolean Returns true if the object is in the air.
--- @field Category Object.Category
--- @field Desc Object.Desc

--- @class Object.Desc
--- @description All objects description tables contain these values. Every other value is dependent on the type of object it is; aircraft, building, ground unit, airbase, etc.
--- @field life number initial life level
--- @field box Box3 bounding box of collision geometry

------------------------------------------------------------------------------

--- @class SceneryObject:Object
--- @description Represents all objects placed on the map. Bridges, buildings, etc.
--- @field getLife fun(self:SceneryObject):number Returns the current "life" of the scenery object.
--- @field getDescByName fun(typename:string):Object.Desc Return a description table of the specified Object type. Object does not need to be in the mission in order to query its data.

------------------------------------------------------------------------------

--- @class CoalitionObject:Object
--- @description Represents all objects that may belong to a coalition: units, airbases, static objects, weapon.
--- @field getCoalition fun(self:CoalitionObject):number Returns an enumerator that defines the coalition that the object currently belongs to. 0=neutral, 1=red, 2=blue
--- @field getCountry fun(self:CoalitionObject):number Returns an enumerator that defines the country that the object currently belongs to.

------------------------------------------------------------------------------

--- @class Unit:CoalitionObject
--- @description Represents units: airplanes, helicopters, vehicles, ships and armed ground structures.
--- @field isActive fun(self:Unit):boolean Returns true if the unit is activated.
--- @field getPlayerName fun(self:Unit):string|nil Returns the player's name if controlled by a player, nil otherwise.
--- @field getID fun(self:Unit):number Returns the unique mission id of the unit.
--- @field getNumber fun(self:Unit):number Returns the unit's default index within its group.
--- @field getCategoryEx fun(self:Unit):Unit.Category Returns the category of the unit.
--- @field getObjectID fun(self:Unit):number Returns the runtime object ID of the unit.
--- @field getController fun(self:Unit):Controller Returns the controller of the unit.
--- @field getGroup fun(self:Unit):Group Returns the group the unit belongs to.
--- @field getCallsign fun(self:Unit):string Returns the callsign of the unit.
--- @field getLife fun(self:Unit):number Returns the current life of the unit.
--- @field getLife0 fun(self:Unit):number Returns the initial life value of the unit.
--- @field getFuel fun(self:Unit):number Returns the current fuel level as a percentage.
--- @field getAmmo fun(self:Unit):table Returns a table of ammunition details.
--- @field getSensors fun(self:Unit):table Returns a table of available sensors.
--- @field hasSensors fun(self:Unit, sensorType:enum, subCategory:enum):boolean Returns true if the unit has the specified sensors.
--- @field getRadar fun(self:Unit):boolean, Object Returns operational status of radar and the object it is tracking.
--- @field getDrawArgumentValue fun(self:Unit, arg:number):number Returns the value of an animation argument.
--- @field getNearestCargos fun(self:Unit):table|nil Returns a table of nearby cargos, nil if not a helicopter.
--- @field enableEmission fun(self:Unit, setting:boolean) Sets radar emissions on or off.
--- @field getDescentCapacity fun(self:Unit):number|nil Returns the descent capacity, nil if not applicable.
--- @field getByName fun(name:string):Unit Returns an instance of the calling class for the object of a specified name.
--- @field getDescByName fun(typename:string):Unit.Desc Return a description table of the specified Object type. Object does not need to be in the mission in order to query its data.

--- @class Unit.Desc:Object.Desc

------------------------------------------------------------------------------

--- @class Airbase:CoalitionObject
--- @description Represents airbases: airdromes, helipads and ships with flying decks or landing pads.
--- @field getCallsign fun(self:Airbase):string Returns the callsign of the airbase.
--- @field getUnit fun(self:Airbase, unitIndex:number):Unit|nil Returns the unit or static object associated with the airbase at the specified index.
--- @field getID fun(self:Airbase):number Returns the unique mission ID of the airbase.
--- @field getCategoryEx fun(self:Airbase):Airbase.Category Returns the category of the airbase.
--- @field getParking fun(self:Airbase, available:boolean):table Returns a table of parking data, optionally only available parking.
--- @field getRunways fun(self:Airbase):table Returns a table with runway information.
--- @field getTechObjectPos fun(self:Airbase, objectType:number|string):table Returns a table of vec3 positions for technical objects, typically only "Tower".
--- @field getRadioSilentMode fun(self:Airbase):boolean Returns whether the ATC is in radio silent mode.
--- @field setRadioSilentMode fun(self:Airbase, silent:boolean) Sets the ATC to radio silent mode.
--- @field autoCapture fun(self:Airbase, setting:boolean) Enables or disables the airbase auto capture mechanic.
--- @field autoCaptureIsOn fun(self:Airbase):boolean Returns the current setting of the auto capture mechanic.
--- @field setCoalition fun(self:Airbase, coalition:number) Sets the coalition of the airbase.
--- @field getWarehouse fun(self:Airbase):Warehouse Returns the warehouse associated with the airbase.
--- @field getByName fun(name:string):Airbase Returns an instance of the calling class for the object of a specified name.
--- @field getDescByName fun(typename:string):Airbase.Desc Return a description table of the specified Object type. Object does not need to be in the mission in order to query its data.

--- @class Airbase.Desc:Object.Desc
--- @description Airbase description table.
--- @field category Airbase.Category

------------------------------------------------------------------------------

--- @class Weapon:CoalitionObject
--- @description Represents a weapon object: shell, rocket, missile and bomb
--- @field getLauncher fun(self:Weapon):Unit|nil Returns the unit that launched the weapon.
--- @field getTarget fun(self:Weapon):Object|nil Returns the target object that the weapon is guiding to.
--- @field getCategoryEx fun(self:Weapon):Weapon.Category Returns an enumerator of the category for the specific object.

--- @class Weapon.Warhead
--- @description Warhead description table.
--- @field type Weapon.WarheadType
--- @field mass number|nil
--- @field caliber number|nil
--- @field explosiveMass number|nil for HE and AP(+HE) warheads only
--- @field shapedExplosiveMass number|nil for shaped explosive warheads only
--- @field shapedExplosiveArmorThickness number|nil for shaped explosive warheads only

--- @class Weapon.Desc:Object.Desc
--- @description Weapon description table.
--- @field category Weapon.Category
--- @field warhead.type Weapon.WarheadType
--- @field warhead.mass Mass

--- @class Weapon.DescMissile:Weapon.Desc
--- @description Missile description table.
--- @field guidance Weapon.GuidanceType
--- @field rangeMin number
--- @field rangeMaxAltMin number
--- @field rangeMaxAltMax number
--- @field altMin number
--- @field altMax number
--- @field Nmax number
--- @field fuseDist number

--- @class Weapon.DescRocket:Weapon.Desc
--- @description Rocket description table.
--- @field distMin number
--- @field distMax number

--- @class Weapon.DescBomb:Weapon.Desc
--- @description Bomb description table.
--- @field guidance Weapon.GuidanceType
--- @field altMin number
--- @field altMax number

------------------------------------------------------------------------------

--- @class StaticObject:CoalitionObject
--- @description Represents static objects added in the Mission Editor or via scripting commands.
--- @field getID fun(self:StaticObject):number Returns a number which defines the unique mission id of a given object.
--- @field getLife fun(self:StaticObject):number Returns the current life of a unit. Also referred to as hit points
--- @field getCargoDisplayName fun(self:StaticObject):string Returns a string of a cargo objects mass
--- @field getCargoWeight fun(self:StaticObject):number Returns the mass of a cargo object measured in kg.
--- @field getDrawArgumentValue fun(self:StaticObject, arg:number):number Returns the current value for an animation argument on the external model of the given object.
--- @field getByName fun(name:string):StaticObject Returns an instance of the calling class for the object of a specified name.
--- @field getDescByName fun(typename:string):Object.Desc Return a description table of the specified Object type. Object does not need to be in the mission in order to query its data.

------------------------------------------------------------------------------

--- @class Group
--- @description Represents a group of units.
--- @field isExist fun(self:Group):boolean Returns true if the group currently exists in the mission.
--- @field activate fun(self:Group) Activates the group.
--- @field destroy fun(self:Group) Destroys the group, physically removing it from the game world without creating an event.
--- @field getCategory fun(self:Group):Group.Category Returns the category of the group as an enumerator.
--- @field getCoalition fun(self:Group):number Returns an enumerator that defines the coalition that the group currently belongs to. 0=neutral, 1=red, 2=blue
--- @field getName fun(self:Group):string Returns the name of the group as defined in the mission editor or by dynamic spawning.
--- @field getID fun(self:Group):number Returns the unique mission id of the group.
--- @field getUnit fun(self:Group, unitIndex:number):Unit|nil Returns the unit at the specified index within the group.
--- @field getUnits fun(self:Group):table Returns a table of all units in the group.
--- @field getSize fun(self:Group):number Returns the current size of the group.
--- @field getInitialSize fun(self:Group):number Returns the initial size of the group.
--- @field getController fun(self:Group):Controller Returns the controller of the group.
--- @field enableEmission fun(self:Group, setting:boolean) Sets radar emissions on or off.
--- @field getByName fun(name:string):Group Returns an instance of the calling class for the object of a specified name.

------------------------------------------------------------------------------

--- @class Controller
--- @description Represents a controller of a unit or group.
--- @field setTask fun(self:Controller, task:table) Sets a specified task to the units or groups associated with the controller.
--- @field resetTask fun(self:Controller) Resets the current task assigned to the controller.
--- @field pushTask fun(self:Controller, task:table) Pushes a task to the front of the tasking queue.
--- @field popTask fun(self:Controller) Removes the top task from the tasking queue.
--- @field hasTask fun(self:Controller):boolean Returns true if the controller has a task.
--- @field setCommand fun(self:Controller, command:table) Sets a command, an instant action with no impact on active tasks.
--- @field setOption fun(self:Controller, optionId:number|enum, optionValue:number|enum) Sets behavior options that affect all tasks performed by the controller.
--- @field setOnOff fun(self:Controller, value:boolean) Enables or disables the AI controller, not applicable to aircraft or helicopters.
--- @field setAltitude fun(self:Controller, altitude:number, keep:boolean, altType:string) Sets the altitude for aircraft, with an option to maintain it at waypoints.
--- @field setSpeed fun(self:Controller, speed:number, keep:boolean) Sets the speed for the controlled group, with an option to maintain it at waypoints.
--- @field knowTarget fun(self:Controller, object:Object, type:boolean, distance:boolean) Forces the controller to become aware of a specified target.
--- @field isTargetDetected fun(self:Controller, target:Object, detectionType1:enum, detectionType2:enum, detectionType3:enum,...):table Returns details if the target is detected.
--- @field getDetectedTargets fun(self:Controller, detectionType1:enum, detectionType2:enum, detectionType3:enum,...):table Returns a table of detected targets.

------------------------------------------------------------------------------

--- @class Task
--- @description Represents a task that can be assigned to a unit or group.
--- @field id string
--- @field params table

------------------------------------------------------------------------------

--- @class Spot
--- @description Represents a spot from laser or IR-pointer.
--- @field createLaser fun(source:Object, localRef:Vec3, point:Vec3, laserCode:number|nil):Spot Creates a laser ray. localRef is optional; use nil if not needed. If laserCode is absent, defaults to an IR beam.
--- @field createInfraRed fun(source:Object, localRef:Vec3, point:Vec3):Spot Creates an infrared ray visible with night vision. localRef is optional; use nil if not needed.
--- @field setPoint fun(self:Spot, vec3:Vec3) Sets the destination point for the spot.
--- @field getCode fun(self:Spot):number Returns the laser code used for laser designation. Default and max value is 1688.
--- @field setCode fun(self:Spot, code:number) Sets the laser code for laser designation. Default and max value is 1688.
--- @field destroy fun(self:Object) Destroys the object, removing it from the game world without an event. If used with a group, the entire group will be destroyed.
--- @field getCategory fun(self:Object):Spot.Category Returns the category and sub-category of the object.
--- @field getPoint fun(self:Object):Vec3 Returns the x, y, and z coordinates of the objects position in 3D space.

------------------------------------------------------------------------------

--- @class Warehouse
--- @description The warehouse class gives control over warehouses that exist in airbase objects. These warehouses can limit the aircraft, munitions, and fuel available to coalition aircraft.
--- @field addItem fun(self:Warehouse, itemName:string|table, count:number) Adds the specified amount of an item to the warehouse.
--- @field getItemCount fun(self:Warehouse, itemName:string|table):number Returns the count of the specified type of item in the warehouse.
--- @field setItem fun(self:Warehouse, itemName:string|table, count:number) Sets the specified amount of an item in the warehouse.
--- @field removeItem fun(self:Warehouse, itemName:string|table, count:number) Removes the specified amount of an item from the warehouse.
--- @field addLiquid fun(self:Warehouse, liquidType:number, count:number) Adds the specified amount of a liquid to the warehouse.
--- @field getLiquidAmount fun(self:Warehouse, liquidType:number):number Returns the amount of the specified liquid in the warehouse.
--- @field setLiquidAmount fun(self:Warehouse, liquidType:number, count:number) Sets the specified amount of a liquid in the warehouse.
--- @field removeLiquid fun(self:Warehouse, liquidType:number, count:number) Removes the specified amount of a liquid from the warehouse.
--- @field getOwner fun(self:Warehouse):Airbase Returns the airbase associated with the warehouse.
--- @field getInventory fun(self:Warehouse, itemName:string|table):table Returns a full itemized list of the inventory, empty if category is set to unlimited.

------------------------------------------------------------------------------
--- ENUMERATORS
------------------------------------------------------------------------------

Object = {}

Object.Category = {
    UNIT = 1,
    WEAPON = 2,
    STATIC = 3,
    BASE = 4,
    SCENERY = 5,
    CARGO = 6
}

------------------------------------------------------------------------------

Unit = {}

Unit.Category = {
    AIRPLANE = 0,
    HELICOPTER = 1,
    GROUND_UNIT = 2,
    SHIP = 3,
    STRUCTURE = 4
}

Unit.RefuelingSystem = {
    BOOM_AND_RECEPTACLE = 0,
    PROBE_AND_DROGUE = 1
}

Unit.SensorType = {
    OPTIC = 0,
    RADAR = 1,
    IRST = 2,
    RWR = 3
}

Unit.OpticType = {
    TV = 0,
    LLTV = 1,
    IR = 2
}

Unit.RadarType = {
    AS = 0,
    SS = 1
}

------------------------------------------------------------------------------

Airbase = {}

Airbase.Category = {
    AIRDROME = 0,
    HELIPAD = 1,
    SHIP = 2
}

------------------------------------------------------------------------------

Weapon = {}

Weapon.Category = {
    SHELL = 0,
    MISSILE = 1,
    ROCKET = 2,
    BOMB = 3
}

Weapon.GuidanceType = {
    INS = 1,
    IR = 2,
    RADAR_ACTIVE = 3,
    RADAR_SEMI_ACTIVE = 4,
    RADAR_PASSIVE = 5,
    TV = 6,
    LASER = 7,
    TELE = 8
}

Weapon.MissileCategory = {
    AAM = 1,
    SAM = 2,
    BM = 3,
    ANTI_SHIP = 4,
    CRUISE = 5,
    OTHER = 6
}

Weapon.WarheadType = {
    AP = 0,
    HE = 1,
    SHAPED_EXPLOSIVE = 2
}

------------------------------------------------------------------------------

StaticObject = {}

StaticObject.Category = {
    VOID = 0,
    UNIT = 1,
    WEAPON = 2,
    STATIC = 3,
    BASE = 4,
    SCENERY = 5,
    CARGO = 6
}

------------------------------------------------------------------------------

Group = {}

Group.Category = {
    AIRPLANE = 0,
    HELICOPTER = 1,
    GROUND = 2,
    SHIP = 3,
    TRAIN = 4
}

------------------------------------------------------------------------------

Controller = {}

Controller.Detection = {
    VISUAL = 1,
    OPTIC = 2,
    RADAR = 4,
    IRST = 8,
    RWR = 16,
    DLINK = 32
}

------------------------------------------------------------------------------

Spot = {}

Spot.Category = {
    INFRA_RED = 0,
    LASER = 1
}

------------------------------------------------------------------------------

country = {}

country.id = {
    ['RUSSIA'] = 0,
    ['UKRAINE'] = 1,
    ['USA'] = 2,
    ['TURKEY'] = 3,
    ['UK'] = 4,
    ['FRANCE'] = 5,
    ['GERMANY'] = 6,
    ['AGGRESSORS'] = 7,
    ['CANADA'] = 8,
    ['SPAIN'] = 9,
    ['THE_NETHERLANDS'] = 10,
    ['BELGIUM'] = 11,
    ['NORWAY'] = 12,
    ['DENMARK'] = 13,
    ['ISRAEL'] = 15,
    ['GEORGIA'] = 16,
    ['INSURGENTS'] = 17,
    ['ABKHAZIA'] = 18,
    ['SOUTH_OSETIA'] = 19,
    ['ITALY'] = 20,
    ['AUSTRALIA'] = 21,
    ['SWITZERLAND'] = 22,
    ['AUSTRIA'] = 23,
    ['BELARUS'] = 24,
    ['BULGARIA'] = 25,
    ['CHEZH_REPUBLIC'] = 26,
    ['CHINA'] = 27,
    ['CROATIA'] = 28,
    ['EGYPT'] = 29,
    ['FINLAND'] = 30,
    ['GREECE'] = 31,
    ['HUNGARY'] = 32,
    ['INDIA'] = 33,
    ['IRAN'] = 34,
    ['IRAQ'] = 35,
    ['JAPAN'] = 36,
    ['KAZAKHSTAN'] = 37,
    ['NORTH_KOREA'] = 38,
    ['PAKISTAN'] = 39,
    ['POLAND'] = 40,
    ['ROMANIA'] = 41,
    ['SAUDI_ARABIA'] = 42,
    ['SERBIA'] = 43,
    ['SLOVAKIA'] = 44,
    ['SOUTH_KOREA'] = 45,
    ['SWEDEN'] = 46,
    ['SYRIA'] = 47,
    ['YEMEN'] = 48,
    ['VIETNAM'] = 49,
    ['VENEZUELA'] = 50,
    ['TUNISIA'] = 51,
    ['THAILAND'] = 52,
    ['SUDAN'] = 53,
    ['PHILIPPINES'] = 54,
    ['MOROCCO'] = 55,
    ['MEXICO'] = 56,
    ['MALAYSIA'] = 57,
    ['LIBYA'] = 58,
    ['JORDAN'] = 59,
    ['INDONESIA'] = 60,
    ['HONDURAS'] = 61,
    ['ETHIOPIA'] = 62,
    ['CHILE'] = 63,
    ['BRAZIL'] = 64,
    ['BAHRAIN'] = 65,
    ['THIRDREICH'] = 66,
    ['YUGOSLAVIA'] = 67,
    ['USSR'] = 68,
    ['ITALIAN_SOCIAL_REPUBLIC'] = 69,
    ['ALGERIA'] = 70,
    ['KUWAIT'] = 71,
    ['QATAR'] = 72,
    ['OMAN'] = 73,
    ['UNITED_ARAB_EMIRATES'] = 74,
    ['SOUTH_AFRICA'] = 75,
    ['CUBA'] = 76,
    ['PORTUGAL'] = 77,
    ['GDR'] = 78,
    ['LEBANON'] = 79,
    ['CJTF_BLUE'] = 80,
    ['CJTF_RED'] = 81,
    ['UN_PEACEKEEPERS'] = 82,
    ['Argentina'] = 83,
    ['Cyprus'] = 84,
    ['Slovenia'] = 85,
    ['BOLIVIA'] = 86,
    ['GHANA'] = 87,
    ['NIGERIA'] = 88,
    ['PERU'] = 89,
    ['ECUADOR'] = 90
}

country.name = {
    [0] = 'RUSSIA',
    [1] = 'UKRAINE',
    [2] = 'USA',
    [3] = 'TURKEY',
    [4] = 'UK',
    [5] = 'FRANCE',
    [6] = 'GERMANY',
    [7] = 'AGGRESSORS',
    [8] = 'CANADA',
    [9] = 'SPAIN',
    [10] = 'THE_NETHERLANDS',
    [11] = 'BELGIUM',
    [12] = 'NORWAY',
    [13] = 'DENMARK',
    [15] = 'ISRAEL',
    [16] = 'GEORGIA',
    [17] = 'INSURGENTS',
    [18] = 'ABKHAZIA',
    [19] = 'SOUTH_OSETIA',
    [20] = 'ITALY',
    [21] = 'AUSTRALIA',
    [22] = 'SWITZERLAND',
    [23] = 'AUSTRIA',
    [24] = 'BELARUS',
    [25] = 'BULGARIA',
    [26] = 'CHEZH_REPUBLIC',
    [27] = 'CHINA',
    [28] = 'CROATIA',
    [29] = 'GREECE',
    [30] = 'HUNGARY',
    [31] = 'INDIA',
    [32] = 'IRELAND',
    [33] = 'JAPAN',
    [34] = 'KOREA',
    [35] = 'LUXEMBOURG',
    [36] = 'NEW_ZEALAND',
    [37] = 'POLAND',
    [38] = 'PORTUGAL',
    [39] = 'ROMANIA',
    [40] = 'SLOVAKIA',
    [41] = 'SLOVENIA',
    [42] = 'SOUTH_AFRICA',
    [43] = 'SWEDEN',
    [73] = 'OMAN',
    [74] = 'UNITED_ARAB_EMIRATES',
    [75] = 'SOUTH_AFRICA',
    [76] = 'CUBA',
    [77] = 'PORTUGAL',
    [78] = 'GDR',
    [79] = 'LEBANON',
    [80] = 'CJTF_BLUE',
    [81] = 'CJTF_RED',
    [82] = 'UN_PEACEKEEPERS',
    [83] = 'Argentina',
    [84] = 'Cyprus',
    [85] = 'Slovenia',
    [86] = 'BOLIVIA',
    [87] = 'GHANA',
    [88] = 'NIGERIA',
    [89] = 'PERU',
    [90] = 'ECUADOR'
}

country.names = country.name

------------------------------------------------------------------------------

AI = {}

AI.Task = {}

AI.Task.OrbitPattern = {
    RACE_TRACK = "Race-Track",
    CIRCLE = "Circle"
}

AI.Task.Designation = {
    NO = "No",
    WP = "WP",
    IR_POINTER = "IR-Pointer",
    LASER = "Laser",
    AUTO = "Auto"
}

AI.Task.TurnMethod = {
    FLY_OVER_POINT = "Fly Over Point",
    FIN_POINT = "Fin Point"
}

AI.Task.VehicleFormation = {
    VEE = "Vee",
    ECHELON_RIGHT = "EchelonR",
    OFF_ROAD = "Off Road",
    RANK = "Rank",
    ECHELON_LEFT = "EchelonL",
    ON_ROAD = "On Road",
    CONE = "Cone",
    DIAMOND = "Diamond"
}

AI.Task.AltitudeType = {
    RADIO = "RADIO",
    BARO = "BARO"
}

AI.Task.WaypointType = {
    TAKEOFF = "TakeOff",
    TAKEOFF_PARKING = "TakeOffParking",
    TURNING_POINT = "Turning Point",
    TAKEOFF_PARKING_HOT = "TakeOffParkingHot",
    LAND = "Land"
}

AI.Task.WeaponExpend = {
    QUARTER = "Quarter",
    TWO = "Two",
    ONE = "One",
    FOUR = "Four",
    HALF = "Half",
    ALL = "All"
}

AI.Skill = {PLAYER, CLIENT, AVERAGE, GOOD, HIGH, EXCELLENT}

AI.Option = {}

AI.Option.Air = {}

AI.Option.Air.id = {
    ROE = 0,
    REACTION_ON_THREAT = 1,
    RADAR_USING = 3,
    FLARE_USING = 4,
    FORMATION = 5,
    RTB_ON_BINGO = 6,
    SILENCE = 7,
    RTB_ON_OUT_OF_AMMO = 10,
    ECM_USING = 13,
    PROHIBIT_AA = 14,
    PROHIBIT_JETT = 15,
    PROHIBIT_AB = 16,
    PROHIBIT_AG = 17,
    MISSILE_ATTACK = 18,
    PROHIBIT_WP_PASS_REPORT = 19,
    OPTION_RADIO_USAGE_CONTACT = 21,
    OPTION_RADIO_USAGE_ENGAGE = 22,
    OPTION_RADIO_USAGE_KILL = 23,
    JETT_TANKS_IF_EMPTY = 25,
    FORCED_ATTACK = 26,
    PREFER_VERTICAL = 32
}

AI.Option.Air.val = {}

AI.Option.Air.val.ROE = {
    WEAPON_FREE = 0,
    OPEN_FIRE_WEAPON_FREE = 1,
    OPEN_FIRE = 2,
    RETURN_FIRE = 3,
    WEAPON_HOLD = 4
}

AI.Option.Air.val.REACTION_ON_THREAT = {
    NO_REACTION = 0,
    PASSIVE_DEFENCE = 1,
    EVADE_FIRE = 2,
    BYPASS_AND_ESCAPE = 3,
    ALLOW_ABORT_MISSION = 4,
    AAA_EVADE_FIRE = 5
}

AI.Option.Air.val.RADAR_USING = {
    NEVER = 0,
    FOR_ATTACK_ONLY = 1,
    FOR_SEARCH_IF_REQUIRED = 2,
    FOR_CONTINUOUS_SEARCH = 3
}

AI.Option.Air.val.FLARE_USING = {
    NEVER = 0,
    AGAINST_FIRED_MISSILE = 1,
    WHEN_FLYING_IN_SAM_WEZ = 2,
    WHEN_FLYING_NEAR_ENEMIES = 3
}

AI.Option.Air.val.ECM_USING = {
    NEVER_USE = 0,
    USE_IF_ONLY_LOCK_BY_RADAR = 1,
    USE_IF_DETECTED_LOCK_BY_RADAR = 2,
    ALWAYS_USE = 3
}

AI.Option.Air.val.MISSILE_ATTACK = {
    MAX_RANGE = 0,
    NEZ_RANGE = 1,
    HALF_WAY_RMAX_NEZ = 2,
    TARGET_THREAT_EST = 3,
    RANDOM_RANGE = 4
}

AI.Option.Ground = {}

AI.Option.Ground.id = {
    ROE = 0,
    FORMATION = 5,
    DISPERSE_ON_ATTACK = 8,
    ALARM_STATE = 9,
    ENGAGE_AIR_WEAPONS = 20,
    AC_ENGAGEMENT_RANGE_RESTRICTION = 24,
    Restrict_AAA_min = 27,
    Restrict_Targets = 28,
    Restrict_AAA_max = 29
}

AI.Option.Ground.val = {}

AI.Option.Ground.val.ALARM_STATE = {
    AUTO = 0,
    GREEN = 1,
    RED = 2
}

AI.Option.Ground.val.ROE = {
    OPEN_FIRE = 2,
    RETURN_FIRE = 3,
    WEAPON_HOLD = 4
}

AI.Option.Naval = {}

AI.Option.Naval.id = {
    ROE = 0
}

AI.Option.Naval.val = {}

AI.Option.Naval.val.ROE = {
    OPEN_FIRE = 2,
    RETURN_FIRE = 3,
    WEAPON_HOLD = 4
}

------------------------------------------------------------------------------

world = {}

world.event = {
    S_EVENT_INVALID = 0,
    S_EVENT_SHOT = 1,
    S_EVENT_HIT = 2,
    S_EVENT_TAKEOFF = 3,
    S_EVENT_LAND = 4,
    S_EVENT_CRASH = 5,
    S_EVENT_EJECTION = 6,
    S_EVENT_REFUELING = 7,
    S_EVENT_DEAD = 8,
    S_EVENT_PILOT_DEAD = 9,
    S_EVENT_BASE_CAPTURED = 10,
    S_EVENT_MISSION_START = 11,
    S_EVENT_MISSION_END = 12,
    S_EVENT_TOOK_CONTROL = 13,
    S_EVENT_REFUELING_STOP = 14,
    S_EVENT_BIRTH = 15,
    S_EVENT_HUMAN_FAILURE = 16,
    S_EVENT_DETAILED_FAILURE = 17,
    S_EVENT_ENGINE_STARTUP = 18,
    S_EVENT_ENGINE_SHUTDOWN = 19,
    S_EVENT_PLAYER_ENTER_UNIT = 20,
    S_EVENT_PLAYER_LEAVE_UNIT = 21,
    S_EVENT_PLAYER_COMMENT = 22,
    S_EVENT_SHOOTING_START = 23,
    S_EVENT_SHOOTING_END = 24,
    S_EVENT_MARK_ADDED = 25,
    S_EVENT_MARK_CHANGE = 26,
    S_EVENT_MARK_REMOVED = 27,
    S_EVENT_KILL = 28,
    S_EVENT_SCORE = 29,
    S_EVENT_UNIT_LOST = 30,
    S_EVENT_LANDING_AFTER_EJECTION = 31,
    S_EVENT_PARATROOPER_LENDING = 32,
    S_EVENT_DISCARD_CHAIR_AFTER_EJECTION = 33,
    S_EVENT_WEAPON_ADD = 34,
    S_EVENT_TRIGGER_ZONE = 35,
    S_EVENT_LANDING_QUALITY_MARK = 36,
    S_EVENT_BDA = 37,
    S_EVENT_AI_ABORT_MISSION = 38,
    S_EVENT_DAYNIGHT = 39,
    S_EVENT_FLIGHT_TIME = 40,
    S_EVENT_PLAYER_SELF_KILL_PILOT = 41,
    S_EVENT_PLAYER_CAPTURE_AIRFIELD = 42,
    S_EVENT_EMERGENCY_LANDING = 43,
    S_EVENT_UNIT_CREATE_TASK = 44,
    S_EVENT_UNIT_DELETE_TASK = 45,
    S_EVENT_MAX = 46
}

world.BirthPlace = {
    wsBirthPlace_Air = 1,
    wsBirthPlace_Ship = 3,
    wsBirthPlace_RunWay = 4,
    wsBirthPlace_Park = 5,
    wsBirthPlace_Heliport_Hot = 9,
    wsBirthPlace_Heliport_Cold = 10,
    wsBirthPlace_Ship_Cold = 11,
    wsBirthPlace_Ship_Hot = 12
}

world.VolumeType = {
    SEGMENT = 0,
    BOX = 1,
    SPHERE = 2,
    PYRAMID = 3
}

------------------------------------------------------------------------------

radio = {}

radio.modulation = {
    AM = 0,
    FM = 1
}

------------------------------------------------------------------------------

trigger = {}

trigger.smokeColor = {
    Green = 0,
    Red = 1,
    White = 2,
    Orange = 3,
    Blue = 4
}

trigger.flareColor = {
    Green = 0,
    Red = 1,
    White = 2,
    Yellow = 3
}

------------------------------------------------------------------------------

coalition = {}

coalition.side = {
    NEUTRAL = 0,
    RED = 1,
    BLUE = 2,
    ALL = -1
}

coalition.service = {
    ATC = 0,
    AWACS = 1,
    TANKER = 2,
    FAC = 3
}

------------------------------------------------------------------------------

land = {}

land.SurfaceType = {
    LAND = 1,
    SHALLOW_WATER = 2,
    WATER = 3,
    ROAD = 4,
    RUNWAY = 5
}

------------------------------------------------------------------------------

VoiceChat = {}

VoiceChat.Side = {
    NEUTRAL = 0,
    RED = 1,
    BLUE = 2,
    ALL = 3
}

VoiceChat.RoomType = {
    PERSISTENT = 0,
    MULTICREW = 1,
    MANAGEABLE = 2
}

------------------------------------------------------------------------------
