params ["_strikePlane", "_strikeGroup", "_airport", "_supportName", "_setupPos"];

private _fileName = "SUP_ASFRoutine";

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
_strikePlane flyInHeight 1000;

//Decrease time if aggro is low
private _sideAggression = if(_side == Occupants) then {aggressionOccupants} else {aggressionInvaders};
private _timeAlive = 600;
private _possibleKills = 3;//[_strikePlane, 0] call A3A_fnc_countMissiles;

if(_sideAggression < (30 + (random 40))) then
{
    _timeAlive = 300;
    //Plane needs to have at least 6 missiles in all cases
    _possibleKills = 2;
};

[_strikePlane, "AA"] call A3A_fnc_setPlaneLoadout;

_strikePlane setVariable ["InArea", false, true];
_strikePlane setVariable ["CurrentlyAttacking", false, true];

private _dir = (getPos _strikePlane) getDir _setupPos;

private _areaWP = _strikeGroup addWaypoint [_setupPos getPos [-2000, _dir], 1];
_areaWP setWaypointCombatMode "GREEN";
_areaWP setWaypointSpeed "FULL";
_areaWP setWaypointType "Move";
_areaWP setWaypointStatements ["true", "(vehicle this) setVariable ['InArea', true, true]; [3, 'ASF plane has arrived', 'ASFRoutine'] call A3A_fnc_log"];

private _loiterWP = _strikeGroup addWaypoint [_setupPos, 2];
_loiterWP setWaypointSpeed "NORMAL";
_loiterWP setWaypointType "Loiter";
_loiterWP setWaypointLoiterRadius 2000;

private _time = time;

waitUntil {sleep 1; !(alive _strikePlane) || (_strikePlane getVariable ["InArea", false])};

if !(alive _strikePlane) exitWith
{
    [_supportName, _side] call A3A_fnc_endSupport;
};

//_timeAlive = _timeAlive - (time - _time);

private _targetObj = objNull;
while {_timeAlive > 0} do
{
    if !(_strikePlane getVariable "CurrentlyAttacking") then
    {
        //[3, format ["Searching new target for %1", _supportName], _fileName] call A3A_fnc_log;
        //Plane is currently not attacking a target, search for new order
        private _targetList = server getVariable [format ["%1_targets", _supportName], []];
        if (count _targetList > 0) then
        {
            //New target active, read in
            private _target = _targetList deleteAt 0;
            server setVariable [format ["%1_targets", _supportName], _targetList, true];

            [3, format ["Next target for %2 is %1", _target, _supportName], _fileName] call A3A_fnc_log;

            //Parse targets
            private _targetParams = _target select 0;
            private _reveal = _target select 1;

            _targetObj = _targetParams select 0;
            private _precision = _targetParams select 1;
            private _targetPos = getPos _targetObj;

            _strikeGroup reveal [_targetObj, _precision];
            _strikePlane flyInHeight 250;

            //Show target to players if change is high enough
            private _textMarker = createMarker [format ["%1_text", _supportName], getPos _targetObj];
            _textMarker setMarkerShape "ICON";
            _textMarker setMarkerType "mil_objective";
            _textMarker setMarkerText "ASF Target";

            if(_side == Occupants) then
            {
                _textMarker setMarkerColor colorOccupants;
            }
            else
            {
                _textMarker setMarkerColor colorInvaders;
            };
            _textMarker setMarkerAlpha 0;

            [_textMarker, _targetObj, _strikePlane] spawn
            {
                params ["_textMarker", "_targetObj", "_strikePlane"];
                while {!(isNull _targetObj) && (alive _targetObj)} do
                {
                    _textMarker setMarkerPos (getPos _targetObj);

                    if((isNull _strikePlane) || !(alive _strikePlane)) exitWith {};

                    sleep 0.5;
                };
                deleteMarker _textMarker;
            };

            [_reveal, getPos _targetObj, _side, "ASF", "", _textMarker] spawn A3A_fnc_showInterceptedSupportCall;
            _strikePlane setVariable ["CurrentlyAttacking", true, true];

            private _attackWP = _strikeGroup addWaypoint [_targetPos, 3];
            _attackWP setWaypointType "DESTROY";
            _attackWP waypointAttachObject _targetObj;
            _attackWP setWaypointSpeed "FULL";
            _strikeGroup setCurrentWaypoint _attackWP;

            _strikeGroup setBehaviour "COMBAT";
            _strikeGroup setCombatMode "RED";
        };
    }
    else
    {
        if(isNull _targetObj || {!(alive _targetObj)}) then
        {
            _possibleKills = _possibleKills - 1;

            [3, format ["Target destroyed, %1 returns to cycle mode", _supportName], _fileName] call A3A_fnc_log;
            //Target destroyed
            _strikePlane setVariable ["CurrentlyAttacking", false, true];

            for "_i" from count waypoints _strikeGroup - 1 to 0 step -1 do
            {
                deleteWaypoint [_strikeGroup, _i];
            };

            private _loiterWP = _strikeGroup addWaypoint [_setupPos, 2];
            _loiterWP setWaypointSpeed "NORMAL";
            _loiterWP setWaypointType "Loiter";
            _loiterWP setWaypointLoiterRadius 2000;
            _strikeGroup setCurrentWaypoint _loiterWP;

            _strikeGroup setBehaviour "AWARE";
            _strikeGroup setCombatMode "GREEN";

            _strikePlane flyInHeight 1000;
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
            [[20, 45], [0, 0]] remoteExec ["A3A_fnc_prestige", 2];
        }
        else
        {
            [[0, 0], [20, 45]] remoteExec ["A3A_fnc_prestige", 2];
        };
    };

    //No missiles left
    if (!(_strikePlane getVariable "CurrentlyAttacking") && (_possibleKills <= 0)) exitWith
    {
        [2,format ["%1 has no more missiles left to fire, aborting routine", _supportName],_fileName] call A3A_fnc_log;
    };

    //Retreating
    if(_strikePlane getVariable ["Retreat", false]) exitWith
    {
        [2,format ["%1 met heavy resistance, retreating", _supportName], _fileName] call A3A_fnc_log;
    };

    sleep 5;
    _timeAlive = _timeAlive - 5;
};

//Have the plane fly back home
if (alive _strikePlane && {!(isNull (driver _strikePlane)) && {[driver _strikePlane] call A3A_fnc_canFight}}) then
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
