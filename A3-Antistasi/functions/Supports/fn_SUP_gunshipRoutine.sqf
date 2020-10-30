params ["_plane"];

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
            _target = _target apply {_x + (random 50) - 25};
            [_projectile, _target] spawn
            {
                params ["_projectile", "_target"];
                sleep 0.25;
                private _speed = speed _projectile;
                while {!(isNull _projectile) && {alive _projectile}} do
                {
                    /*
                    The missile will do a sharp 90 degree turn to hit its target

                    A smoother path is a bit more complex and not worth the work or computing time but here is the general idea
                    Take the normalised current dir and the normalised target vector and split transform them as follows
                    THIS IS NOT GUARANTEED TO BE RIGHT!!! CHECK BEFORE USING IT

                    private _alpha = atan (y/x)
                    private _beta = asin (z)

                    Now you got the vectors in polar form, and you are now able to calculate the degree diff between them

                    private _alphaDiff = (_alphaTarget - _alphaDir) % 180
                    private _betaDiff = (_betaTarget - _betaDir) % 180

                    To get a fixed turn rate, calculate the angle these two diff vectors are creating

                    private _turnAngle = atan (_alphaDiff/_betaDiff)

                    Now recalculate the actual lenght based on the turn limit (in degree)

                    private _limitAlpha = cos (_turnAngle) * TURN_LIMIT
                    private _limitBeta = sin (_turnAngle) * TURN_LIMIT

                    Check if _limitAlpha and _limitBeta are bigger than their diff values, if so, continue with diff values

                    Now create the new dir vector out of the data (make sure the _limit values has the right sign)

                    private _newAlpha = _alphaDir + _limitAlpha
                    private _newBeta = _betaDir + _limitBeta

                    private _newVectorZ = sin (_newBeta)
                    private _planeLength = cos (_newBeta)

                    private _newVectorX = cos (_newAlpha) * _planeLength
                    private _newVectorY = sin (_newAlpha) * _planeLength

                    private _newDir = [_newVectorX, _newVectorY, _newVectorZ]

                    This is the new dir vector which is also exact 1 long and therefor normalised

                    This useless code part was sponsored by ComboTombo
                    */


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
            _target = _target apply {_x + (random 15) - 7.5};
            private _speed = speed _projectile;
            private _dir = vectorNormalized (_target vectorDiff (getPosASL _projectile));
            _projectile setVelocity (_dir vectorMultiply _speed);
            _projectile setVectorDir _dir;
        };
    }
];

private _targetPos = getMarkerPos "supMarker";

private _targets = _targetPos nearEntities [["Man", "LandVehicle", "Helicopter"], 250];
hint format ["Found %1 targets in the area", count _targets];

{
    _plane setVariable ["currentTarget", _x];
    (gunner _plane) reveal [_x, 3];
    (gunner _plane) doTarget _x;
    sleep 1;
    for "_i" from 1 to 2 do
    {
        _plane fireAtTarget [_x, "HE"];
        sleep 0.03;
    };
} forEach _targets;




for "_i" from 1 to 10 do
{
    //(gunner _plane) forceWeaponFire ["rockets_Skyfire", "Burst"];
    //sleep 0.1;
};
