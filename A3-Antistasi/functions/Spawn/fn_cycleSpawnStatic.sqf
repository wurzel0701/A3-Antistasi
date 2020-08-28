params ["_marker", "_staticGroup", "_spawnParameter", "_allowedAt", "_index"];

private _side = side _staticGroup;
private _staticObject = objNull;

if(_side == teamPlayer) then
{
    _spawnParameter params ["_spawnPos", "_spawnDir", "_spawnType"];
    _staticObject = createVehicle [_spawnType, _spawnPos, [], 0, "CAN_COLLIDE"];
    _staticObject setDir _spawnDir;
    [_staticObject, _marker, _side] call A3A_fnc_staticInit;
}
else
{
    //Check if static has been killed and is not replenished by now
    if([_allowedAt] call A3A_fnc_unitAvailable) then
    {
        if(_spawnParameter isEqualType -1) then
        {
            _spawnParameter = [_marker, "Static"] call A3A_fnc_findSpawnPosition;
        };

        private _spawnPos = _spawnParameter select 0;
        private _nearestBuilding = nearestObject [_spawnPos, "HouseBase"];

        [3, format ["nearestBuilding is %1", (typeOf _nearestBuilding)], _fileName] call A3A_fnc_log;
        [3, format ["Spawn parameters are %1", _spawnParameter], _fileName] call A3A_fnc_log;

        if(!(_nearestBuilding isKindOf "Ruins")) then
        {
            private _staticType = _spawnParameter select 2;
            private _static = "";
            switch (_staticType) do
            {
                case ("MG"):
                {
                    _static = if(_side == Occupants) then {NATOMG} else {CSATMG};
                };
                case ("AA"):
                {
                    _static = if(_side == Occupants) then {staticAAOccupants} else {staticAAInvaders};
                };
                case ("AT"):
                {
                    _static = if(_side == Occupants) then {staticATOccupants} else {staticATInvaders};
                };
                case ("MORTAR"):
                {
                    _static = if(_side == Occupants) then {NATOMortar} else {CSATMortar};
                };
            };
            _staticObject = createVehicle [_static, _spawnPos, [], 0, "CAN_COLLIDE"];
            _staticObject setDir (_spawnParameter select 1);
            [_staticObject, _marker, _side, _index] call A3A_fnc_staticInit;

            private _crew = if(_side == Occupants) then {staticCrewOccupants} else {staticCrewInvaders};
            private _gunner =  _staticGroup createUnit [_crew, [0,0,0], [], 5, "NONE"];
            [_gunner, _marker] call A3A_fnc_NATOinit;
            _gunner moveInGunner _staticObject;

            _gunner setVariable ["StaticIndex", _index, true];
            _gunner setVariable ["StaticMarker", _marker, true];
            _gunner setVariable ["StaticSide", _side, true];
            _gunner addEventHandler
            [
                "Killed",
                {
                    private _gunner = _this select 0;
                    private _marker = _gunner getVariable "StaticMarker";
                    private _index = _gunner getVariable "StaticIndex";
                    private _side = _gunner getVariable "StaticSide";
                    ["Static", _marker, _index, 15 * (4 - skillMult), _side] call A3A_fnc_addTimeoutForUnit;
                }
            ];
        };
    };
};

//Check if static is positioned on the ground
if((getPosATL _staticObject) select 2 < 1) then
{
    _staticObject setVectorUp (surfaceNormal (getPos _staticObject));
};

_staticObject;
