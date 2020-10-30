/*  Initialize the timers for the supports, so players dont get hit full force on restart

    Execution on: Server

    Scope: Internal

    Params:
        None

    Returns:
        Nothing
*/

occupantsAirstrikeTimer = [];
invadersAirstrikeTimer = [];
for "_i" from 0 to 1 do
{
    occupantsAirstrikeTimer pushBack (random 1200);
    invadersAirstrikeTimer pushBack (random 1200);
};

occupantsMortarTimer = [];
invadersMortarTimer = [];
for "_i" from 0 to 0 do
{
    occupantsMortarTimer pushBack (random 1800);
    invadersMortarTimer pushBack (random 1800);
};

occupantsCruiseMissileTimer = [];
invadersCruiseMissileTimer = [];
for "_i" from 0 to 0 do
{
    occupantsCruiseMissileTimer pushBack (random (3600 * 4));
    invadersCruiseMissileTimer pushBack (random (3600 * 4));
};

occupantsSAMTimer = [];
invadersSAMTimer = [];
for "_i" from 0 to 0 do
{
    occupantsSAMTimer pushBack (random (3600 * 2));
    invadersSAMTimer pushBack (random (3600 * 2));
};

occupantsCarpetBombTimer = [];
invadersCarpetBombTimer = [];
for "_i" from 0 to 0 do
{
    occupantsCarpetBombTimer pushBack (random (3600 * 3));
    invadersCarpetBombTimer pushBack (random (3600 * 3));
};

occupantsGunshipTimer = [];
invadersGunshipTimer = [];
for "_i" from 0 to 0 do
{
    occupantsGunshipTimer pushBack (random (3600 * 2.5));
    invadersGunshipTimer pushBack (random (3600 * 2.5));
};

occupantsASFTimer = [];
invadersASFTimer = [];
for "_i" from 0 to 0 do
{
    occupantsASFTimer pushBack (random (3600 * 2));
    invadersASFTimer pushBack (random (3600 * 2));
};

occupantsCASTimer = [];
invadersCASTimer = [];
for "_i" from 0 to 0 do
{
    occupantsCASTimer pushBack (random (3600 * 2));
    invadersCASTimer pushBack (random (3600 * 2));
};

occupantsOrbitalStrikeTimer = [random (3600 * 12)];
invadersOrbitalStrikeTimer = [random (3600 * 12)];
