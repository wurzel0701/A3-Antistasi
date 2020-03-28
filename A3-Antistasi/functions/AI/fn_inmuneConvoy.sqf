if (!isServer && hasInterface) exitWith{};

params ["_vehicle", "_text", ["_shouldHelp", true]];

private _isConvoy = false;
if ((_text == "Convoy Objective") || (_text == "Mission Vehicle")) then
{
    _isConvoy = true;
};

waitUntil {sleep 1; (!(isNull driver _vehicle)) || _isConvoy};

if (debug) then {revealX = true};

private _pos = [];
private _newPos = [];
_vehicle setVariable ["revealed", false, true];
while {alive _vehicle} do
{
	if (!(_vehicle getVariable ["revealed",false])) then
	{
		if ((teamPlayer knowsAbout _vehicle > 1.4) or revealX or _isConvoy) then
		{
			_vehicle setVariable ["revealed", true, true];
			[_vehicle,_text] remoteExec ["A3A_fnc_vehicleMarkers", [teamPlayer,civilian]];
		};
	}
	else
	{
		if ((teamPlayer knowsAbout _vehicle <= 1.4) and !(revealX) and !(_isConvoy)) then
		{
            _vehicle setVariable ["revealed", false, true];
		};
	};
	_pos = getPos _vehicle;
	sleep 60;
	_newPos = getPos _vehicle;

	private _driver = driver _vehicle;
    if(_shouldHelp) then
    {
        if ((_newPos distance _pos < 5) && !(isNull _driver)) then
    	{
    		if (_vehicle isKindOf "Air") then
    		{
    			if (isTouchingGround _vehicle) then
    			{
    				{
                        unAssignVehicle _x;
                        moveOut _x;
                        sleep 1.5;
    				} forEach assignedCargo _vehicle;
                };
            }
    		else
            {
    			if (!(_vehicle isKindOf "Ship")) then
    			{
    				if ({_x distance2D _newPos < 500} count (allPlayers - (entities "HeadlessClient_F")) == 0) then
    				{
    					private _bridges = nearestObjects [_newPos, ["Land_Bridge_01_PathLod_F","Land_Bridge_Asphalt_PathLod_F","Land_Bridge_Concrete_PathLod_F","Land_Bridge_HighWay_PathLod_F","Land_BridgeSea_01_pillar_F","Land_BridgeWooden_01_pillar_F"], 50];
    					if !(_bridges isEqualTo []) then
    					{
    						_nextWaypoint = currentWaypoint (group _driver);
    						_wpPos = waypointPosition ((waypoints (group _driver)) select _nextWaypoint);
    						_ang = [_newPos, _wpPos] call BIS_fnc_DirTo;
    						_newPos = _newPos getPos [100, _ang];
    					};
    					private _road = [_newPos, 100] call BIS_fnc_nearestRoad;
    					if (!isNull _road) then
    					{
    						_vehicle setPos (getPos _road);
                            {
                                _x hideObjectGlobal true;
                            } foreach (nearestTerrainObjects [position _road, ["tree","bush"], 15]);
    					};
    				};
    			};
    		};
    	};
    };
};
