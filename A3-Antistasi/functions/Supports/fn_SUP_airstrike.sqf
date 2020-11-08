params ["_side", "_timerIndex", "_supportPos", "_supportName"];

/*  Sets up the data for the airstrike support

    Execution on: Server

    Scope: Internal

    Params:
        _side: SIDE : The side of which the airstrike should be send
        _timerIndex: NUMBER :  The number of the support timer
        _supportPos: POSITION : The position to which the airstrike should be carried out
        _supportName: STRING : The callsign of the support

    Returns:
        The name of the target marker, empty string if not created
*/

private _fileName = "SUP_airstrike";
private _airport = [_supportPos, _side] call A3A_fnc_findAirportForAirstrike;

if(_airport == "") exitWith
{
    [2, format ["No airport found for %1 support", _supportName], _fileName] call A3A_fnc_log;
    ""
};

private _plane = if (_side == Occupants) then {vehNATOPlane} else {vehCSATPlane};
private _crewUnits = if(_side == Occupants) then {NATOPilot} else {CSATPilot};
private _bombType = "";

private _targetMarker = createMarker [format ["%1_coverage", _supportName], _supportPos];
_targetMarker setMarkerShape "ELLIPSE";
_targetMarker setMarkerBrush "Grid";
_targetMarker setMarkerSize [25, 100];
if(_side == Occupants) then
{
    _targetMarker setMarkerColor colorOccupants;
};
if(_side == Invaders) then
{
    _targetMarker setMarkerColor colorInvaders;
};
_targetMarker setMarkerAlpha 0;

private _enemies = allUnits select
{
    (alive _x) &&
    {(side (group _x) != _side) && (side (group _x) != civilian) &&
    {((getPos _x) inArea _targetMarker)}}
};

if(isNil "napalmEnabled") then
{
    [1, "napalmEnabled does not containes a value, assuming false", _fileName] call A3A_fnc_log;
    napalmEnabled = false;
};

private _bombType = if (napalmEnabled) then {"NAPALM"} else {"CLUSTER"};
{
    if (vehicle _x isKindOf "Tank") then
    {
        _bombType = "HE";
    }
    else
    {
        if (vehicle _x != _x) then
        {
            if !(vehicle _x isKindOf "StaticWeapon") then {_bombType = "CLUSTER"};
        };
    };
    if (_bombType == "HE") exitWith {};
} forEach _enemies;

[2, format ["Airstrike will be carried out with bombType %1", _bombType], _fileName] call A3A_fnc_log;

//Blocks the airport from spawning in other planes while the support is waiting
//to avoid spawning planes in each other and sudden explosions
[_airport, 3] call A3A_fnc_addTimeForIdle;

private _spawnPos = (getMarkerPos _airport);
private _strikePlane = createVehicle [_plane, _spawnPos, [], 0, "FLY"];
private _dir = _spawnPos getDir _supportPos;
_strikePlane setDir _dir;

//Put it in the sky
_strikePlane setPosATL (_spawnPos vectorAdd [0, 0, 500]);

//Hide the hovering airplane from players view
_strikePlane hideObjectGlobal true;
_strikePlane enableSimulation false;
_strikePlane setVelocityModelSpace (velocityModelSpace _strikePlane vectorAdd [0, 150, 0]);

private _strikeGroup = createGroup _side;
private _pilot = [_strikeGroup, _crewUnits, getPos _strikePlane] call A3A_fnc_createUnit;
_pilot moveInDriver _strikePlane;

_strikePlane disableAI "TARGET";
_strikePlane disableAI "AUTOTARGET";
_strikePlane setVariable ["bombType", _bombType, true];

private _timerArray = if(_side == Occupants) then {occupantsAirstrikeTimer} else {invadersAirstrikeTimer};

_timerArray set [_timerIndex, time + 1800];
_strikePlane setVariable ["TimerArray", _timerArray, true];
_strikePlane setVariable ["TimerIndex", _timerIndex, true];
_strikePlane setVariable ["supportName", _supportName, true];
_strikePlane setVariable ["side", _side, true];

//Setting up the EH for support destruction
_strikePlane addEventHandler
[
    "Killed",
    {
        params ["_strikePlane"];
        [2, format ["Plane for %1 destroyed, airstrike aborted", _strikePlane getVariable "supportName"], "SUP_airstrike"] call A3A_fnc_log;
        ["TaskSucceeded", ["", "Airstrike Vessel Destroyed"]] remoteExec ["BIS_fnc_showNotification", teamPlayer];
        private _timerArray = _strikePlane getVariable "TimerArray";
        private _timerIndex = _strikePlane getVariable "TimerIndex";
        _timerArray set [_timerIndex, (_timerArray select _timerIndex) + 3600];
        [_strikePlane getVariable "supportName", _strikePlane getVariable "side"] spawn A3A_fnc_endSupport;
        [_strikePlane] spawn A3A_fnc_postMortem;

        if((_strikePlane getVariable "side") == Occupants) then
        {
            [[20, 45], [0, 0]] remoteExec ["A3A_fnc_prestige", 2];
        }
        else
        {
            [[0, 0], [20, 45]] remoteExec ["A3A_fnc_prestige", 2];
        };
    }
];

_pilot setVariable ["Plane", _strikePlane, true];
_pilot addEventHandler
[
    "Killed",
    {
        params ["_unit"];
        ["TaskSucceeded", ["", "Airstrike crew killed"]] remoteExec ["BIS_fnc_showNotification", teamPlayer];
        private _strikePlane = _unit getVariable "Plane";
        [2, format ["Crew for %1 killed, airstrike aborted", _strikePlane getVariable "supportName"], "SUP_airstrike"] call A3A_fnc_log;
        private _timerArray = _strikePlane getVariable "TimerArray";
        private _timerIndex = _strikePlane getVariable "TimerIndex";
        _timerArray set [_timerIndex, (_timerArray select _timerIndex) + 1800];
        [_unit] spawn A3A_fnc_postMortem;
    }
];

_pilot spawn
{
    private _pilot = _this;
    waitUntil {sleep 10; (isNull _pilot) || {!(alive _pilot) || (isNull objectParent _pilot)}};
    if(isNull _pilot || !(alive _pilot)) exitWith {};

    //Pilot ejected, spawn despawner
    [group _pilot] spawn A3A_fnc_groupDespawner;
};

_strikeGroup deleteGroupWhenEmpty true;

private _markerDir = _spawnPos getDir _supportPos;
_targetMarker setMarkerDir _markerDir;
[_side, _strikePlane, _strikeGroup , _airport, _supportPos, _supportName] spawn A3A_fnc_SUP_airstrikeRoutine;

_targetMarker;
