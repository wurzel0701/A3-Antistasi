[] spawn {
private _plane = plane;

_plane addEventHandler
[
    "Fired",
    {
        params ["_gunship", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

        private _target = _gunship getVariable ["currentTarget", objNull];
        if(_target isEqualTo objNull) exitWith {};

        if(_target isEqualType objNull) then
        {
            _target = getPosASL _target;
        };
        //CSAT rocket launcher
        if(_weapon == "rockets_Skyfire") then
        {
            _target = _target apply {_x + (random 20) - 10};
            [_projectile, _target] spawn
            {
                params ["_projectile", "_target"];
                sleep 0.25;
                private _speed = speed _projectile;
                while {!(isNull _projectile) && {alive _projectile}} do
                {
                    sleep 0.25;
                    private _dir = vectorNormalized (_target vectorDiff (getPosASL _projectile));
                    _projectile setVelocity (_dir vectorMultiply _speed);
                    _projectile setVectorDir _dir;
                };
            };
        };
        //CSAT gatling
        if(_weapon == "gatling_30mm_VTOL_02") then
        {
            _target = _target apply {_x + (random 10) - 5};
            private _speed = speed _projectile;
            private _dir = vectorNormalized (_target vectorDiff (getPosASL _projectile));
            _projectile setVelocity (_dir vectorMultiply _speed);
            _projectile setVectorDir _dir;
        };
    }
];

private _targetPos = getMarkerPos "supMarker";

(gunner _plane) doWatch _targetPos;
sleep 3;
(gunner _plane) doWatch objNull;

//Define the belts used against targets, true means HE round, false means AP round
private _antiInfBelt = [true, true, true, true, true];
private _antiLightVehicleBelt = [true, false, true, false, true];
private _antiAPCBelt = [false, true, false, true, false];
private _antiTankBelt = [false, false, false, false, false];

private _targets = _targetPos nearEntities [["Man", "LandVehicle", "Helicopter"], 250];
hint format ["Found %1 targets in the area", count _targets];

{
    _plane setVariable ["currentTarget", _x];
    (gunner _plane) reveal [_x, 3];
    (gunner _plane) doTarget _x;
    sleep 1.5;
    if !(_x isKindOf "LandVehicle") then
    {
        for "_i" from 1 to 5 do
        {
            (gunner _plane) forceWeaponFire ["HE", "close"];
            sleep 0.1;
        };
    }
    else
    {
        for "_i" from 1 to 10 do
        {
            (gunner _plane) forceWeaponFire ["rockets_Skyfire", "Burst"];
            sleep 0.1;
        };
    };
} forEach _targets;

_plane setVariable ["currentTarget", objNull];



};
