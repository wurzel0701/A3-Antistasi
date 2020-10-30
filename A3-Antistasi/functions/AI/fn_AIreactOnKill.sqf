params ["_group", "_killer"];

/*  Handles the reaction of a group when one of their members dies. Handles individual responces and the calls for support

    Execution on: Server or HC

    Scope: Internal

    Params:
        _group: GROUP : The group of which a unit has been killed
        _killer: OBJECT : The unit which has killed the unit

    Returns:
        Nothing
*/

private _enemy = objNull;
private _aliveGroupMembers = (units _group) select {[_x] call A3A_fnc_canFight};
private _unitCount = count _aliveGroupMembers;

//No group member left in fighting condition,
if(_unitCount == 0) exitWith {};

//If _killer is not set or the same side (collision for example), abort here
if((isNil "_killer") || {(isNull _killer) || {side (group _killer) == side _group}}) exitWith {};

//Call help if possible
if(_group getVariable ["canCallSupportAt", -1] < dateToNumber date) then
{
    private _supportTypes = [_group, _killer] call A3A_fnc_chooseSupport;
    if((count _supportTypes) > 0) then
    {
        //Check if we are attacking the vehicle or man
        private _enemyVehicle = objectParent _killer;
        if(isNull _enemyVehicle && {!(_killer isKindOf "Man")}) then
        {
            _enemyVehicle = _enemy;
        };
        //Call the support on the unit or its vehicle
        if(isNull _enemyVehicle) then
        {
            [_group, _supportTypes, _killer] spawn A3A_fnc_callForSupport;
        }
        else
        {
            [_group, _supportTypes, _enemyVehicle] spawn A3A_fnc_callForSupport;
        };
    };
};

{
    if (fleeing _x) then
	{
        if ([_x] call A3A_fnc_canFight) then
		{
            _enemy = _x findNearestEnemy _x;
            if (!isNull _enemy) then
			{
                if ((_x distance _enemy < 50) && (vehicle _x == _x)) then
				{
                    [_x] spawn A3A_fnc_surrenderAction;
				}
                else
				{
                    if (([primaryWeapon _x] call BIS_fnc_baseWeapon) in allMachineGuns) then
                    {
                        [_x,_enemy] call A3A_fnc_suppressingFire
                    }
                    else
                    {
                        [_x,_x,_enemy] spawn A3A_fnc_chargeWithSmoke
                    };
				};
			};
		};
	}
    else
	{
        if ([_x] call A3A_fnc_canFight) then
		{
            _enemy = _x findNearestEnemy _x;
            if (!isNull _enemy) then
			{
                if (([primaryWeapon _x] call BIS_fnc_baseWeapon) in allMachineGuns) then
				{
                    [_x,_enemy] call A3A_fnc_suppressingFire;
				}
                else
				{
                    if (sunOrMoon == 1 || haveNV) then
					{
                        [_x,_x,_enemy] spawn A3A_fnc_chargeWithSmoke;
					}
                    else
					{
                        if (sunOrMoon < 1) then
						{
                            if ((hasIFA && (typeOf _x in squadLeaders)) || (count (getArray (configfile >> "CfgWeapons" >> primaryWeapon _x >> "muzzles")) == 2)) then
							{
                                [_x,_enemy] spawn A3A_fnc_useFlares;
							};
						};
					};
				};
			}
            else
			{
                if ((sunOrMoon <1) && !haveNV) then
				{
                    if ((hasIFA && (typeOf _x in squadLeaders)) || (count (getArray (configfile >> "CfgWeapons" >> primaryWeapon _x >> "muzzles")) == 2)) then
					{
                        [_x] call A3A_fnc_useFlares;
					};
				};
			};
            if (random 1 < 0.5) then
            {
                if (_unitCount > 0) then
                {
                    _x allowFleeing (1 -(_x skill "courage") + (_unitCount/(count units _group)));
                };
            };
		};
	};
    sleep 1 + (random 1);
} forEach _aliveGroupMembers;
