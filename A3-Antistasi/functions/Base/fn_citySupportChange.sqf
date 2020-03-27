params ["_enemyChange", "_rebelChange", "_city"];

/*  Changes the support values of the given city

    Execution on: All

    Scope: External

    Params:
        _enemyChange : NUMBER : The amount of points the support of Occupants/Invaders should change
        _rebelChange : NUMBER : The amount of points the support of the rebels should change
        _city : STRING or ARRAY : Either the marker name of the city or a position from which the nearest city will get calculated

    Returns:
        true (Why? No idea, it doesn't returns anything if it fails)
*/

private _fileName = "citySupportChange";
waitUntil {!cityIsSupportChanging};
cityIsSupportChanging = true;

if !(_pos isEqualType "") then
{
    _city = [citiesX, _pos] call BIS_fnc_nearestPosition
};
private _cityData = server getVariable _city;
if (isNil "_cityData" || {!(_cityData isEqualType [])}) exitWith
{
	cityIsSupportChanging = false;
    [
        1,
        format ["Could not get city data for %1", _city],
        _fileName
    ] call A3A_fnc_log;
};

private _prestigeEnemy = _cityData select 2;
private _prestigeRebel = _cityData select 3;

if (_prestigeEnemy + _prestigeRebel + _enemyChange > 100) then
{
	_enemyChange = (_prestigeEnemy + _prestigeRebel) - 100;
};
_prestigeEnemy = _prestigeEnemy + _enemyChange;
if (_prestigeEnemy + _prestigeRebel + _rebelChange > 100) then
{
	_rebelChange = (_prestigeEnemy + _prestigeRebel) - 100;
};
_prestigeRebel = _prestigeRebel + _rebelChange;

if (_prestigeEnemy > 100) then {_prestigeEnemy = 100};
if (_prestigeRebel > 100) then {_prestigeRebel = 100};
if (_prestigeEnemy < 0) then {_prestigeEnemy = 0};
if (_prestigeRebel < 0) then {_prestigeRebel = 0};

_cityData set [2, _prestigeEnemy];
_cityData set [3, _prestigeRebel];

server setVariable [_city,_cityData,true];
cityIsSupportChanging = false;
true
