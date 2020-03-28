params ["_crate", "_crateType", "_crateString"];

/*  Initialises the supply crates with the logistics functions

    Execution on: HC or Server

    Scope: Internal

    Params:
        _crate : OBJECT : The supply crate
        _crateType : NUMBER : The crate type as 0 (Food), 1 (Water) or 2 (Fuel)
        _crateString : STRING : The type of the crate as a string

    Returns:
        Nothing
*/

//Set the needed variables
_crate setVariable ["crateType", _crateType, true];
_crate setVariable ["crateString", _crateString, true];

//Setting loading function
_crate call jn_fnc_logistics_addAction;

//Add the text on the map
[_crate, "Supply Box"] spawn A3A_fnc_inmuneConvoy;

_crate addEventHandler
[
    "Killed",
    {
        [_this select 0] spawn A3A_fnc_postmortem;
    }
];
