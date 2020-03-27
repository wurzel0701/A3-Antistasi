params ["_city", "_foodChange", "_waterChange", "_fuelChange"];

private _fileName = "changeCitySupply";
private _cityData = server getVariable _city;
if (isNil "_cityData" || {!(_cityData isEqualType [])}) exitWith
{
    [
        1,
        format ["Could not get city data for %1", _city],
        _fileName
    ] call A3A_fnc_log;
};

private _supplySpace = _cityData select 4;
private _supplyStored = _cityData select 5;

{
    _supplyStored set [_forEachIndex, (_supplyStored select _forEachIndex) + _x];
    if((_supplyStored select _forEachIndex) < 0) then
    {
        _supplyStored set [_forEachIndex, 0];
    };
    if((_supplyStored select _forEachIndex) > (_supplySpace select _forEachIndex)) then
    {
        _supplyStored set [_forEachIndex, (_supplySpace select _forEachIndex)];
    };
    if((_supplyStored select _forEachIndex) < (0.25 * (_supplySpace select _forEachIndex))) then
    {
        [_city, _forEachIndex] spawn
        {
            sleep (random 300);
            //TODO call in supply convoy from the nearest factory
            [
                3,
                format ["%1 needs supply of type %2", _this select 0, _this select 1],
                _fileName
            ] call A3A_fnc_log;
        };
    };
} forEach [_foodChange, _waterChange, _fuelChange];

server setVariable [_city,_cityData,true];
