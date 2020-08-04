private _spawnPos = getMarkerPos "spawn";
_spawnPos = _spawnPos vectorAdd [0, 0, 50];

//Creates and anchor point in the world which can be used for attaching the launcher
private _holdObject = createVehicle ["Land_Battery_F", _spawnPos, [], 0, "CAN_COLLIDE"];
private _direction = _spawnPos getDir [worldSize/2, worldSize/2, 0];
_holdObject setDir _direction;
_holdObject enableSimulation false;
_holdObject hideObject true;

//Creates the launcher and attaches it to the anchor point
private _launcher = createVehicle ["B_Ship_MRLS_01_F", _spawnPos, [], 0, "CAN_COLLIDE"];
_launcher attachTo [_holdObject, [0, 0, 0]];
_launcher hideObject true;

//Create the crew and sets its AI
createVehicleCrew _launcher;
_launcher disableAI "Target";
_launcher disableAI "Autotarget";

//Creates the laser target to mark the target
private _laser = createVehicle ["LaserTargetE", (getPos target), [], 0, "CAN_COLLIDE"];
_laser attachTo [target, [0,0,2]];

//Send the laser target to the launcher
west reportRemoteTarget [_laser, 300];
_laser confirmSensorTarget [west, true];
_launcher fireAtTarget [_laser, "weapon_vls_01"];
