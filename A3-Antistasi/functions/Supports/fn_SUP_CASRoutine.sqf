params ["_strikePlane", "_strikeGroup", "_airport", "_supportName", "_setupPos"];

private _fileName = "SUP_CASRoutine";

private _side = side _strikeGroup;

//Sleep to simulate preparetion time
private _sleepTime = random (200 - ((tierWar - 1) * 20));
while {_sleepTime > 0} do
{
    sleep 1;
    _sleepTime = _sleepTime - 1;
    if((spawner getVariable _airport) != 2) exitWith {};
};

_strikePlane hideObjectGlobal false;
_strikePlane enableSimulation true;
_strikePlane flyInHeight 500;

//Decrease time if aggro is low
private _sideAggression = if(_side == Occupants) then {aggressionOccupants} else {aggressionInvaders};
private _timeAlive = 1200;
private _confirmedKills = 4;//[_strikePlane, 0] call A3A_fnc_countMissiles;
private _allowHeavyWeapon = true;

if(_sideAggression < (30 + (random 40))) then
{
    _timeAlive = 600;
    //Plane needs to have at least 6 missiles in all cases
    _confirmedKills = 2;
    _allowHeavyWeapon = false;
};

[_strikePlane, "CAS"] call A3A_fnc_setPlaneLoadout;

//Get available ammo count of all allowed propelled weapons
private _ammoCount = [];
private _loadout = _strikePlane getVariable "loadout";
private _weapons = (_strikePlane getVariable "rocketLauncher") + (_strikePlane getVariable "missileLauncher");
{
    private _weapon = _x;
    private _magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
    private _ammo = 0;
    {
        if(_x in _magazines) then
        {
            _ammo = _ammo + getNumber (configFile >> "CfgMagazines" >> _x >> "count");
        };
    } forEach _loadout;
    _ammoCount pushBack [_weapon, _ammo];
} forEach _weapons;
_strikePlane setVariable ["ammoCount", _ammoCount];

