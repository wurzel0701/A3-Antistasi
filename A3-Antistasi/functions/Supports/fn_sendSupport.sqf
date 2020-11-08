params ["_target", "_precision", "_supportTypes", "_side", "_revealCall"];

/*  Selects the support based on the needs and the availability (Is this even a word?)

    Execution on: Server

    Scope: Internal

    Parameters:
        _target: OBJECT : The target object to attack
        _precision: NUMBER : The precision on the target data in range 0 to 4
        _supportTypes: ARRAY of STRINGs : The requested support types
        _side: SIDE : The side of the support callers
        _revealCall: NUMBER : How much of the call should be known to players 0 - nothing to 1 - full

    Returns:
        Nothing
*/

private _fileName = "sendSupport";

waitUntil {sleep 0.1; !supportCallInProgress};
supportCallInProgress = true;

//Calculate deprecision on position
private _deprecisionRange = random (150 - ((_precision/4) * (_precision/4) * 125));
private _randomDir = random 360;
private _supportPos = _target getPos [_deprecisionRange, _randomDir];

//Search for any support already active in the area matching the _supportTypes
private _supportObject = "";
private _supportType = "";
private _blockedSupports = [];

private _supportArray = if(_side == Occupants) then {occupantsSupports} else {invadersSupports};
{
    _supportType = _x;
    private _index = -1;
    _index = _supportArray findIf {((_x select 0) == _supportType) && {_supportPos inArea (_x select 1)}};

    if((_index != -1) && {_supportType in ["AIRSTRIKE", "QRF"]}) then
    {
        [2, format ["Blocking %1 support for given position, as another support of this type is near", _supportType], _fileName] call A3A_fnc_log;
        _index = -1;
        _blockedSupports pushBack _supportType;
    };

    if(_index != -1) exitWith
    {
        _supportObject = _supportArray select _index select 2;
    };
} forEach _supportTypes;


//Support is already in the area, send instructions to them
if (_supportObject != "") exitWith
{
    supportCallInProgress = false;
    if(_supportType != "QRF") then
    {
        [
            2,
            format ["Support of type %1 is already in the area, transmitting attack orders", _supportType],
            _fileName
        ] call A3A_fnc_log;

        //Attack with already existing support
        if(_supportType in ["MORTAR"]) then
        {
            //Areal support methods, transmit position info
            [_supportObject, [_supportPos, _precision], _revealCall] call A3A_fnc_addSupportTarget;
        };
        if(_supportType in ["CAS", "ASF", "SAM", "GUNSHIP", "MISSILE", "CAS"]) then
        {
            //Target support methods, transmit target info
            [_supportObject, [_target, _precision], _revealCall] call A3A_fnc_addSupportTarget;
        };
    };
};
//Delete blocked supports
_supportTypes = _supportTypes - _blockedSupports;

private _selectedSupport = "";
private _timerIndex = -1;
{
    _timerIndex = [_x, _side, _supportPos] call A3A_fnc_supportAvailable;
    if (_timerIndex != -1) exitWith
    {
        _selectedSupport = _x;
    };
} forEach _supportTypes;

if(_selectedSupport == "") exitWith
{
    [2, format ["No support available to support at %1", _supportPos], _fileName] call A3A_fnc_log;
    supportCallInProgress = false;
};

[2, format ["Sending support type %1 to help at %2", _selectedSupport, _supportPos], _fileName] call A3A_fnc_log;

if(_selectedSupport in ["MORTAR", "QRF", "AIRSTRIKE", "ORBSTRIKE", "CARPETBOMB"]) then
{
    //Areal support methods, transmit position info
    [_side, _timerIndex, _selectedSupport, _supportPos, _precision, _revealCall] spawn A3A_fnc_createSupport;
};
if(_selectedSupport in ["CAS", "ASF", "SAM", "GUNSHIP", "MISSILE"]) then
{
    //Target support methods, transmit target info
    [_side, _timerIndex, _selectedSupport, _target, _precision, _revealCall] spawn A3A_fnc_createSupport;
};

//Blocks the same support for ten minutes or until a new support happens
server setVariable ["lastSupport", [_selectedSupport, time + 600], true];
