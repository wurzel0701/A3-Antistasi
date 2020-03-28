params ["_box", "_caller", "_actionID", "_crateType"];

private _fileName = "grabSupplyCrate";

if(missionNamespace getVariable ["boxGetsGrabbed", false]) exitWith
{
    ["Supply Box", "Someone else is currently grabbing a supply box, please wait until they finished"] call A3A_fnc_customHint;
};
missionNamespace setVariable ["boxGetsGrabbed", true, true];

private _abort = false;
private _crateTypeBox = "";
private _crateTypeString = "";
switch (_crateType) do
{
    case 0:
    {
        _crateTypeBox = "Land_PaperBox_01_open_boxes_F";
        _crateTypeString = "Food";
    };
	case 1:
    {
        _crateTypeBox = "Land_PaperBox_01_open_water_F";
        _crateTypeString = "Water";
    };
	case 2:
    {
        _crateTypeBox = "CargoNet_01_barrels_F";
        _crateTypeString = "Fuel";
    };
	default
    {
        [1, format ["Bad parameter, should be 0, 1 or 2, got %1", _crateType], _fileName] call A3A_fnc_log;
		_abort = true;
	};
};

private _available = server getVariable "cratesAvailable";
if((_available select _crateType) <= 0) exitWith
{
    ["Supply Box", format ["There is currently no %1 crate available", _crateTypeString]] call A3A_fnc_customHint;
    missionNamespace setVariable ["boxGetsGrabbed", false, true];
};

player setVariable ["crateIndex", _crateType];
player setVariable ["crateString", _crateTypeString];

[_crateTypeBox, "SUPPLY"] spawn A3A_fnc_vehPlacementBegin;
