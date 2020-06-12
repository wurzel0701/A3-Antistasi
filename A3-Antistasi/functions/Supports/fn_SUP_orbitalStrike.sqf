[] spawn
{
private _impactPosition = AGLToASL (getMarkerPos "targetPos");

private _startPos = +_impactPosition;
_startPos set [2, (_startPos select 2) + 2000];

private _strikeObject = "Land_Battery_F" createVehicle _startPos;
_strikeObject setPosASL _startPos;
_strikeObject setVelocity [0,0,-300];

_grav_raza = "#particlesource" createVehicleLocal (getpos _strikeObject);
_grav_raza setParticleCircle [0, [0, 0, -3]];
_grav_raza setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_grav_raza setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 4, [0, 0, 0], [0, 0, 0], 150, 1, 5, 0, [15,11,7,3], [[1, 1, 1, 1],[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _strikeObject];
_grav_raza setDropInterval 0.0025;

private _grav_raza_v = objNull;
if (sunOrMoon==0) then
{
    _grav_raza_v = "#particlesource" createVehicleLocal (getpos _strikeObject);
    _grav_raza_v setParticleCircle [0, [0, 0, -3]];
    _grav_raza_v setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
    _grav_raza_v setParticleParams [["\A3\data_f\VolumeLight", 1, 0, 1], "", "SpaceObject", 1, 4, [0, 0, 0], [0, 0, 0], 150, 1, 5, 0, [8,6,3,1], [[1, 1, 1, 1],[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _strikeObject];
    //_grav_raza_v setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "SpaceObject", 1, 8, [0, 0, 0], [0, 0, 0],0, 1, 5, 0, [20,10,12,1], [[1, 1, 1, 1],[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _ray_gravity_client];
    _grav_raza_v setDropInterval 0.002;
};

_li1 = "#lightpoint" createVehicleLocal getpos _strikeObject;
_li1 setLightBrightness 150;
_li1 setLightAmbient[0,0.5,0.8];
_li1 setLightColor[0,0.5,0.8];
_li1 lightAttachObject [_strikeObject, [0,0,0]];

waitUntil {sleep 0.1; (getPosATL _strikeObject) select 2 < 1000};
hint "Play thunder now";

waitUntil {sleep 0.1; (getPosATL _strikeObject) select 2 < 25};
hint "Play impact sound now";



waitUntil {sleep 0.1; (getPosATL _strikeObject) select 2 < 10};
_strikeObject enableSimulation false;

[] spawn
{
    addCamShake [30, 2, 25];
    sleep 1;
    addCamShake [60, 6, 80];
    sleep 3;
    addCamShake [10, 25, 45];
};

_val = "#particlesource" createVehicleLocal getPos _strikeObject;
_val setParticleParams [["A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 7, 48], "", "Billboard", 1, 7, [0, 0, 0],[0, 0, 0], 0, 1.5, 1, 0, [10, 20], [[0.1, 0.1, 0.1, 0.5], [0.5, 0.5, 0.5, 0.5], [1, 1, 1, 0.3], [1, 1, 1, 0]], [1,0.5], 0.1, 1, "", "", _strikeObject];
_val setParticleRandom [2, [20, 20, 20], [5, 5, 0], 0, 0, [0, 0, 0, 0.1], 0, 0];
_val setParticleCircle [50, [-80, -80, 2.5]];
_val setDropInterval 0.0002;


[] spawn {
	sleep 5;
	"colorCorrections" ppEffectAdjust[1,0.5,0,[0,0,0,0.5],[1,1,1,2],[0,0,0,0]];

	"colorCorrections" ppEffectCommit 0;
	"colorCorrections" ppEffectEnable true;

	"filmGrain" ppEffectAdjust [0.5, 10, 2, 0.4, 0.4, true];
	"filmGrain" ppEffectCommit 0;
	"filmGrain" ppEffectEnable true;
};

[] spawn {
	cutText ["", "WHITE OUT", 1];
	//sleep 1;
	titleCut ["", "WHITE IN", 1];
	"dynamicBlur" ppEffectEnable true;
	"dynamicBlur" ppEffectAdjust [30];
	"dynamicBlur" ppEffectCommit 0;
	"dynamicBlur" ppEffectAdjust [0.0];

	"dynamicBlur" ppEffectCommit 15;
	sleep 15;
	"dynamicBlur" ppEffectEnable false;
};

//Impact effects
private _nearObjects = nearestObjects [_impactPosition, [], 250, true];

private _destroyCounter = 0;
{

    if(_x isKindOf "Man" || _x isKindOf "AllVehicles") then
    {
        private _dirVector = (getPosASL _x) vectorDiff _impactPosition;

        private _upForce = exp (- (0.0035 * (_dirVector select 2)) - (0.006 * (_x distance2D _impactPosition)));

        _dirVector set [2, 0];
        _dirVector = vectorNormalized _dirVector;

        _dirVector = _dirVector vectorMultiply 20;
        _dirVector set [2, 175 * _upForce];

        _x setVelocity _dirVector;

        _x setDamage 1; //(1 - (_x distance2D _impactPosition) - 100/250);
    }
    else
    {
        _x setDamage [1, false];
    };
    _destroyCounter = _destroyCounter + 1;
    if(_destroyCounter > 10) then
    {
        sleep 0.001;
        _destroyCounter = 0;
    };
} forEach _nearObjects;

[_grav_raza, _grav_raza_v, _strikeObject] spawn
{
    private _cloudEmitter = _this select 0;
    private _lightningEmitter = _this select 1;
    private _strikeObject = _this select 2;
    private _counter = 0;

    while {_counter < 8} do
    {
        _cloudEmitter setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 4 - (_counter * 0.5), [0, 0, 0], [0, 0, 0], 150, 1, 5, 0, [15,11,7,3], [[1, 1, 1, 1],[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _strikeObject];
        _lightningEmitter setParticleParams [["\A3\data_f\VolumeLight", 1, 0, 1], "", "SpaceObject", 1, 4 - (_counter * 0.5), [0, 0, 0], [0, 0, 0], 150, 1, 5, 0, [8,6,3,1], [[1, 1, 1, 1],[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _strikeObject];
        _counter = _counter + 1;
        sleep 0.5;
    };
};

sleep 4;

deleteVehicle _strikeObject;
deleteVehicle _li1;
};
