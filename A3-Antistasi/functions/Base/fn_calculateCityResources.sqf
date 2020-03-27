params ["_city"];

/*  Calculates the resources granted by a city and the prestige change per tick

    Execution on: Server

    Scope: Internal

    Params:
        _city : STRING : The name of the city marker

    Returns:
        ARRAY : [_numCiv, _popRebels, _popEnemy, _popDestroyed, _moneyAddedByCity, _HRAddedByCity]
*/

private _moneyAddedByCity = 0;
private _HRAddedByCity = 0;

private _cityData = server getVariable _city;
_cityData params ["_numCiv", "_numVeh", "_prestigeEnemy", "_prestigeRebels", ["_supplySpace", []], ["_supplyStored", []]];
private _radioTowerHolder = [_city] call A3A_fnc_powerCheck;
private _multiplier = if (_radioTowerHolder != teamPlayer) then {0.5} else {1};

//Calculating population count
private _popRebels = (_numCiv * (_prestigeRebels / 100));
private _popEnemy = (_numCiv * (_prestigeEnemy / 100));
private _popDestroyed = 0;


if (_city in destroyedSites) then
{
    //Setting resources for destroyed cities
    _moneyAddedByCity = 0;
    _HRAddedByCity = 0;
    _popRebels = 0;
    _popEnemy = 0;
    _popDestroyed = _numCiv;
}
else
{
    //Calculating resources for city
    _moneyAddedByCity = ((_multiplier * _popRebels) / 3);
    _HRAddedByCity = (_popRebels / 100);
    if (sidesX getVariable [_city,sideUnknown] == Occupants) then
    {
        _moneyAddedByCity = (_moneyAddedByCity/2);
        _HRAddedByCity = (_HRAddedByCity/2);
    };
};

if(_popDestroyed == 0) then
{
    //City is not yet destroyed, calculate support change
    switch (_radioTowerHolder) do
    {
        case teamPlayer: {[-1,_suppBoost,_city] spawn A3A_fnc_citySupportChange};
        case Occupants: {[1,-1,_city] spawn A3A_fnc_citySupportChange};
        case Invaders: {[-1,-1,_city] spawn A3A_fnc_citySupportChange};
    };
};

private _sideEnemy = if(gameMode == 4) then {Invaders} else {Occupants};
private _nameEnemy = if(gameMode == 4) then {nameInvaders} else {nameOccupants};
private _colorEnemy = if(gameMode == 4) then {colorInvaders} else {colorOccupants};
if ((_prestigeEnemy < _prestigeRebels) and (sidesX getVariable [_city,sideUnknown] == _sideEnemy)) then
{
    ["TaskSucceeded", ["", format ["%1 joined %2",[_city, false] call A3A_fnc_location,nameTeamPlayer]]] remoteExec ["BIS_fnc_showNotification",teamPlayer];
    sidesX setVariable [_city, teamPlayer, true];
    [5,0] remoteExec ["A3A_fnc_prestige",2];
    private _mrkD = format ["Dum%1",_city];
    _mrkD setMarkerColor colorTeamPlayer;
    garrison setVariable [_city, [], true];
    sleep 5;
    {
        [_city,_x] spawn A3A_fnc_deleteControls
    } forEach controlsX;
    if ((!(["CONVOY"] call BIS_fnc_taskExists)) and (!bigAttackInProgress)) then
    {
        _base = [_city] call A3A_fnc_findBasesForConvoy;
        if (_base != "") then
        {
            [[_city,_base],"A3A_fnc_convoy"] call A3A_fnc_scheduler;
        };
    };
    [] call A3A_fnc_tierCheck;
};
if ((_prestigeEnemy > _prestigeRebels) and (sidesX getVariable [_city,sideUnknown] == teamPlayer)) then
{
    ["TaskFailed", ["", format ["%1 joined %2", [_city, false] call A3A_fnc_location, _nameEnemy]]] remoteExec ["BIS_fnc_showNotification",teamPlayer];
    sidesX setVariable [_city, _sideEnemy, true];
    [-5,0] remoteExec ["A3A_fnc_prestige",2];
    private _mrkD = format ["Dum%1",_city];
    _mrkD setMarkerColor _colorEnemy;
    garrison setVariable [_city, [], true];
    sleep 5;
    [] call A3A_fnc_tierCheck;
};

[_numCiv, _popRebels, _popEnemy, _popDestroyed, _moneyAddedByCity, _HRAddedByCity];
