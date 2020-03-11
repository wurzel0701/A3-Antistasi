#define SPAWNED         0
#define ON_STANDBY      1
#define DESPAWNED       2

params ["_marker", ["_patrolMarker", ""]];

/*  Handles the despawn of any marker

    Execution on: Server or HC

    Scope: Internal

    Params:
        _marker: STRING : The name of the marker which despawn should be handled
        _patrolMarker: STRING : The name of the marker which marks the patrol area around the _marker

    Returns:
        Nothing
*/

private _fileName = "markerDespawner";
private _allGroups = [];
private _allVehicles = [];

waitUntil
{
    sleep 10;
    _allGroups = [_marker, "Groups"] call A3A_fnc_getSpawnedArray;
    _allVehicles = [_marker, "Vehicles"] call A3A_fnc_getSpawnedArray;
    private _needsSpawn = [_marker, true] call A3A_fnc_needsSpawn;
    private _markerState = spawner getVariable _marker;
    if(_markerState != _needsSpawn) then
    {
        if((_markerState == SPAWNED) && (_needsSpawn == ON_STANDBY)) then
        {
            //Enemy to far away, disable AI for now
            {
                {
                    _x enableSimulationGlobal false;
                } forEach (units _x);
            } forEach _allGroups;
        };
        if((_markerState == ON_STANDBY) && (_needsSpawn == SPAWNED)) then
        {
            //Enemy is closing in activate AI for now
            {
                {
                    _x enableSimulationGlobal true;
                } forEach (units _x);
            } forEach _allGroups;
        };
        spawner setVariable [_marker, _needsSpawn, true];
    };
    (_needsSpawn == DESPAWNED)
};

[2, format ["Starting despawn progress of %1", _marker], _fileName, true] call A3A_fnc_log;
[3, format ["All groups %1, all vehicle %2", _allGroups, _allVehicles], _fileName, true] call A3A_fnc_log;

[_marker] call A3A_fnc_freeSpawnPositions;

deleteMarker _patrolMarker;

{
	[_x] spawn A3A_fnc_groupDespawner;
} forEach _allGroups;


//This part will be deleted shortly
//Might have changed during runtime
_side = sidesX getVariable [_marker, sideUnknown];
if(_side == teamPlayer) then
{
    private _playerStatics = [];
    {
        if(_x isKindOf "StaticWeapon" && {(_x distance2D (getMarkerPos _marker)) < 150}) then
        {
            _allVehicles pushBackUnique _x;
            _playerStatics pushBack [[getPosATL _x, getDir _x, typeOf _x], -1];
        };
    } forEach vehicles;
    garrison setVariable [format ["%1_statics", _marker], _playerStatics, true];
};

{
    if(!(_x getVariable ["Stolen", false])) then
    {
        deleteVehicle _x;
    };
} forEach _allVehicles;

//Delete spawnedArrays
spawner setVariable [format ["%1_groups", _marker], nil, true];
spawner setVariable [format ["%1_vehicles", _marker], nil, true];