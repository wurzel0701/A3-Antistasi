//check if action already on player
if (_IDs findIf {
	_params = player actionParams _x;
	(_params#0) isEqualTo "Load loot to crate"
} != -1) exitWith {};

//add load actions
player addAction [
	"Load loot to crate", 
	{
		[cursorTarget] call A3A_fnc_lootToCrate;
	},
	nil,
	1.5,
	true,
	true,
	"",
	"(
		((typeof cursorTarget) isEqualTo 'Box_IND_Wps_F') 
		and (cursorTarget distance _this < 3)
		and (!(_this getVariable ['carryingCrate', false]))
	)"
];

player addAction [
	"Load loot from crate to vehicle", 
	{
		[cursorTarget] call A3A_fnc_lootFromContainer;
	},
	nil,
	1.5,
	true,
	true,
	"",
	"(
		((typeof cursorTarget) isEqualTo 'Box_IND_Wps_F') 
		and (cursorTarget distance _this < 3)
		and (!(_this getVariable ['carryingCrate', false]))
	)"
];

//add carry actions
player addAction [
	"Carry Crate", 
	{
		[cursorTarget, true] call A3A_fnc_carryCrate;
	},
	nil,
	1.5,
	true,
	true,
	"",
	"(
		((typeof cursorTarget) isEqualTo 'Box_IND_Wps_F') 
		and (cursorTarget distance _this < 3)
		and ((cursorTarget getVariable ['pickedUp', true]) isEqualTo true)
		and ((attachedTo cursorTarget) isEqualTo objNull)
	)"
];

player addAction [
	"Drop Crate", 
	{
		[nil, false] call A3A_fnc_carryCrate;
	},
	nil,
	1.5,
	true,
	true,
	"",
	"(
		(_this getVariable ['carryingCrate', false])
	)"
];