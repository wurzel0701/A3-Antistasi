params
[
    ["_supportName", "", [""]],
    ["_side", sideEnemy, [sideEnemy]],
    ["_timeTillExecution", 0, [0]]
];

/*  Removes the data of the support from the arrays

    Execution on: Server

    Scope: Internal

    Params:
        _supportName: STRING : The callsign of the support
        _side: SIDE : The side the support belongs too

    Returns:
        Nothing
*/

private _fileName = "endSupport";
if(_supportName == "" || _side == sideEnemy) exitWith
{
    [1, format ["Bad input, was %1", _this], _fileName] call A3A_fnc_log;
};

if(_timeTillExecution != 0) then
{
    sleep (_timeTillExecution * 60);
};

server setVariable [format ["%1_targets", _supportName], nil, true];

if (_side == Occupants) then
{
    private _index = occupantsSupports findIf {(_x select 2) == _supportName};
    occupantsSupports deleteAt _index;
};

if(_side == Invaders) then
{
    private _index = invadersSupports findIf {(_x select 2) == _supportName};
    invadersSupports deleteAt _index;
};

deleteMarker (format ["%1_coverage", _supportName]);
deleteMarker (format ["%1_text", _supportName]);

[2, format ["Ended support and deleted data for %1", _supportName], _fileName] call A3A_fnc_log;
