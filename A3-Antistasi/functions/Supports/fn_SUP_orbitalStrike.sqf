[] spawn
{
private _impactPosition = AGLToASL (getMarkerPos "targetPos");

private _startPos = +_impactPosition;
_startPos set [2, (_startPos select 2) + 2000];

private _strikeObject = "Land_Battery_F" createVehicle _startPos;
_strikeObject setPosASL _startPos;
_strikeObject setVelocity [0,0,-300];

private _players = allPlayers select {_x distance2D _impactPosition < 3000};

//LOCAL to client in the end
//[_strikeObject, _impactPosition] remoteExec ["A3A_fnc_orbitalStrikePlayerEffects" , _players];
_grav_raza = "#particlesource" createVehicleLocal (getpos _strikeObject);
_grav_raza setParticleCircle [0, [0, 0, -3]];
_grav_raza setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_grav_raza setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 8, [0, 0, 0], [0, 0, 0], 150, 1, 0, 0, [15,11,7,3], [[1, 1, 1, 1],[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _strikeObject];
_grav_raza setDropInterval 0.001;

_grav_raza_v = "#particlesource" createVehicleLocal (getpos _strikeObject);
_grav_raza_v setParticleCircle [0, [0, 0, -3]];
_grav_raza_v setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_grav_raza_v setParticleParams [["\A3\data_f\VolumeLight", 1, 0, 1], "", "SpaceObject", 1, 8, [0, 0, 0], [0, 0, 0], 150, 1, 0, 0, [6,4,2,1], [[1, 1, 1, 1],[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _strikeObject];
//_grav_raza_v setParticleParams [["\A3\data_f\kouleSvetlo", 1, 0, 1], "", "SpaceObject", 1, 8, [0, 0, 0], [0, 0, 0],0, 1, 5, 0, [20,10,12,1], [[1, 1, 1, 1],[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _ray_gravity_client];
_grav_raza_v setDropInterval 0.001;
//End local to client

_li1 = "#lightpoint" createVehicleLocal getpos _strikeObject;
_li1 setLightBrightness 150;
_li1 setLightAmbient[0,0.5,0.8];
_li1 setLightColor[0,0.5,0.8];
_li1 lightAttachObject [_strikeObject, [0,0,0]];

playSound "StrikeThunder";


waitUntil {sleep 0.1; (getPosATL _strikeObject) select 2 < 10};
_strikeObject enableSimulation false;

{
    [_x] spawn
    {
        params ["_player"];
        playSound "StrikeImpact";
        sleep 1;
        playSound "StrikeSound";
    };
} forEach _players;

_shockWaveParticle = "#particlesource" createVehicleLocal getPos _strikeObject;
_shockWaveParticle setParticleParams
[
    ["A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 7, 48],
    "",
    "Billboard",
    1,
    7,
    [0, 0, 0],
    [0, 0, 0],
    0,
    500,
    1,
    0,
    [50, 100],
    [[0.1, 0.1, 0.1, 0.5], [0.5, 0.5, 0.5, 0.5], [1, 1, 1, 0.3], [1, 1, 1, 0]],
    [1,0.5],
    0.1,
    1,
    "",
    "",
    _strikeObject
];
_shockWaveParticle setParticleRandom [2, [20, 20, 20], [5, 5, 0], 0, 0, [0, 0, 0, 0.1], 0, 0];
_shockWaveParticle setParticleCircle [50, [-80, -80, 2.5]];
_shockWaveParticle setDropInterval 0.0002;

deleteVehicle _grav_raza;

{
    [_x, _impactPosition, _strikeObject] spawn
    {
        _fn_playSoundTillDead =
        {
            params ["_sound", "_strikeObject", "_earthquakeStrength"];
            while {!(isNull _strikeObject)} do
            {
                playSound _sound;
                addCamShake [_earthquakeStrength, 20, 5];
                sleep 7;
            };
        };

        params ["_player", "_impactPosition", "_strikeObject"];
        private _distance = _player distance _impactPosition;
        if(_distance > 2000) exitWith {};
        if(_distance < 1000) then
        {

            if(_distance < 500) then
            {
                ["EarthquakeHeavy", _strikeObject, 15] spawn _fn_playSoundTillDead;
            }
            else
            {
                ["EarthquakeMore", _strikeObject, 10] spawn _fn_playSoundTillDead;
            };
        }
        else
        {
            if(_distance < 1500) then
            {
                ["EarthquakeLess", _strikeObject, 5] spawn _fn_playSoundTillDead;
            }
            else
            {
                ["EarthquakeLight", _strikeObject, 3] spawn _fn_playSoundTillDead;
            };
        };

        [_distance] spawn
        {
            private _distance = _this select 0;
            cutText ["", "WHITE OUT", 1];
        	titleCut ["", "WHITE IN", 1];
            private _value = 0;
            if(_distance < 1250) then
            {
                _value = 50 * (1 - (_distance/1250));
            };
        	"dynamicBlur" ppEffectEnable true;
        	"dynamicBlur" ppEffectAdjust [_value];
        	"dynamicBlur" ppEffectCommit 0;
        	"dynamicBlur" ppEffectAdjust [0.0];
        	"dynamicBlur" ppEffectCommit 5;
        	sleep 6;
        	"dynamicBlur" ppEffectEnable false;
        };
        if(_distance < 750) then
        {
            sleep (_distance/120);
            addCamShake [30 * (1 - (_distance/1000)), 6, 60];
        };

    };
} forEach _players;

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

        if(_x isKindOf "Man") then
        {
            _x setDamage (1 - (((_x distance2D _impactPosition) - 100)/200));
        }
        else
        {
            _x setDamage 1;
        };
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
deleteVehicle _shockWaveParticle;

[_li1] spawn
{
    private _light = _this select 0;
    private _lightCounter = 0;

    while {_lightCounter < 150} do
    {
        _light setLightBrightness (150 - _lightCounter);
        sleep (6/150);
        _lightCounter = _lightCounter + 1;
    };
};
sleep 4;
deleteVehicle _grav_raza_v;
sleep 4;
deleteVehicle _li1;
deleteVehicle _strikeObject;

};
