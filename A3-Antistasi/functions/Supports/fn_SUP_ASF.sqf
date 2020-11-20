params ["_side", "_timerIndex", "_supportObj", "_supportName"];

/*  Sets up the ASF support

    Execution: HC or Server

    Scope: Internal

    Params:
        _side: SIDE : The side of which the ASF should be send
        _timerIndex: NUMBER :  The number of the support timer
        _supportObj: OBJ : The position to which the airstrike should be carried out
        _supportName: STRING : The callsign of the support

    Returns:
        The name of the target marker, empty string if not created
*/


private _fileName = "SUP_ASF";
private _airport = [_supportObj, _side] call A3A_fnc_findAirportForAirstrike;

if(_airport == "") exitWith
{
    [2, format ["No airport found for %1 support", _supportName], _fileName] call A3A_fnc_log;
    ""
};

private _plane = if (_side == Occupants) then {vehNATOPlaneAA} else {vehCSATPlaneAA};
private _crewUnits = if(_side == Occupants) then {NATOPilot} else {CSATPilot};

private _targetMarker = createMarker [format ["%1_coverage", _supportName], getPos _supportObj];
_targetMarker setMarkerShape "ELLIPSE";
_targetMarker setMarkerBrush "Grid";
_targetMarker setMarkerSize [8000, 8000];

if(_side == Occupants) then
{
    _targetMarker setMarkerColor colorOccupants;
};
if(_side == Invaders) then
{
    _targetMarker setMarkerColor colorInvaders;
};
_targetMarker setMarkerAlpha 0;

//Blocks the airport from spawning in other planes while the support is waiting
//to avoid spawning planes in each other and sudden explosions
[_airport, 10] call A3A_fnc_addTimeForIdle;

//No runway on this airport, use airport position
//Not sure if I should go with 150 or 1000 here, players might be only 1001 meters away
//While technically 1000 meter height is technically visible from a greater distance
//150 is more likely to be in the actual viewcone of a player
private _spawnPos = (getMarkerPos _airport);
private _strikePlane = createVehicle [_plane, _spawnPos, [], 0, "FLY"];
_strikePlane setDir (_spawnPos getDir _supportObj);

//Put it in the sky
_strikePlane setPosATL (_spawnPos vectorAdd [0, 0, 1000]);

//Hide the hovering airplane from players view
_strikePlane hideObjectGlobal true;
_strikePlane enableSimulation false;
_strikePlane setVelocityModelSpace (velocityModelSpace _strikePlane vectorAdd [0, 150, 0]);

private _strikeGroup = createGroup _side;
private _pilot = [_strikeGroup, _crewUnits, getPos _strikePlane] call A3A_fnc_createUnit;
_pilot moveInDriver _strikePlane;

//_strikePlane disableAI "TARGET";
_strikePlane disableAI "AUTOTARGET";

private _timerArray = if(_side == Occupants) then {occupantsASFTimer} else {invadersASFTimer};

_timerArray set [_timerIndex, time + 5400];
_strikePlane setVariable ["TimerArray", _timerArray, true];
_strikePlane setVariable ["TimerIndex", _timerIndex, true];
_strikePlane setVariable ["supportName", _supportName, true];

//Setting up the EH for support destruction
_strikePlane addEventHandler
[
    "Killed",
    {
        params ["_strikePlane"];
        ["TaskSucceeded", ["", "Fighter Destroyed"]] remoteExec ["BIS_fnc_showNotification", teamPlayer];
        private _timerArray = _strikePlane getVariable "TimerArray";
        private _timerIndex = _strikePlane getVariable "TimerIndex";
        _timerArray set [_timerIndex, (_timerArray select _timerIndex) + 7200];
        [_strikePlane] spawn A3A_fnc_postMortem;
    }
];

_strikePlane addEventHandler
[
    "IncomingMissile",
    {
        params ["_plane", "_ammo", "_vehicle"];
        if !(_vehicle isKindOf "Man") then
        {
            //Vehicle fired a missile against the plane, add to target list if ground, no warning for players as this is an internal decision of the pilot
            if(_vehicle isKindOf "Air") then
            {
                private _supportName = _plane getVariable "supportName";
                [_supportName, [_vehicle, 3], 0] spawn A3A_fnc_addSupportTarget;
            }
            else
            {
                //Send support against ground based vehicles, retreat
                [_vehicle, 4, ["SEAD", "CAS", "MISSILE"], side group (driver _plane), random 1] spawn A3A_fnc_sendSupport;
                _plane setVariable ["Retreat", true, true];
            };
        };
        //Else case handled in client init
    }
];

_strikePlane addEventHandler
[
    "HandleDamage",
    {
        params ["_plane", "_selection", "_damage", "_vehicle", "_projectile"];
        //Check if bullet, we dont care about missiles, as these are handled above
        if(_projectile isKindOf "BulletCore") then
        {
            //Plane is getting hit by bullets, check if fired by unit or vehicle
            if(!(isNull (objectParent _vehicle)) || (_vehicle isKindOf "AllVehicles")) then
            {
                //Getting hit by a vehicle
                private _supportName = _plane getVariable "supportName";
                private _vehicle = if(_vehicle isKindOf "AllVehicles") then {_vehicle} else {objectParent _vehicle};
                if(_vehicle isKindOf "Air") then
                {
                    //Air based dogfight
                    [_supportName, [_vehicle, 3], 0] spawn A3A_fnc_addSupportTarget;
                }
                else
                {
                    //Send support against ground based vehicles, retreat
                    [_vehicle, 4, ["SEAD", "CAS", "MISSILE"], side group (driver _plane), random 1] spawn A3A_fnc_sendSupport;
                    _plane setVariable ["Retreat", true, true];
                };
            };
        };
    }
];

_pilot setVariable ["Plane", _strikePlane, true];
_pilot addEventHandler
[
    "Killed",
    {
        params ["_unit"];
        ["TaskSucceeded", ["", "ASF crew killed"]] remoteExec ["BIS_fnc_showNotification", teamPlayer];
        private _strikePlane = _unit getVariable "Plane";
        private _timerArray = _strikePlane getVariable "TimerArray";
        private _timerIndex = _strikePlane getVariable "TimerIndex";
        _timerArray set [_timerIndex, (_timerArray select _timerIndex) + 3600];
        [_unit] spawn A3A_fnc_postMortem;
    }
];
_strikeGroup deleteGroupWhenEmpty true;

[_strikePlane, _strikeGroup , _airport, _supportName, getPos _supportObj] spawn A3A_fnc_SUP_ASFRoutine;

_targetMarker;
