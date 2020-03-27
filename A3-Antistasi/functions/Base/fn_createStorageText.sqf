#define RED     FF0000
#define ORANGE  FF8000
#define GREEN   00FF00
#define SILVER  C0C0C0

_fn_createColoredText =
{
    params ["_text", "_ratio"];
    private _parsed = "";
    if(_ratio <= 0.1) then
    {
        _parsed = format ["<t color='#FF0000'>%1</t>", _text];
    }
    else
    {
        if(_ratio <= 0.25) then
        {
            _parsed = format ["<t color='#FF8000'>%1</t>", _text];
        }
        else
        {
            if(_ratio <= 0.8) then
            {
                _parsed = format ["<t color='#00FF00'>%1</t>", _text];
            }
            else
            {
                _parsed = format ["<t color='#C0C0C0'>%1</t>", _text];
            };
        };
    };
    _parsed
};

params ["_supplySpace", "_supplyStored"];

private _ratio = [];
_ratio pushBack ((_supplyStored select 0)/(_supplySpace select 0));     //FOOD supplies
_ratio pushBack ((_supplyStored select 1)/(_supplySpace select 1));     //WATER supplies
_ratio pushBack ((_supplyStored select 2)/(_supplySpace select 2));     //FUEL supplies

private _text = "";
{
    private _ratioText = format ["%1/%2", (_supplyStored select _forEachIndex),(_supplySpace select _forEachIndex)];
    _ratioText = [_ratioText, _ratio select _forEachIndex] call _fn_createColoredText;
    _text = format ["%1%2: %3<br/>",_text, _x, _ratioText];
} forEach ["Food", "Water", "Fuel"];

_text;
