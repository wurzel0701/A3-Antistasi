params ["_side", "_timerIndex", "_supportObj", "_supportName"];

/*  Sets up the gunship support

    Execution: HC or Server

    Scope: Internal

    Params:
        _side: SIDE : The side of which the CAS should be send
        _timerIndex: NUMBER :  The number of the support timer
        _supportObj: OBJ : The position to which the airstrike should be carried out
        _supportName: STRING : The callsign of the support

    Returns:
        The name of the target marker, empty string if not created
*/


private _fileName = "SUP_gunship";

private _supportPos = if(_supportObj isEqualType []) then {_supportObj} else {getPos _supportObj};
private _airport = [_supportPos, _side] call A3A_fnc_findAirportForAirstrike;

if(_airport == "") exitWith
{
    [2, format ["No airport found for %1 support", _supportName], _fileName] call A3A_fnc_log;
    ""
};

private _plane = if (_side == Occupants) then {"B_T_VTOL_01_armed_F"} else {"O_T_VTOL_02_vehicle_dynamicLoadout_F"};
private _crewUnits = if(_side == Occupants) then {NATOPilot} else {CSATPilot};

private _targetMarker = createMarker [format ["%1_coverage", _supportName], _supportPos];
_targetMarker setMarkerShape "ELLIPSE";
_targetMarker setMarkerBrush "Grid";
_targetMarker setMarkerSize [250, 250];

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
private _startDir = _spawnPos getDir _supportObj;
_strikePlane setDir _startDir;

//Put it in the sky
_strikePlane setPosATL (_spawnPos vectorAdd [0, 0, 1000]);

//Hide the hovering airplane from players view
_strikePlane hideObjectGlobal true;
_strikePlane enableSimulation false;
_strikePlane setVelocityModelSpace (velocityModelSpace _strikePlane vectorAdd [0, 150, 0]);

private _strikeGroup = createGroup _side;
private _pilot = [_strikeGroup, _crewUnits, getPos _strikePlane] call A3A_fnc_createUnit;
_pilot moveInDriver _strikePlane;

_strikePlane disableAI "AUTOTARGET";
_strikeGroup setCombatMode "GREEN";

private _timerArray = if(_side == Occupants) then {occupantsGunshipTimer} else {invadersGunshipTimer};

_timerArray set [_timerIndex, time + 7200];
_strikePlane setVariable ["TimerArray", _timerArray, true];
_strikePlane setVariable ["TimerIndex", _timerIndex, true];
_strikePlane setVariable ["supportName", _supportName, true];

//Setting up the EH for support destruction
_strikePlane addEventHandler
[
    "Killed",
    {
        params ["_strikePlane"];
        ["TaskSucceeded", ["", "Gunship Destroyed"]] remoteExec ["BIS_fnc_showNotification", teamPlayer];
        private _timerArray = _strikePlane getVariable "TimerArray";
        private _timerIndex = _strikePlane getVariable "TimerIndex";
        _timerArray set [_timerIndex, (_timerArray select _timerIndex) + 3600];
        [_strikePlane] spawn A3A_fnc_postMortem;
    }
];

_strikePlane addEventHandler
[
    "IncomingMissile",
    {
        //Missile launch against this plane detected, attack if vehicle, send other support if manpads
        params ["_plane", "_ammo", "_vehicle"];
        if !(_vehicle isKindOf "Man") then
        {
            //Vehicle fired a missile against the plane, add to target list if ground, no warning for players as this is an internal decision of the pilot
            if(_vehicle isKindOf "Air") then
            {
                [group driver _plane, ["ASF", "SAM"], _vehicle] spawn A3A_fnc_callForSupport;
                _plane setVariable ["Retreat", true, true];
            }
            else
            {
                private _supportName = _plane getVariable "supportName";
                [_supportName, [_vehicle, 3], 0] spawn A3A_fnc_addSupportTarget;
            };
        };
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
                    //Vehicle is a plane or attack heli (or a lucky chopper), retreat, as no AA weapons on board
                    [group driver _plane, ["ASF", "SAM"], _vehicle] spawn A3A_fnc_callForSupport;
                    _plane setVariable ["Retreat", true];
                }
                else
                {
                    if((getPos _vehicle) inArea (format ["%1_coverage", _supportName])) then
                    {
                        //Vehicle is a ground based AA, add to attack list
                        [_supportName, [_vehicle, 3], 0] spawn A3A_fnc_addSupportTarget;
                    }
                    else
                    {
                        //Vehicle is outside of radius, call in other support
                        [group driver _plane, ["CAS", "MISSILE", "CANNON", "CARPETBOMB", "MORTAR"], _vehicle] spawn A3A_fnc_callForSupport;
                    };
                };
            };
        };
        if(damage _plane > 0.5) then
        {
            _plane setVariable ["Retreat", true];
        };
    }
];

_strikeGroup deleteGroupWhenEmpty true;

//Calculate loiter entry point
private _distance = _strikePlane distance2D _supportPos;
private _angle = asin (1500/_distance);
private _lenght = cos (_angle) * _distance;
[3, format ["Distance %1 Length %2 Angle %3", _distance, _lenght, _angle], _fileName] call A3A_fnc_log;

private _height = (ATLToASL _supportPos) select 2;
_height = _height + 500;

//Sets minimal height in relation to ground
_strikePlane flyInHeight 500;

private _entryPos = _spawnPos getPos [_lenght, _startDir + _angle];
[3, format ["Entry Pos: %1", _entryPos], _fileName] call A3A_fnc_log;
_entryPos set [2, _height];

private _entryPoint = _strikeGroup addWaypoint [_entryPos, 0, 1];
_entryPoint setWaypointType "MOVE";
_entryPoint setWaypointSpeed "FULL";
_entryPoint setWaypointStatements ["true", "(vehicle this) setVariable ['InArea', true];"];

private _loiterWP = _strikeGroup addWaypoint [_supportPos, 0, 2];
_loiterWP setWaypointType "LOITER";
_loiterWP setWaypointLoiterType "CIRCLE_L";
_loiterWP setWaypointSpeed "NORMAL";
_loiterWP setWaypointLoiterRadius 1500;

_strikePlane setDir (_startDir + _angle);

if(_side == Occupants) then
{
    [_strikePlane, _strikeGroup, _airport, _supportName] spawn A3A_fnc_SUP_gunshipRoutineNATO;
}
else
{
    [_strikePlane, _strikeGroup, _airport, _supportName] spawn A3A_fnc_SUP_gunshipRoutineCSAT;
};

_targetMarker;
