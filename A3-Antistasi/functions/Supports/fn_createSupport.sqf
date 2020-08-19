params ["_side", "_timerIndex", "_supportType", "_supportTarget", "_precision", "_revealCall"];

/*  Creates an support type that attacks areas

    Execution on: Server

    Scope: Internal

    Parameters:
        _side: SIDE: The side of the support unit
        _timerIndex: NUMBER: The number of the timer for the support
        _supportType: STRING: The type of support to send
        _supportTarget: POSITION or OBJECT: The position or object which will be attacked
        _precision: NUMBER: How precise the target info is

    Returns:
        Nothing
*/

private _fileName = "createSupport";

//Selecting the first available name of support type
private _supportIndex = 0;
private _supportName = format ["%1%2", _supportType, _supportIndex];
while {(server getVariable [format ["%1_targets", _supportName], -1]) isEqualType []} do
{
    _supportIndex = _supportIndex + 1;
    _supportName = format ["%1%2", _supportType, _supportIndex];
};

[
    3,
    format ["New support name will be %1", _supportName],
    _fileName
] call A3A_fnc_log;

private _supportMarker = "";
switch (_supportType) do
{
    case ("QRF"):
    {
        _supportMarker = [_side, _supportTarget, _supportName] call A3A_fnc_SUP_QRF;
    };
    case ("AIRSTRIKE"):
    {
        _supportMarker = [_side, _timerIndex, _supportTarget, _supportName] call A3A_fnc_SUP_airstrike;
    };
    case ("MORTAR"):
    {
        _supportMarker = [_side, _timerIndex, _supportTarget, _supportName] call A3A_fnc_SUP_mortar;
    };
    case ("ORBSTRIKE"):
    {
        _supportMarker = [_side, _timerIndex, _supportTarget, _supportName] call A3A_fnc_SUP_orbitalStrike;
    };
};

if(_supportMarker != "") then
{
    server setVariable [format ["%1_targets", _supportName], [[[_supportTarget, _precision], _revealCall]], true];
    if (_side == Occupants) then
    {
        occupantsSupports pushBack [_supportType, _supportMarker, _supportName];
    };
    if(_side == Invaders) then
    {
        invadersSupports pushBack [_supportType, _supportMarker, _supportName];
    };
    private _supportPos = if (_supportTarget isEqualType objNull) then {getPos _supportTarget} else {_supportTarget};
    [_revealCall + (random 0.4) - 0.2, _side, toLower _supportType, _supportPos] spawn A3A_fnc_showInterceptedSetupCall;
};