params
[
    ["_reveal", 0, [0]],
    ["_side", sideEnemy, [sideEnemy]],
    ["_supportType", "", [""]],
    ["_position", [], [[]]]
];

/*  Shows the intercepted radio setup message to the players

    Execution on: Server

    Scope: Internal

    Parameters:
        _reveal: NUMBER : Decides how much of the info will be revealed
        _side: SIDE : The side which called in the support
        _supportType: NAME : The name of the support (not the callsign!!)

    Returns:
        Nothing
*/

//If you have found a key before, you get the full message if it is somewhere around your HQ
if(_position distance2D (getMarkerPos "Synd_HQ") < distanceMission) then
{
    if(_side == Occupants) then
    {
        if(occupantsRadioKeys > 0) then
        {
            occupantsRadioKeys = occupantsRadioKeys - 1;
            publicVariable "occupantsRadioKeys";
            _reveal = 1;
        };
    }
    else
    {
        if(occupantsRadioKeys > 0) then
        {
            invaderRadioKeys = invaderRadioKeys - 1;
            publicVariable "occupantsRadioKeys";
            _reveal = 1;
        };
    };
};

//Nothing will be revealed
if(_reveal <= 0.2) exitWith {};

private _text = "";
private _sideName = if(_side == Occupants) then {nameOccupants} else {nameInvaders};
if (_reveal <= 0.7) then
{
    //Side and setup is revealed
    _text = format ["%1 is setting up an unknown support", _sideName];
}
else
{
    switch (_supportType) do
    {
        case ("QRF"):
        {
            _text = format ["%1 just send a QRF", _sideName];
        };
        case ("AIRSTRIKE"):
        {
            _text = format ["%1 is preparing an airstrike", _sideName];
        };
        case ("MORTAR"):
        {
            _text = format ["%1 is setting up a mortar position", _sideName];
        };
        case ("ORBSTRIKE"):
        {
            _text = format ["A %1 satellite is preparing an orbital strike", _sideName];
        };
        case ("MISSILE"):
        {
            _text = format ["A %1 cruiser is readying a cruise missile", _sideName];
        };
        case ("SAM"):
        {
            _text = format ["%1 is setting up a SAM launcher", _sideName];
        };
        case ("CARPETBOMB"):
        {
            _text = format ["A heavy %1 bomber is on the way", _sideName];
        };
        case ("ASF"):
        {
            _text = format ["%1 is readying an air superiority fighter", _sideName];
        };
        case ("CAS"):
        {
            _text = format ["%1 is readying a CAS bomber", _sideName];
        };
        default
        {
            _text = format ["%1 is setting up %2 support", _sideName, _supportType];
        };
    };
};

//Broadcast message to nearby players
private _nearbyPlayers = allPlayers select {(_x distance2D _position) <= 2000};
if(count _nearbyPlayers > 0) then
{
    ["RadioIntercepted", [_text]] remoteExec ["BIS_fnc_showNotification",_nearbyPlayers];
};
