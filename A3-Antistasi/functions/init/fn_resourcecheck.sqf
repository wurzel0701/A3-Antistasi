if (!isServer) exitWith{};

if (isMultiplayer) then {waitUntil {!isNil "switchCom"}};

private ["_textX"];
scriptName "resourcecheck";
_countSave = autoSaveInterval;

while {true} do
	{
	//sleep 600;//600
	nextTick = time + 600;
	waitUntil {sleep 15; time >= nextTick};
	if (isMultiplayer) then {waitUntil {sleep 10; isPlayer theBoss}};
	_suppBoost = 1+ ({sidesX getVariable [_x,sideUnknown] == teamPlayer} count seaports);
	_recAddSDK = 25;//0
	_hrAddBLUFOR = 0;//0
	_popFIA = 0;
	_popAAF = 0;
	_popCSAT = 0;
	_popTotal = 0;
	_bonusFIA = 1 + (0.25*({(sidesX getVariable [_x,sideUnknown] == teamPlayer) and !(_x in destroyedSites)} count factories));
	{
        private _cityData = [_x] call A3A_fnc_calculateCityResources;
        _cityData params ["_numCiv", "_popRebels", "_popEnemy", "_popDestroyed", "_moneyAddedByCity", "_HRAddedByCity"];
        _popTotal = _popTotal + _numCiv;
        _popAAF = _popAAF + _popEnemy;
        _popFIA = _popFIA + _popRebels;
        _popCSAT = _popCSAT + _popDestroyed;
        _recAddSDK = _recAddSDK + _moneyAddedByCity;
        _hrAddBLUFOR = _hrAddBLUFOR + _HRAddedByCity;
	} forEach citiesX;
	if (_popCSAT > (_popTotal / 3)) then {["destroyedSites",false,true] remoteExec ["BIS_fnc_endMission"]};
	if ((_popFIA > _popAAF) and ({sidesX getVariable [_x,sideUnknown] == teamPlayer} count airportsX == count airportsX)) then {["end1",true,true,true,true] remoteExec ["BIS_fnc_endMission",0]};
	/*
	{
	_fabrica = _x;
	if (sidesX getVariable [_fabrica,sideUnknown] == teamPlayer) then
		{
		if (not(_fabrica in destroyedSites)) then {_bonusFIA = _bonusFIA + 0.25};
		};
	} forEach factories;
	*/
	{
	_recurso = _x;
	if (sidesX getVariable [_recurso,sideUnknown] == teamPlayer) then
		{
		if (not(_recurso in destroyedSites)) then {_recAddSDK = _recAddSDK + (300 * _bonusFIA)};
		};
	} forEach resourcesX;
	_hrAddBLUFOR = (round _hrAddBLUFOR);
	_recAddSDK = (round _recAddSDK);

	_textX = format ["<t size='0.6' color='#C1C0BB'>Taxes Income.<br/> <t size='0.5' color='#C1C0BB'><br/>Manpower: +%1<br/>Money: +%2 €",_hrAddBLUFOR,_recAddSDK];
	[] call A3A_fnc_FIAradio;
	//_updated = false;
	_updated = [] call A3A_fnc_arsenalManage;
	if (_updated != "") then {_textX = format ["%1<br/>Arsenal Updated<br/><br/>%2",_textX,_updated]};
	[petros,"taxRep",_textX] remoteExec ["A3A_fnc_commsMP",[teamPlayer,civilian]];
	_hrAddBLUFOR = _hrAddBLUFOR + (server getVariable "hr");
	_recAddSDK = _recAddSDK + (server getVariable "resourcesFIA");
	server setVariable ["hr",_hrAddBLUFOR,true];
	server setVariable ["resourcesFIA",_recAddSDK,true];
	bombRuns = bombRuns + (({sidesX getVariable [_x,sideUnknown] == teamPlayer} count airportsX) * 0.25);
	[petros,"taxRep",_textX] remoteExec ["A3A_fnc_commsMP",[teamPlayer,civilian]];
	[] call A3A_fnc_economicsAI;
    [] call A3A_fnc_cleanConvoyMarker;

    //Update the amount of crates available
    private _availableCrates = server getVariable "cratesAvailable";
    for "_i" from 0 to 2 do
    {
        private _amount = _availableCrates select _i;
        if(_amount < 5) then
        {
            _availableCrates set [_i, _amount + 1];
        };
    };
    server setVariable ["cratesAvailable", _availableCrates, true];

	if (isMultiplayer) then
	{
		[] spawn A3A_fnc_promotePlayer;
		[] call A3A_fnc_assignBossIfNone;
		difficultyCoef = floor ((({side group _x == teamPlayer} count (call A3A_fnc_playableUnits)) - ({side group _x != teamPlayer} count (call A3A_fnc_playableUnits))) / 5);
		publicVariable "difficultyCoef";
	};

	if ((!bigAttackInProgress) and (random 100 < 50)) then {[] call A3A_fnc_missionRequestAUTO};
	//Removed from scheduler for now, as it errors on Headless Clients.
	//[[],"A3A_fnc_reinforcementsAI"] call A3A_fnc_scheduler;
	[] spawn A3A_fnc_reinforcementsAI;
	{
	_veh = _x;
	if ((_veh isKindOf "StaticWeapon") and ({isPlayer _x} count crew _veh == 0) and (alive _veh)) then
		{
		_veh setDamage 0;
		[_veh,1] remoteExec ["setVehicleAmmo",_veh];
		};
	} forEach vehicles;
	countCA = countCA - 600;
	if (countCA < 0) then {countCA = 0};
	publicVariable "countCA";
	if ((countCA == 0)/* and (diag_fps > minimoFPS)*/) then
		{
		[1200] remoteExec ["A3A_fnc_timingCA",2];
		if (!bigAttackInProgress) then
			{
			_script = [] spawn A3A_fnc_rebelAttack;
			waitUntil {sleep 5; scriptDone _script};
			};
		};
	sleep 3;
    _numWreckedAntennas = count antennasDead;
	//Probability of spawning a mission in.
    _shouldSpawnRepairThisTick = round(random 100) < 20;
    if ((_numWreckedAntennas > 0) && _shouldSpawnRepairThisTick && !(["REP"] call BIS_fnc_taskExists)) then
		{
		_potentials = [];
		{
		_markerX = [markersX, _x] call BIS_fnc_nearestPosition;
		if ((sidesX getVariable [_markerX,sideUnknown] == Occupants) and (spawner getVariable _markerX == 2)) exitWith
			{
			_potentials pushBack [_markerX,_x];
			};
		} forEach antennasDead;
		if (count _potentials > 0) then
			{
			_potential = selectRandom _potentials;
			[[_potential select 0,_potential select 1],"A3A_fnc_REP_Antenna"] call A3A_fnc_scheduler;
			};
		}
	else
		{
		_changingX = false;
		{
		_chance = 5;
		if ((_x in resourcesX) and (sidesX getVariable [_x,sideUnknown] == Invaders)) then {_chance = 20};
		if (random 100 < _chance) then
			{
			_changingX = true;
			destroyedSites = destroyedSites - [_x];
			_nameX = [_x] call A3A_fnc_localizar;
			["TaskSucceeded", ["", format ["%1 Rebuilt",_nameX]]] remoteExec ["BIS_fnc_showNotification",[teamPlayer,civilian]];
			sleep 2;
			};
		} forEach (destroyedSites - citiesX) select {sidesX getVariable [_x,sideUnknown] != teamPlayer};
		if (_changingX) then {publicVariable "destroyedSites"};
		};
	if (isDedicated) then
		{
		{
		if (side _x == civilian) then
			{
			_var = _x getVariable "statusAct";
			if (isNil "_var") then
				{
				if (local _x) then
					{
					if ((typeOf _x) in arrayCivs) then
						{
						if (vehicle _x == _x) then
							{
							if (primaryWeapon _x == "") then
								{
								_groupX = group _x;
								deleteVehicle _x;
								if ({alive _x} count units _groupX == 0) then {deleteGroup _groupX};
								};
							};
						};
					};
				};
			};
		} forEach allUnits;
		};
	if (autoSave) then
	{
		_countSave = _countSave - 600;
		if (_countSave <= 0) then
		{
			_countSave = autoSaveInterval;
			[] remoteExecCall ["A3A_fnc_saveLoop", 0, false];
		};
	};

	sleep 4;
	};
