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
_cityData params ["_numCiv", "_numVeh", "_prestigeEnemy", "_prestigeRebels", ["_supplySpace", [1000, 1000, 1000]], ["_supplyStored", [1000, 1000, 1000]]];
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

    private _prestigeChangeRebels = 0;
    private _prestigeChangeEnemy = 0;
    //City is not yet destroyed, calculate support change

    //Get the owner of the city and the enemy
    private _cityOwner = sidesX getVariable _city;

    //Calculate change based on supplies
    //Calculate ratios of goods
    private _ratio = [];
    _ratio pushBack ((_supplyStored select 0)/(_supplySpace select 0));     //FOOD supplies
    _ratio pushBack ((_supplyStored select 1)/(_supplySpace select 1));     //WATER supplies
    _ratio pushBack ((_supplyStored select 2)/(_supplySpace select 2));     //FUEL supplies

    private _isCritical = (_ratio findIf {_x <= 0.1}) != -1;
    private _isLow = (_ratio findIf {_x <= 0.25}) != -1;
    private _isFull = (_ratio findIf {_x >= 0.8}) != -1;

    //Calculate city reactions based on storage ratios
    if(_isCritical) then
    {
        //One or more supplies are critical, city is really angry
        if(_cityOwner == teamPlayer) then
        {
            _prestigeChangeRebels = _prestigeChangeRebels - 3;
            _prestigeChangeEnemy = _prestigeChangeEnemy - 1;
        }
        else
        {
            _prestigeChangeRebels = _prestigeChangeRebels - 1;
            _prestigeChangeEnemy = _prestigeChangeEnemy - 3;
        };
    }
    else
    {
        if(_isLow) then
        {
            //One or more supplies are low, city is pissed off
            if(_cityOwner == teamPlayer) then
            {
                _prestigeChangeRebels = _prestigeChangeRebels - 1;
            }
            else
            {
                _prestigeChangeEnemy = _prestigeChangeEnemy - 1;
            };
        }
        else
        {
            if(_isFull) then
            {
                //Storage of one or more supply is full, city is really happy
                if(_cityOwner == teamPlayer) then
                {
                    if(_prestigeRebels <= 50) then
                    {
                        _prestigeChangeRebels = _prestigeChangeRebels + 3;
                    };
                    _prestigeChangeEnemy = _prestigeChangeEnemy - 1;
                }
                else
                {
                    if(_prestigeEnemy <= 50) then
                    {
                        _prestigeChangeEnemy = _prestigeChangeEnemy + 3;
                    };
                    _prestigeChangeRebels = _prestigeChangeRebels - 1;
                };
            }
            else
            {
                //Goods are available without any shortages or extra stocks, city is ok
                if(_cityOwner == teamPlayer) then
                {
                    if(_prestigeRebels <= 50) then
                    {
                        _prestigeChangeRebels = _prestigeChangeRebels + 1;
                    };
                }
                else
                {
                    if(_prestigeEnemy <= 50) then
                    {
                        _prestigeChangeEnemy = _prestigeChangeEnemy + 1;
                    };
                };
            };
        };
    };

    //Decrease stored goods
    private _overallMultiplier = [0.5, 1, 2, 5] selectRandomWeighted [0.25, 0.4, 0.25, 0.1];
    private _usageFood = round (_numCiv * _overallMultiplier * (0.75 + (random 0.5)));
    private _usageWater = round (_numCiv * _overallMultiplier * (0.75 + (random 0.5)));
    private _usageFuel =  3 * round (_numVeh * _overallMultiplier * (0.75 + (random 0.5)));
    [_city, -_usageFood, -_usageWater, -_usageFuel] spawn A3A_fnc_changeCitySupply;

    //Calculate change based on radio towers
    switch (_radioTowerHolder) do
    {
        case teamPlayer:
        {
            if(_prestigeRebels >= 50) then {_prestigeChangeRebels = _prestigeChangeRebels + 1};
            if(_prestigeEnemy >= 50) then {_prestigeChangeEnemy = _prestigeChangeEnemy - 1};
        };
        case Occupants:
        {
            if(_prestigeRebels >= 50) then {_prestigeChangeRebels = _prestigeChangeRebels - 1};
            if(_prestigeEnemy >= 50) then {_prestigeChangeEnemy = _prestigeChangeEnemy + 1};
        };
        case Invaders:
        {
            if(gameMode == 4) then
            {
                if(_prestigeRebels >= 50) then {_prestigeChangeRebels = _prestigeChangeRebels - 1};
                if(_prestigeEnemy >= 50) then {_prestigeChangeEnemy = _prestigeChangeEnemy + 1};
            }
            else
            {
                if(_prestigeRebels >= 50) then {_prestigeChangeRebels = _prestigeChangeRebels - 1};
                if(_prestigeEnemy >= 50) then {_prestigeChangeEnemy = _prestigeChangeEnemy - 1};
            };
        };
    };

    [_prestigeChangeEnemy, _prestigeChangeRebels, _city] spawn A3A_fnc_citySupportChange;
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