//REPEATING FIRE LOGIC
//Forcing the plane to fire is handled in this EH to avoid loops
_strikePlane addEventHandler
[
    "Fired",
    {
        params ["_strikePlane", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
        private _targetObj = _strikePlane getVariable ["currentTarget", objNull];
        if(isNull _targetObj) exitWith {};

        private _ammoCount = _strikePlane getVariable "ammoCount";

        if(_weapon == (_strikePlane getVariable "mainGun")) then
        {
            //Bullet, improve course and accuracy
            private _speed = speed _projectile/3.6;
            private _targetPos = ((getPosASL _targetObj) vectorAdd [0, 0, 3.5]) vectorAdd (vectorDir _targetObj vectorMultiply ((speed _targetObj)/4.5));
            _targetPos = _targetPos apply {_x + (random 15) - 7.5};
            private _dir = vectorNormalized (_targetPos vectorDiff (getPosASL _projectile));
            _projectile setVelocity (_dir vectorMultiply (_speed));
            _projectile setVectorDir _dir;

            //Check if next shot needs to be fired
            private _remainingShots = _strikePlane getVariable ["mainGunShots", 0];
            if(_remainingShots > 0) then
            {
                //Fire next shot
                [_strikePlane, _weapon, _mode] spawn
                {
                    params ["_strikePlane", "_weapon", "_mode"];
                    sleep 0.03;
                    (driver _strikePlane) forceWeaponFire [_weapon, _mode];
                };
                _strikePlane setVariable ["mainGunShots", _remainingShots - 1];
            };
        };
        if(_weapon in (_strikePlane getVariable ["rocketLauncher", []])) then
        {
            //Unguided rocket, improve course and accuracy
            private _targetPos = (getPosASL _targetObj) vectorAdd (vectorDir _targetObj vectorMultiply ((speed _targetObj)));
            private _target = _targetPos apply {_x + (random 30) - 15};

            //Reduce available ammo
            private _index = _ammoCount findIf {_weapon == _x select 0};
            _ammoCount select _index set [1, (_ammoCount#_index#1) - 1];

            //Check if next shot needs to be fired
            private _remainingShots = _strikePlane getVariable ["rocketShots", 0];
            if(_remainingShots > 0) then
            {
                //Fire next shot
                [_strikePlane, _weapon, _mode] spawn
                {
                    params ["_strikePlane", "_weapon", "_mode"];
                    sleep 0.2;
                    (driver _strikePlane) forceWeaponFire [_weapon, _mode];
                };
                _strikePlane setVariable ["rocketShots", _remainingShots - 1];
            };

            [_projectile, _target, _gunner] spawn
            {
                params ["_projectile", "_target", "_gunner"];
                sleep 0.05;
                while {!(isNull _projectile) && (alive _projectile)} do
                {
                    private _speed = (speed _projectile)/3.6;
                    private _dir = vectorNormalized (_target vectorDiff (getPosASL _projectile));
                    _projectile setVelocity (_dir vectorMultiply (_speed));
                    _projectile setVectorDir _dir;
                    sleep 0.25;
                };
            };
        };
        if(_weapon in (_strikePlane getVariable ["missileLauncher", []])) then
        {
            //Guided missile, dont do anything

            //Reduce the available ammo for internal logic
            private _index = _ammoCount findIf {_weapon == _x select 0};
            _ammoCount select _index set [1, (_ammoCount#_index#1) - 1];

            //Check if next shot needs to be fired (Unlikely, but possible)
            private _remainingShots = _strikePlane getVariable ["missileShots", 0];
            if(_remainingShots > 0) then
            {
                //Fire next shot
                [_strikePlane, _weapon, _mode] spawn
                {
                    params ["_strikePlane", "_weapon", "_mode"];
                    sleep 0.25;
                    _strikePlane fireAtTarget [_targetObj, _muzzle];
                };
                _strikePlane setVariable ["missileShots", _remainingShots - 1];
            };
        };
    }
];
//FIRE LOGIC END

//Prepare plane for usage
_strikePlane disableAI "TARGET";
_strikePlane disableAI "AUTOTARGET";
_strikeGroup setCombatMode "GREEN";
_strikePlane setVariable ["InArea", false, true];

private _dir = (getPos _strikePlane) getDir _setupPos;

private _areaWP = _strikeGroup addWaypoint [_setupPos getPos [-2000, _dir + 90], 0];
_areaWP setWaypointSpeed "FULL";
_areaWP setWaypointType "Move";
_areaWP setWaypointStatements ["true", "(vehicle this) setVariable ['InArea', true, true]; [3, 'CAS plane has arrived', 'CASRoutine'] call A3A_fnc_log"];

private _loiterWP = _strikeGroup addWaypoint [_setupPos, 0];
_loiterWP setWaypointSpeed "NORMAL";
_loiterWP setWaypointType "Loiter";
_loiterWP setWaypointLoiterRadius 2000;

//Await arrival at AO
waitUntil {sleep 1; !(alive _strikePlane) || (_strikePlane getVariable ["InArea", false])};

if !(alive _strikePlane) exitWith
{
    [_supportName, _side] call A3A_fnc_endSupport;
};

_sleepTime = 5;
private _targetObj = objNull;
private _isApproaching = false;
private _isRepathing = false;
private _currentWaypoint = _loiterWP;

while {_timeAlive > 0} do
{
    //Check if run script has control over the plane
    if !(_strikePlane getVariable ["OnRun", false]) then
    {
        if (isNull (_strikePlane getVariable ["currentTarget", objNull])) then
        {
            //Plane is currently not attacking a target, search for new order
            private _targetList = server getVariable [format ["%1_targets", _supportName], []];
            if (count _targetList > 0) then
            {
                //New target active, read in
                private _targetEntry = _targetList deleteAt 0;
                server setVariable [format ["%1_targets", _supportName], _targetList, true];
                [3, format ["Next target for %2 is %1", _targetEntry, _supportName], _fileName] call A3A_fnc_log;

                //Parse targets
                private _targetParams = _targetEntry select 0;
                private _reveal = _targetEntry select 1;
                _targetObj = _targetParams select 0;
                _strikeGroup reveal [_targetObj, _targetParams select 1];

                if (alive _targetObj) then
                {
                    //MARKER CREATING, UPDATING AND DISPLAYING
                    //Show target to players if change is high enough
                    private _textMarker = createMarker [format ["%1_text", _supportName], getPos _targetObj];
                    _textMarker setMarkerShape "ICON";
                    _textMarker setMarkerType "mil_objective";
                    _textMarker setMarkerText "CAS Target";

                    if(_side == Occupants) then {_textMarker setMarkerColor colorOccupants;}
                    else {_textMarker setMarkerColor colorInvaders;};
                    _textMarker setMarkerAlpha 0;

                    [_textMarker, _targetObj, _strikePlane] spawn
                    {
                        params ["_textMarker", "_targetObj", "_strikePlane"];
                        while
                        {
                            !(isNull _strikePlane) &&
                            {(alive _strikePlane) &&
                            (_strikePlane getVariable "currentTarget") == _targetObj}
                        } do
                        {
                            _textMarker setMarkerPos (getPos _targetObj);
                            sleep 0.5;
                        };
                        deleteMarker _textMarker;
                    };

                    [_reveal, getPos _targetObj, _side, "CAS", "", _textMarker] spawn A3A_fnc_showInterceptedSupportCall;
                    //MARKER SECTION END

                    _strikePlane setVariable ["currentTarget", _targetObj];
                    _strikePlane setVariable ["StartBombRun", false];

                    _fireMatrix = [];
                    if (_targetObj isKindOf "Tank") then
                    {
                        if(_allowHeavyWeapon) then
                        {
                            _fireMatrix =
                            [
                                [true, 25, 3, 1],
                                [true, 25, 3, 1],
                                [true, 35, 5, 1]
                            ];
                        }
                        else
                        {
                            _fireMatrix =
                            [
                                [true, 20, 0, 1],
                                [true, 20, 0, 0],
                                [true, 30, 3, 1]
                            ];
                        };
                    }
                    else
                    {
                        if((typeOf _targetObj) in (vehCSATAPC + vehNATOAPC)) then
                        {
                            if(_allowHeavyWeapon) then
                            {
                                _fireMatrix =
                                [
                                    [true, 30, 5, 0],
                                    [true, 30, 5, 1],
                                    [true, 30, 5, 1]
                                ];
                            }
                            else
                            {
                                _fireMatrix =
                                [
                                    [true, 25, 5, 1],
                                    [true, 25, 5, 0],
                                    [true, 25, 5, 0]
                                ];
                            };
                        }
                        else
                        {
                            if(_allowHeavyWeapon) then
                            {
                                _fireMatrix =
                                [
                                    [true, 35, 5, 0],
                                    [true, 35, 5, 0],
                                    [true, 35, 5, 0]
                                ];
                            }
                            else
                            {
                                _fireMatrix =
                                [
                                    [true, 25, 3, 0],
                                    [false, 25, 5, 0],
                                    [true, 25, 3, 0]
                                ];
                            };
                        };
                    };
                    _strikePlane setVariable ["fireParams", _fireMatrix];

                    //Find better path if the plane is too close
                    _strikePlane setVariable ["needsRecalculation", _targetObj distance2D _strikePlane < 3000];
                    _isRepathing = false;
                }
                else
                {
                    [3, format ["%1 skips target, as it is already dead", _supportName], _fileName] call A3A_fnc_log;
                };
            };
        }
        else
        {
            if(_strikePlane getVariable ["needsRecalculation", false]) then
            {
                if !(_isRepathing) then
                {
                    [3, format ["%1 needs to repath, calculating attack path", _supportName], _fileName] call A3A_fnc_log;
                    //Plane needs a new approach vector, calculate new
                    private _strikePlaneVector = (getPos _targetObj) vectorDiff (getPos _strikePlane);
                    _strikePlaneVector set [2, 0];
                    private _sidePath = _strikePlaneVector vectorCrossProduct [0,0,-1];
                    _repathVector = vectorNormalized _sidePath;
                    _repathVector = _repathVector vectorMultiply 2500;
                    [3, format ["Repath vector is %1", str _repathVector], _fileName] call A3A_fnc_log;

                    private _repathPos = (getPos _targetObj) vectorAdd _repathVector;
                    _repathPos set [2, 500];
                    [3, format ["Repath pos %1, object pos %2", str _repathPos, str (getPos _targetObj)], _fileName] call A3A_fnc_log;
                    private _repathWP = _strikeGroup addWaypoint [_repathPos, 0];
                    _repathWP setWaypointType "MOVE";
                    _repathWP setWaypointSpeed "FULL";
                    _strikeGroup setCurrentWaypoint _repathWP;
                    _currentWaypoint = _repathWP;
                    _sleepTime = 1;

                    _isRepathing = true;
                }
                else
                {
                    if((waypointPosition _currentWaypoint) distance2D _strikePlane < 250) then
                    {
                        _isRepathing = false;
                        _strikePlane setVariable ["needsRecalculation", false];
                        [3, format ["%1 repathing waypoint reached, attacking", _supportName], _fileName] call A3A_fnc_log;
                    };
                };
            }
            else
            {
                if(_isApproaching) then
                {
                    //Is on course to enter pos
                    //Recheck course
                    _targetPos = (getPos _targetObj) vectorAdd [0, 0, 2];
                    _targetVector = [400, 0];
                    _dir = (_strikePlane getDir _targetObj) + 90;
                    _targetVector = [_targetVector, -_dir] call BIS_fnc_rotateVector2D;
                    _targetVector pushBack 100;
                    _enterRunPos = _targetPos vectorAdd (_targetVector vectorMultiply 5);
                    _currentWaypoint setWaypointPosition [_enterRunPos, 0];
                    _strikePlane setVariable ["enterPos", _enterRunPos];

                    if (terrainIntersect [_targetPos, _enterRunPos]) then
                    {
                        //Something is in the way, repathing
                        [3, format ["After recalculation %1 way is no longer clear, repath", _supportName], _fileName] call A3A_fnc_log;
                        _strikePlane setVariable ["needsRecalculation", true];
                        _isRepathing = false;
                        _sleepTime = 5;
                        _isApproaching = false;
                    }
                    else
                    {
                        if(_strikePlane getVariable ["StartBombRun", false]) then
                        {
                            _strikePlane setVariable ["StartBombRun", false];
                            [_strikePlane, _targetObj, _supportName] spawn A3A_fnc_SUP_CASRun;
                            _isApproaching = false;
                            _sleepTime = 5;
                        };
                    };
                }
                else
                {
                    //Sets the approach vector
                    private _targetPos = (getPos _targetObj) vectorAdd [0, 0, 2];
                    private _targetVector = [400, 0];
                    private _dir = (_strikePlane getDir _targetObj) + 90;
                    _targetVector = [_targetVector, -_dir] call BIS_fnc_rotateVector2D;
                    _targetVector pushBack 100;
                    private _enterRunPos = _targetPos vectorAdd (_targetVector vectorMultiply 5);
                    _strikePlane setVariable ["enterPos", _enterRunPos];

                    private _wp1 = _strikeGroup addWaypoint [_enterRunPos, 0];
                    _wp1 setWaypointType "MOVE";
                    _wp1 setWaypointSpeed "FULL";
                    _strikeGroup setCurrentWaypoint _wp1;
                    _currentWaypoint = _wp1;

                    //Wait until run enter pos is reached
                    [_strikePlane] spawn
                    {
                        private _strikePlane = _this select 0;
                        waitUntil
                        {
                            sleep 0.1;
                            private _enterPos = _strikePlane getVariable ["enterPos", objNull];
                            (_enterPos isEqualType objNull) ||
                            {(_strikePlane distance2D (_strikePlane getVariable "enterPos")) < 25}
                        };
                        private _enterPos = _strikePlane getVariable ["enterPos", objNull];
                        if !(_enterPos isEqualType objNull) then
                        {
                            _strikePlane setVariable ["StartBombRun", true];
                        };
                    };

                    _isApproaching = true;
                    _sleepTime = 0.25;
                };
            };
        };
    };


    //Plane somehow destroyed
    if
    (
        !(alive _strikePlane) ||
        {({alive _x} count (units _strikeGroup)) == 0}
    ) exitWith
    {
        [2,format ["%1 has been destroyed or crew killed, aborting routine", _supportName],_fileName] call A3A_fnc_log;
        if(_side == Occupants) then
        {
            [[10, 45], [0, 0]] remoteExec ["A3A_fnc_prestige", 2];
        }
        else
        {
            [[0, 0], [10, 45]] remoteExec ["A3A_fnc_prestige", 2];
        };
    };

    //No missiles left
    if (_confirmedKills <= 0) exitWith
    {
        [2,format ["%1 has reached its kill limit, aborting routine", _supportName],_fileName] call A3A_fnc_log;
    };

    //Retreating
    if(_strikePlane getVariable ["Retreat", false]) exitWith
    {
        [2,format ["%1 met heavy resistance, retreating", _supportName], _fileName] call A3A_fnc_log;
    };

    //No ammo left
    if(_strikePlane getVariable ["OutOfAmmo", false]) exitWith
    {
        [2, format ["%1 run out of ammo, returning to base", _supportName], _fileName] call A3A_fnc_log;
    };

    sleep _sleepTime;
    _timeAlive = _timeAlive - _sleepTime;
};

_strikePlane setVariable ["currentTarget", nil];
_strikePlane setVariable ["enterPos", nil];

//Have the plane fly back home
if (alive _strikePlane && [driver _strikePlane] call A3A_fnc_canFight) then
{
    private _wpBase = _strikeGroup addWaypoint [getMarkerPos _airport, 0];
    _wpBase setWaypointType "MOVE";
    _wpBase setWaypointBehaviour "CARELESS";
    _wpBase setWaypointSpeed "FULL";
    _wpBase setWaypointStatements ["", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList"];
    _strikeGroup setCurrentWaypoint _wpBase;
};

//Deleting all the support data here
[_supportName, _side] call A3A_fnc_endSupport;
